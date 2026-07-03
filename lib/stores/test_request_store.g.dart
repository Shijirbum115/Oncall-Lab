// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_request_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TestRequestStore on _TestRequestStore, Store {
  Computed<List<TestRequestModel>>? _$activeRequestsComputed;

  @override
  List<TestRequestModel> get activeRequests => (_$activeRequestsComputed ??=
          Computed<List<TestRequestModel>>(() => super.activeRequests,
              name: '_TestRequestStore.activeRequests'))
      .value;
  Computed<List<TestRequestModel>>? _$completedRequestsComputed;

  @override
  List<TestRequestModel> get completedRequests =>
      (_$completedRequestsComputed ??= Computed<List<TestRequestModel>>(
              () => super.completedRequests,
              name: '_TestRequestStore.completedRequests'))
          .value;
  Computed<List<TestRequestModel>>? _$cancelledRequestsComputed;

  @override
  List<TestRequestModel> get cancelledRequests =>
      (_$cancelledRequestsComputed ??= Computed<List<TestRequestModel>>(
              () => super.cancelledRequests,
              name: '_TestRequestStore.cancelledRequests'))
          .value;

  late final _$patientRequestsAtom =
      Atom(name: '_TestRequestStore.patientRequests', context: context);

  @override
  ObservableList<TestRequestModel> get patientRequests {
    _$patientRequestsAtom.reportRead();
    return super.patientRequests;
  }

  @override
  set patientRequests(ObservableList<TestRequestModel> value) {
    _$patientRequestsAtom.reportWrite(value, super.patientRequests, () {
      super.patientRequests = value;
    });
  }

  late final _$pendingRequestsAtom =
      Atom(name: '_TestRequestStore.pendingRequests', context: context);

  @override
  ObservableList<TestRequestModel> get pendingRequests {
    _$pendingRequestsAtom.reportRead();
    return super.pendingRequests;
  }

  @override
  set pendingRequests(ObservableList<TestRequestModel> value) {
    _$pendingRequestsAtom.reportWrite(value, super.pendingRequests, () {
      super.pendingRequests = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_TestRequestStore.isLoading', context: context);

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

  late final _$isCreatingAtom =
      Atom(name: '_TestRequestStore.isCreating', context: context);

  @override
  bool get isCreating {
    _$isCreatingAtom.reportRead();
    return super.isCreating;
  }

  @override
  set isCreating(bool value) {
    _$isCreatingAtom.reportWrite(value, super.isCreating, () {
      super.isCreating = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_TestRequestStore.errorMessage', context: context);

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

  late final _$requestStatsAtom =
      Atom(name: '_TestRequestStore.requestStats', context: context);

  @override
  Map<String, int> get requestStats {
    _$requestStatsAtom.reportRead();
    return super.requestStats;
  }

  @override
  set requestStats(Map<String, int> value) {
    _$requestStatsAtom.reportWrite(value, super.requestStats, () {
      super.requestStats = value;
    });
  }

  late final _$createLabServiceRequestAsyncAction = AsyncAction(
      '_TestRequestStore.createLabServiceRequest',
      context: context);

  @override
  Future<TestRequestModel?> createLabServiceRequest(
      {required String patientId,
      required String laboratoryId,
      required String laboratoryServiceId,
      required String serviceId,
      required String scheduledDate,
      required String scheduledTimeSlot,
      required String patientAddress,
      required int priceMnt,
      double? patientLatitude,
      double? patientLongitude,
      String? patientNotes}) {
    return _$createLabServiceRequestAsyncAction.run(() => super
        .createLabServiceRequest(
            patientId: patientId,
            laboratoryId: laboratoryId,
            laboratoryServiceId: laboratoryServiceId,
            serviceId: serviceId,
            scheduledDate: scheduledDate,
            scheduledTimeSlot: scheduledTimeSlot,
            patientAddress: patientAddress,
            priceMnt: priceMnt,
            patientLatitude: patientLatitude,
            patientLongitude: patientLongitude,
            patientNotes: patientNotes));
  }

  late final _$createDirectServiceRequestAsyncAction = AsyncAction(
      '_TestRequestStore.createDirectServiceRequest',
      context: context);

  @override
  Future<TestRequestModel?> createDirectServiceRequest(
      {required String patientId,
      required String serviceId,
      required String scheduledDate,
      required String scheduledTimeSlot,
      required String patientAddress,
      required int priceMnt,
      String? doctorId,
      String? doctorServiceId,
      double? patientLatitude,
      double? patientLongitude,
      String? patientNotes}) {
    return _$createDirectServiceRequestAsyncAction.run(() => super
        .createDirectServiceRequest(
            patientId: patientId,
            serviceId: serviceId,
            scheduledDate: scheduledDate,
            scheduledTimeSlot: scheduledTimeSlot,
            patientAddress: patientAddress,
            priceMnt: priceMnt,
            doctorId: doctorId,
            doctorServiceId: doctorServiceId,
            patientLatitude: patientLatitude,
            patientLongitude: patientLongitude,
            patientNotes: patientNotes));
  }

  late final _$loadPatientRequestsAsyncAction =
      AsyncAction('_TestRequestStore.loadPatientRequests', context: context);

  @override
  Future<void> loadPatientRequests(String patientId) {
    return _$loadPatientRequestsAsyncAction
        .run(() => super.loadPatientRequests(patientId));
  }

  late final _$loadPatientStatsAsyncAction =
      AsyncAction('_TestRequestStore.loadPatientStats', context: context);

  @override
  Future<void> loadPatientStats(String patientId) {
    return _$loadPatientStatsAsyncAction
        .run(() => super.loadPatientStats(patientId));
  }

  late final _$loadPendingRequestsAsyncAction =
      AsyncAction('_TestRequestStore.loadPendingRequests', context: context);

  @override
  Future<void> loadPendingRequests(
      {RequestType? requestType, String? serviceId}) {
    return _$loadPendingRequestsAsyncAction.run(() => super
        .loadPendingRequests(requestType: requestType, serviceId: serviceId));
  }

  late final _$updateRequestStatusAsyncAction =
      AsyncAction('_TestRequestStore.updateRequestStatus', context: context);

  @override
  Future<bool> updateRequestStatus(
      {required String requestId,
      required RequestStatus status,
      String? doctorId}) {
    return _$updateRequestStatusAsyncAction.run(() => super.updateRequestStatus(
        requestId: requestId, status: status, doctorId: doctorId));
  }

  late final _$acceptRequestAsyncAction =
      AsyncAction('_TestRequestStore.acceptRequest', context: context);

  @override
  Future<bool> acceptRequest({required String requestId}) {
    return _$acceptRequestAsyncAction
        .run(() => super.acceptRequest(requestId: requestId));
  }

  late final _$cancelRequestAsyncAction =
      AsyncAction('_TestRequestStore.cancelRequest', context: context);

  @override
  Future<bool> cancelRequest(
      {required String requestId,
      required String cancelledBy,
      String? cancellationReason}) {
    return _$cancelRequestAsyncAction.run(() => super.cancelRequest(
        requestId: requestId,
        cancelledBy: cancelledBy,
        cancellationReason: cancellationReason));
  }

  late final _$_TestRequestStoreActionController =
      ActionController(name: '_TestRequestStore', context: context);

  @override
  void clearError() {
    final _$actionInfo = _$_TestRequestStoreActionController.startAction(
        name: '_TestRequestStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_TestRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void subscribeToPatientRequests(String patientId) {
    final _$actionInfo = _$_TestRequestStoreActionController.startAction(
        name: '_TestRequestStore.subscribeToPatientRequests');
    try {
      return super.subscribeToPatientRequests(patientId);
    } finally {
      _$_TestRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void subscribeToPendingRequests(
      {RequestType? requestType, String? serviceId}) {
    final _$actionInfo = _$_TestRequestStoreActionController.startAction(
        name: '_TestRequestStore.subscribeToPendingRequests');
    try {
      return super.subscribeToPendingRequests(
          requestType: requestType, serviceId: serviceId);
    } finally {
      _$_TestRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
patientRequests: ${patientRequests},
pendingRequests: ${pendingRequests},
isLoading: ${isLoading},
isCreating: ${isCreating},
errorMessage: ${errorMessage},
requestStats: ${requestStats},
activeRequests: ${activeRequests},
completedRequests: ${completedRequests},
cancelledRequests: ${cancelledRequests}
    ''';
  }
}
