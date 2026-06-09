import 'dart:async';
import 'dart:developer' as developer;

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/repositories/doctor_repository.dart';
import 'package:bugamed/data/repositories/service_repository.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

/// Maximum number of test types to display on home screen
const int maxTestTypesOnHome = 12;

/// Maximum number of doctors to display on home screen
const int maxDoctorsOnHome = 6;

abstract class _HomeStore with Store {
  _HomeStore(this._serviceRepository, this._doctorRepository);

  final ServiceRepository _serviceRepository;
  final DoctorRepository _doctorRepository;

  @observable
  ObservableList<Map<String, dynamic>> testTypes =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<Map<String, dynamic>> availableDoctors =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<Map<String, dynamic>> serviceCategories =
      ObservableList<Map<String, dynamic>>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  // Real-time subscription for doctor profiles
  StreamSubscription<List<Map<String, dynamic>>>? _doctorSubscription;

  // Real-time subscription for laboratory services (for test types)
  StreamSubscription<List<Map<String, dynamic>>>? _labServicesSubscription;

  // Concurrency control to prevent race conditions
  Completer<void>? _loadingCompleter;

  /// Load home data with concurrency control
  @action
  Future<void> loadHomeData() async {
    // If already loading, return the existing operation
    if (_loadingCompleter != null && !_loadingCompleter!.isCompleted) {
      return _loadingCompleter!.future;
    }

    _loadingCompleter = Completer<void>();
    isLoading = true;
    errorMessage = null;

    try {
      // Load data concurrently for better performance
      final testsFuture = _serviceRepository.getAggregatedTestTypes();
      final doctorsFuture = _doctorRepository.getAvailableDoctors();
      final categoriesFuture = _serviceRepository.getServiceCategories();

      testTypes = ObservableList.of((await testsFuture).take(maxTestTypesOnHome));
      availableDoctors =
          ObservableList.of((await doctorsFuture).take(maxDoctorsOnHome));
      serviceCategories = ObservableList.of(
        (await categoriesFuture).map(
          (c) => <String, dynamic>{
            'id': c.id,
            'name': c.name,
            'icon': c.iconName,
          },
        ),
      );

      _loadingCompleter!.complete();
    } catch (e) {
      errorMessage = e.toString();
      _loadingCompleter!.completeError(e);
    } finally {
      isLoading = false;
    }

    return _loadingCompleter!.future;
  }

  /// Start real-time subscriptions for live data updates
  @action
  void startRealtimeSubscriptions() {
    // Subscribe to doctor profile changes
    _doctorSubscription = supabase
        .from('doctor_profiles')
        .stream(primaryKey: ['id'])
        .eq('is_available', true)
        .listen(
          (data) {
            _handleDoctorUpdates(data);
          },
          onError: (error) {
            // Log error but don't disrupt the app
            developer.log(
              'Real-time doctor subscription error',
              name: 'HomeStore',
              error: error,
            );
          },
        );

    // Subscribe to laboratory services changes (affects test types pricing)
    _labServicesSubscription = supabase
        .from('laboratory_services')
        .stream(primaryKey: ['id'])
        .eq('is_available', true)
        .listen(
          (_) {
            // When lab services change, reload test types
            _reloadTestTypes();
          },
          onError: (error) {
            developer.log(
              'Real-time lab services subscription error',
              name: 'HomeStore',
              error: error,
            );
          },
        );
  }

  /// Handle doctor profile updates from real-time subscription
  @action
  Future<void> _handleDoctorUpdates(List<Map<String, dynamic>> data) async {
    try {
      // Reload doctors from repository to get full joined data
      final doctors = await _doctorRepository.getAvailableDoctors();
      availableDoctors = ObservableList.of(doctors.take(maxDoctorsOnHome));
    } catch (e) {
      developer.log(
        'Error reloading doctors after real-time update',
        name: 'HomeStore',
        error: e,
      );
    }
  }

  /// Reload test types when laboratory services change
  @action
  Future<void> _reloadTestTypes() async {
    try {
      final tests = await _serviceRepository.getAggregatedTestTypes();
      testTypes = ObservableList.of(tests.take(maxTestTypesOnHome));
    } catch (e) {
      developer.log(
        'Error reloading test types after real-time update',
        name: 'HomeStore',
        error: e,
      );
    }
  }

  /// Stop real-time subscriptions (call on dispose)
  void dispose() {
    _doctorSubscription?.cancel();
    _labServicesSubscription?.cancel();
  }
}

final GetIt _homeGetIt = GetIt.instance;

HomeStore get homeStore => _homeGetIt<HomeStore>();
