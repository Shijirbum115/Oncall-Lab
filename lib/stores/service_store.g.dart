// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceStore on _ServiceStore, Store {
  late final _$categoriesAtom =
      Atom(name: '_ServiceStore.categories', context: context);

  @override
  ObservableList<ServiceCategoryModel> get categories {
    _$categoriesAtom.reportRead();
    return super.categories;
  }

  @override
  set categories(ObservableList<ServiceCategoryModel> value) {
    _$categoriesAtom.reportWrite(value, super.categories, () {
      super.categories = value;
    });
  }

  late final _$directServicesAtom =
      Atom(name: '_ServiceStore.directServices', context: context);

  @override
  ObservableList<Map<String, dynamic>> get directServices {
    _$directServicesAtom.reportRead();
    return super.directServices;
  }

  @override
  set directServices(ObservableList<Map<String, dynamic>> value) {
    _$directServicesAtom.reportWrite(value, super.directServices, () {
      super.directServices = value;
    });
  }

  late final _$laboratoryServicesCacheAtom =
      Atom(name: '_ServiceStore.laboratoryServicesCache', context: context);

  @override
  ObservableMap<String, List<LaboratoryServiceModel>>
      get laboratoryServicesCache {
    _$laboratoryServicesCacheAtom.reportRead();
    return super.laboratoryServicesCache;
  }

  @override
  set laboratoryServicesCache(
      ObservableMap<String, List<LaboratoryServiceModel>> value) {
    _$laboratoryServicesCacheAtom
        .reportWrite(value, super.laboratoryServicesCache, () {
      super.laboratoryServicesCache = value;
    });
  }

  late final _$doctorsForServiceCacheAtom =
      Atom(name: '_ServiceStore.doctorsForServiceCache', context: context);

  @override
  ObservableMap<String, List<Map<String, dynamic>>> get doctorsForServiceCache {
    _$doctorsForServiceCacheAtom.reportRead();
    return super.doctorsForServiceCache;
  }

  @override
  set doctorsForServiceCache(
      ObservableMap<String, List<Map<String, dynamic>>> value) {
    _$doctorsForServiceCacheAtom
        .reportWrite(value, super.doctorsForServiceCache, () {
      super.doctorsForServiceCache = value;
    });
  }

  late final _$serviceCacheAtom =
      Atom(name: '_ServiceStore.serviceCache', context: context);

  @override
  ObservableMap<String, ServiceModel> get serviceCache {
    _$serviceCacheAtom.reportRead();
    return super.serviceCache;
  }

  @override
  set serviceCache(ObservableMap<String, ServiceModel> value) {
    _$serviceCacheAtom.reportWrite(value, super.serviceCache, () {
      super.serviceCache = value;
    });
  }

  late final _$doctorServiceCacheAtom =
      Atom(name: '_ServiceStore.doctorServiceCache', context: context);

  @override
  ObservableMap<String, DoctorServiceModel> get doctorServiceCache {
    _$doctorServiceCacheAtom.reportRead();
    return super.doctorServiceCache;
  }

  @override
  set doctorServiceCache(ObservableMap<String, DoctorServiceModel> value) {
    _$doctorServiceCacheAtom.reportWrite(value, super.doctorServiceCache, () {
      super.doctorServiceCache = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_ServiceStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_ServiceStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadServiceCategoriesAsyncAction =
      AsyncAction('_ServiceStore.loadServiceCategories', context: context);

  @override
  Future<void> loadServiceCategories() {
    return _$loadServiceCategoriesAsyncAction
        .run(() => super.loadServiceCategories());
  }

  late final _$loadDirectServicesAsyncAction =
      AsyncAction('_ServiceStore.loadDirectServices', context: context);

  @override
  Future<void> loadDirectServices() {
    return _$loadDirectServicesAsyncAction
        .run(() => super.loadDirectServices());
  }

  late final _$getLaboratoryServicesAsyncAction =
      AsyncAction('_ServiceStore.getLaboratoryServices', context: context);

  @override
  Future<List<LaboratoryServiceModel>> getLaboratoryServices(
      String laboratoryId) {
    return _$getLaboratoryServicesAsyncAction
        .run(() => super.getLaboratoryServices(laboratoryId));
  }

  late final _$getDoctorsForServiceAsyncAction =
      AsyncAction('_ServiceStore.getDoctorsForService', context: context);

  @override
  Future<List<Map<String, dynamic>>> getDoctorsForService(String serviceId) {
    return _$getDoctorsForServiceAsyncAction
        .run(() => super.getDoctorsForService(serviceId));
  }

  late final _$fetchServiceByIdAsyncAction =
      AsyncAction('_ServiceStore.fetchServiceById', context: context);

  @override
  Future<ServiceModel> fetchServiceById(String serviceId) {
    return _$fetchServiceByIdAsyncAction
        .run(() => super.fetchServiceById(serviceId));
  }

  late final _$fetchDoctorServiceAsyncAction =
      AsyncAction('_ServiceStore.fetchDoctorService', context: context);

  @override
  Future<DoctorServiceModel> fetchDoctorService(
      {required String doctorId, required String serviceId}) {
    return _$fetchDoctorServiceAsyncAction.run(() =>
        super.fetchDoctorService(doctorId: doctorId, serviceId: serviceId));
  }

  late final _$searchServicesAsyncAction =
      AsyncAction('_ServiceStore.searchServices', context: context);

  @override
  Future<List<Map<String, dynamic>>> searchServices(String searchTerm) {
    return _$searchServicesAsyncAction
        .run(() => super.searchServices(searchTerm));
  }

  late final _$_ServiceStoreActionController =
      ActionController(name: '_ServiceStore', context: context);

  @override
  void clearCache() {
    final _$actionInfo = _$_ServiceStoreActionController.startAction(
        name: '_ServiceStore.clearCache');
    try {
      return super.clearCache();
    } finally {
      _$_ServiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_ServiceStoreActionController.startAction(
        name: '_ServiceStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_ServiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
categories: ${categories},
directServices: ${directServices},
laboratoryServicesCache: ${laboratoryServicesCache},
doctorsForServiceCache: ${doctorsForServiceCache},
serviceCache: ${serviceCache},
doctorServiceCache: ${doctorServiceCache},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
