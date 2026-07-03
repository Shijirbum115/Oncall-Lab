// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_request_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DoctorRequestStore on _DoctorRequestStore, Store {
  Computed<int>? _$availableRequestsCountComputed;

  @override
  int get availableRequestsCount => (_$availableRequestsCountComputed ??=
          Computed<int>(() => super.availableRequestsCount,
              name: '_DoctorRequestStore.availableRequestsCount'))
      .value;
  Computed<int>? _$myActiveRequestsCountComputed;

  @override
  int get myActiveRequestsCount => (_$myActiveRequestsCountComputed ??=
          Computed<int>(() => super.myActiveRequestsCount,
              name: '_DoctorRequestStore.myActiveRequestsCount'))
      .value;
  Computed<int>? _$myCompletedRequestsCountComputed;

  @override
  int get myCompletedRequestsCount => (_$myCompletedRequestsCountComputed ??=
          Computed<int>(() => super.myCompletedRequestsCount,
              name: '_DoctorRequestStore.myCompletedRequestsCount'))
      .value;

  late final _$availableRequestsAtom =
      Atom(name: '_DoctorRequestStore.availableRequests', context: context);

  @override
  ObservableList<TestRequestModel> get availableRequests {
    _$availableRequestsAtom.reportRead();
    return super.availableRequests;
  }

  @override
  set availableRequests(ObservableList<TestRequestModel> value) {
    _$availableRequestsAtom.reportWrite(value, super.availableRequests, () {
      super.availableRequests = value;
    });
  }

  late final _$myActiveRequestsAtom =
      Atom(name: '_DoctorRequestStore.myActiveRequests', context: context);

  @override
  ObservableList<TestRequestModel> get myActiveRequests {
    _$myActiveRequestsAtom.reportRead();
    return super.myActiveRequests;
  }

  @override
  set myActiveRequests(ObservableList<TestRequestModel> value) {
    _$myActiveRequestsAtom.reportWrite(value, super.myActiveRequests, () {
      super.myActiveRequests = value;
    });
  }

  late final _$myCompletedRequestsAtom =
      Atom(name: '_DoctorRequestStore.myCompletedRequests', context: context);

  @override
  ObservableList<TestRequestModel> get myCompletedRequests {
    _$myCompletedRequestsAtom.reportRead();
    return super.myCompletedRequests;
  }

  @override
  set myCompletedRequests(ObservableList<TestRequestModel> value) {
    _$myCompletedRequestsAtom.reportWrite(value, super.myCompletedRequests, () {
      super.myCompletedRequests = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_DoctorRequestStore.isLoading', context: context);

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
      Atom(name: '_DoctorRequestStore.errorMessage', context: context);

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

  late final _$loadAvailableRequestsAsyncAction = AsyncAction(
      '_DoctorRequestStore.loadAvailableRequests',
      context: context);

  @override
  Future<void> loadAvailableRequests(
      {RequestType? requestType, String? serviceId}) {
    return _$loadAvailableRequestsAsyncAction.run(() => super
        .loadAvailableRequests(requestType: requestType, serviceId: serviceId));
  }

  late final _$loadMyActiveRequestsAsyncAction =
      AsyncAction('_DoctorRequestStore.loadMyActiveRequests', context: context);

  @override
  Future<void> loadMyActiveRequests(String doctorId) {
    return _$loadMyActiveRequestsAsyncAction
        .run(() => super.loadMyActiveRequests(doctorId));
  }

  late final _$loadMyCompletedRequestsAsyncAction = AsyncAction(
      '_DoctorRequestStore.loadMyCompletedRequests',
      context: context);

  @override
  Future<void> loadMyCompletedRequests(String doctorId) {
    return _$loadMyCompletedRequestsAsyncAction
        .run(() => super.loadMyCompletedRequests(doctorId));
  }

  late final _$acceptRequestAsyncAction =
      AsyncAction('_DoctorRequestStore.acceptRequest', context: context);

  @override
  Future<TestRequestModel?> acceptRequest({required String requestId}) {
    return _$acceptRequestAsyncAction
        .run(() => super.acceptRequest(requestId: requestId));
  }

  late final _$updateRequestStatusAsyncAction =
      AsyncAction('_DoctorRequestStore.updateRequestStatus', context: context);

  @override
  Future<TestRequestModel?> updateRequestStatus(
      {required String requestId, required RequestStatus status}) {
    return _$updateRequestStatusAsyncAction.run(
        () => super.updateRequestStatus(requestId: requestId, status: status));
  }

  late final _$cancelRequestAsyncAction =
      AsyncAction('_DoctorRequestStore.cancelRequest', context: context);

  @override
  Future<TestRequestModel?> cancelRequest(
      {required String requestId,
      required String cancelledBy,
      String? cancellationReason}) {
    return _$cancelRequestAsyncAction.run(() => super.cancelRequest(
        requestId: requestId,
        cancelledBy: cancelledBy,
        cancellationReason: cancellationReason));
  }

  late final _$_DoctorRequestStoreActionController =
      ActionController(name: '_DoctorRequestStore', context: context);

  @override
  void subscribeToAvailableRequests(
      {RequestType? requestType, String? serviceId}) {
    final _$actionInfo = _$_DoctorRequestStoreActionController.startAction(
        name: '_DoctorRequestStore.subscribeToAvailableRequests');
    try {
      return super.subscribeToAvailableRequests(
          requestType: requestType, serviceId: serviceId);
    } finally {
      _$_DoctorRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void subscribeToMyActiveRequests(String doctorId) {
    final _$actionInfo = _$_DoctorRequestStoreActionController.startAction(
        name: '_DoctorRequestStore.subscribeToMyActiveRequests');
    try {
      return super.subscribeToMyActiveRequests(doctorId);
    } finally {
      _$_DoctorRequestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
availableRequests: ${availableRequests},
myActiveRequests: ${myActiveRequests},
myCompletedRequests: ${myCompletedRequests},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
availableRequestsCount: ${availableRequestsCount},
myActiveRequestsCount: ${myActiveRequestsCount},
myCompletedRequestsCount: ${myCompletedRequestsCount}
    ''';
  }
}
