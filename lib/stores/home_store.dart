import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:oncall_lab/data/repositories/doctor_repository.dart';
import 'package:oncall_lab/data/repositories/service_repository.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

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
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadHomeData() async {
    isLoading = true;
    errorMessage = null;

    try {
      final tests = await _serviceRepository.getAggregatedTestTypes();
      final doctors = await _doctorRepository.getAvailableDoctors();
      testTypes = ObservableList.of(tests.take(12));
      availableDoctors = ObservableList.of(doctors);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }
}

final GetIt _homeGetIt = GetIt.instance;

HomeStore get homeStore => _homeGetIt<HomeStore>();
