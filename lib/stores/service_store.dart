import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:oncall_lab/data/models/doctor_service_model.dart';
import 'package:oncall_lab/data/models/service_category_model.dart';
import 'package:oncall_lab/data/models/service_model.dart';
import 'package:oncall_lab/data/models/laboratory_service_model.dart';
import 'package:oncall_lab/data/repositories/service_repository.dart';

part 'service_store.g.dart';

class ServiceStore = _ServiceStore with _$ServiceStore;

abstract class _ServiceStore with Store {
  _ServiceStore(this._repository);

  final ServiceRepository _repository;

  @observable
  ObservableList<ServiceCategoryModel> categories =
      ObservableList<ServiceCategoryModel>();

  @observable
  ObservableList<Map<String, dynamic>> directServices =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableMap<String, List<LaboratoryServiceModel>> laboratoryServicesCache =
      ObservableMap<String, List<LaboratoryServiceModel>>();

  @observable
  ObservableMap<String, List<Map<String, dynamic>>> doctorsForServiceCache =
      ObservableMap<String, List<Map<String, dynamic>>>();

  @observable
  ObservableMap<String, ServiceModel> serviceCache =
      ObservableMap<String, ServiceModel>();

  @observable
  ObservableMap<String, DoctorServiceModel> doctorServiceCache =
      ObservableMap<String, DoctorServiceModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> loadServiceCategories() async {
    isLoading = true;
    errorMessage = null;

    try {
      final data = await _repository.getServiceCategories();
      categories = ObservableList.of(data);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadDirectServices() async {
    isLoading = true;
    errorMessage = null;

    try {
      final data = await _repository.getDirectServices();
      directServices = ObservableList.of(data);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<List<LaboratoryServiceModel>> getLaboratoryServices(
      String laboratoryId) async {
    // Check cache first
    if (laboratoryServicesCache.containsKey(laboratoryId)) {
      return laboratoryServicesCache[laboratoryId]!;
    }

    isLoading = true;
    errorMessage = null;

    try {
      final data = await _repository.getLaboratoryServices(laboratoryId);
      laboratoryServicesCache[laboratoryId] = data;
      return data;
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<List<Map<String, dynamic>>> getDoctorsForService(
      String serviceId) async {
    // Check cache first
    if (doctorsForServiceCache.containsKey(serviceId)) {
      return doctorsForServiceCache[serviceId]!;
    }

    isLoading = true;
    errorMessage = null;

    try {
      final data = await _repository.getDoctorsForService(serviceId);
      doctorsForServiceCache[serviceId] = data;
      return data;
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<ServiceModel> fetchServiceById(String serviceId) async {
    if (serviceCache.containsKey(serviceId)) {
      return serviceCache[serviceId]!;
    }

    try {
      final service = await _repository.getServiceById(serviceId);
      serviceCache[serviceId] = service;
      return service;
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<DoctorServiceModel> fetchDoctorService({
    required String doctorId,
    required String serviceId,
  }) async {
    final cacheKey = '${doctorId}_$serviceId';
    if (doctorServiceCache.containsKey(cacheKey)) {
      return doctorServiceCache[cacheKey]!;
    }

    try {
      final doctorService = await _repository.getDoctorServiceByDoctor(
        doctorId: doctorId,
        serviceId: serviceId,
      );
      doctorServiceCache[cacheKey] = doctorService;
      return doctorService;
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    }
  }

  @action
  Future<List<Map<String, dynamic>>> searchServices(String searchTerm) async {
    if (searchTerm.isEmpty) return [];

    try {
      return await _repository.searchServices(searchTerm);
    } catch (e) {
      errorMessage = e.toString();
      return [];
    }
  }

  @action
  void clearCache() {
    laboratoryServicesCache.clear();
    doctorsForServiceCache.clear();
    serviceCache.clear();
    doctorServiceCache.clear();
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}

final GetIt _serviceGetIt = GetIt.instance;

ServiceStore get serviceStore => _serviceGetIt<ServiceStore>();
