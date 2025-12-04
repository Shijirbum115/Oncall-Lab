import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:oncall_lab/data/repositories/test_request_repository.dart';
import 'package:oncall_lab/data/models/test_request_model.dart';

part 'test_request_store.g.dart';

class TestRequestStore = _TestRequestStore with _$TestRequestStore;

abstract class _TestRequestStore with Store {
  _TestRequestStore(this._repository);

  final TestRequestRepository _repository;

  StreamSubscription<List<TestRequestModel>>? _patientRequestsSubscription;
  StreamSubscription<List<TestRequestModel>>? _pendingRequestsSubscription;

  @observable
  ObservableList<TestRequestModel> patientRequests = ObservableList<TestRequestModel>();

  @observable
  ObservableList<TestRequestModel> pendingRequests = ObservableList<TestRequestModel>();

  @observable
  bool isLoading = false;

  @observable
  bool isCreating = false;

  @observable
  String? errorMessage;

  @observable
  Map<String, int> requestStats = {};

  @computed
  List<TestRequestModel> get activeRequests => patientRequests
      .where((r) =>
          r.status != RequestStatus.completed &&
          r.status != RequestStatus.cancelled)
      .toList();

  @computed
  List<TestRequestModel> get completedRequests =>
      patientRequests.where((r) => r.status == RequestStatus.completed).toList();

  @computed
  List<TestRequestModel> get cancelledRequests =>
      patientRequests.where((r) => r.status == RequestStatus.cancelled).toList();

  /// Create a lab service request
  @action
  Future<TestRequestModel?> createLabServiceRequest({
    required String patientId,
    required String laboratoryId,
    required String laboratoryServiceId,
    required String serviceId,
    required String scheduledDate,
    required String scheduledTimeSlot,
    required String patientAddress,
    required int priceMnt,
    double? patientLatitude,
    double? patientLongitude,
    String? patientNotes,
  }) async {
    isCreating = true;
    errorMessage = null;

    try {
      final request = await _repository.createLabServiceRequest(
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
        patientNotes: patientNotes,
      );

      // Add to patient requests
      patientRequests.insert(0, request);

      isCreating = false;
      return request;
    } catch (e) {
      errorMessage = e.toString();
      isCreating = false;
      return null;
    }
  }

  /// Create a direct service request
  @action
  Future<TestRequestModel?> createDirectServiceRequest({
    required String patientId,
    required String serviceId,
    required String scheduledDate,
    required String scheduledTimeSlot,
    required String patientAddress,
    required int priceMnt,
    String? doctorId,
    String? doctorServiceId,
    double? patientLatitude,
    double? patientLongitude,
    String? patientNotes,
  }) async {
    isCreating = true;
    errorMessage = null;

    try {
      final request = await _repository.createDirectServiceRequest(
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
        patientNotes: patientNotes,
      );

      // Add to patient requests
      patientRequests.insert(0, request);

      isCreating = false;
      return request;
    } catch (e) {
      errorMessage = e.toString();
      isCreating = false;
      return null;
    }
  }

  /// Load patient requests
  @action
  Future<void> loadPatientRequests(String patientId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final requests = await _repository.getPatientRequests(patientId);
      patientRequests = ObservableList.of(requests);

      // Also load stats
      await loadPatientStats(patientId);

      isLoading = false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
    }
  }

  /// Load patient request statistics
  @action
  Future<void> loadPatientStats(String patientId) async {
    try {
      requestStats = await _repository.getPatientRequestStats(patientId);
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  /// Load pending requests (for doctors)
  @action
  Future<void> loadPendingRequests({
    RequestType? requestType,
    String? serviceId,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final requests = await _repository.getPendingRequests(
        requestType: requestType,
        serviceId: serviceId,
      );
      pendingRequests = ObservableList.of(requests);
      isLoading = false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
    }
  }

  /// Update request status
  @action
  Future<bool> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? doctorId,
  }) async {
    errorMessage = null;

    try {
      final updatedRequest = await _repository.updateRequestStatus(
        requestId: requestId,
        status: status,
        doctorId: doctorId,
      );

      // Update in patient requests
      final index =
          patientRequests.indexWhere((r) => r.id == updatedRequest.id);
      if (index != -1) {
        patientRequests[index] = updatedRequest;
      }

      // Update in pending requests
      final pendingIndex =
          pendingRequests.indexWhere((r) => r.id == updatedRequest.id);
      if (pendingIndex != -1) {
        if (status == RequestStatus.accepted) {
          // Remove from pending if accepted
          pendingRequests.removeAt(pendingIndex);
        } else {
          pendingRequests[pendingIndex] = updatedRequest;
        }
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  /// Accept a request (doctor accepts)
  @action
  Future<bool> acceptRequest({
    required String requestId,
    required String doctorId,
  }) async {
    return updateRequestStatus(
      requestId: requestId,
      status: RequestStatus.accepted,
      doctorId: doctorId,
    );
  }

  /// Cancel a request
  @action
  Future<bool> cancelRequest({
    required String requestId,
    required String cancelledBy,
    String? cancellationReason,
  }) async {
    errorMessage = null;

    try {
      final cancelledRequest = await _repository.cancelRequest(
        requestId: requestId,
        cancelledBy: cancelledBy,
        cancellationReason: cancellationReason,
      );

      // Update in patient requests
      final index =
          patientRequests.indexWhere((r) => r.id == cancelledRequest.id);
      if (index != -1) {
        patientRequests[index] = cancelledRequest;
      }

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  // ============= REAL-TIME SUBSCRIPTIONS =============

  /// Subscribe to patient's requests in real-time
  @action
  void subscribeToPatientRequests(String patientId) {
    // Cancel existing subscription
    _patientRequestsSubscription?.cancel();

    // Subscribe to real-time updates
    _patientRequestsSubscription = _repository
        .streamPatientRequests(patientId)
        .listen(
          (requests) {
            patientRequests = ObservableList.of(requests);
            isLoading = false;
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
          },
        );
  }

  /// Subscribe to pending requests in real-time (for doctors)
  @action
  void subscribeToPendingRequests({
    RequestType? requestType,
    String? serviceId,
  }) {
    // Cancel existing subscription
    _pendingRequestsSubscription?.cancel();

    // Subscribe to real-time updates
    _pendingRequestsSubscription = _repository
        .streamPendingRequests(
          requestType: requestType,
          serviceId: serviceId,
        )
        .listen(
          (requests) {
            pendingRequests = ObservableList.of(requests);
            isLoading = false;
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
          },
        );
  }

  /// Unsubscribe from all real-time updates
  void dispose() {
    _patientRequestsSubscription?.cancel();
    _pendingRequestsSubscription?.cancel();
  }
}

final GetIt _testRequestGetIt = GetIt.instance;

TestRequestStore get testRequestStore => _testRequestGetIt<TestRequestStore>();
