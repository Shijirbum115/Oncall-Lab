import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/data/repositories/test_request_repository.dart';

part 'doctor_request_store.g.dart';

class DoctorRequestStore = _DoctorRequestStore with _$DoctorRequestStore;

abstract class _DoctorRequestStore with Store {
  _DoctorRequestStore(this._repository);

  final TestRequestRepository _repository;

  StreamSubscription<List<TestRequestModel>>? _availableRequestsSubscription;
  StreamSubscription<List<TestRequestModel>>? _activeRequestsSubscription;

  @observable
  ObservableList<TestRequestModel> availableRequests = ObservableList<TestRequestModel>();

  @observable
  ObservableList<TestRequestModel> myActiveRequests = ObservableList<TestRequestModel>();

  @observable
  ObservableList<TestRequestModel> myCompletedRequests = ObservableList<TestRequestModel>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  /// Load available pending requests for the doctor to accept
  @action
  Future<void> loadAvailableRequests({
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
      availableRequests = ObservableList.of(requests);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  /// Load doctor's active requests (accepted, on_the_way, etc.)
  @action
  Future<void> loadMyActiveRequests(String doctorId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final requests = await _repository.getDoctorActiveRequests(doctorId);
      myActiveRequests = ObservableList.of(requests);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  /// Load doctor's completed requests
  @action
  Future<void> loadMyCompletedRequests(String doctorId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final requests = await _repository.getDoctorCompletedRequests(doctorId);
      myCompletedRequests = ObservableList.of(requests);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  /// Accept a pending request
  @action
  Future<TestRequestModel?> acceptRequest({
    required String requestId,
    required String doctorId,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final updatedRequest = await _repository.acceptRequest(
        requestId: requestId,
        doctorId: doctorId,
      );

      // Remove from available requests
      availableRequests.removeWhere((r) => r.id == requestId);

      // Add to my active requests
      myActiveRequests.insert(0, updatedRequest);

      return updatedRequest;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  /// Update request status
  @action
  Future<TestRequestModel?> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final updatedRequest = await _repository.updateRequestStatus(
        requestId: requestId,
        status: status,
      );

      // Update in my active requests
      final index = myActiveRequests.indexWhere((r) => r.id == requestId);
      if (index != -1) {
        if (status == RequestStatus.completed) {
          // Move to completed
          myActiveRequests.removeAt(index);
          myCompletedRequests.insert(0, updatedRequest);
        } else {
          myActiveRequests[index] = updatedRequest;
        }
      }

      return updatedRequest;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  /// Cancel a request
  @action
  Future<TestRequestModel?> cancelRequest({
    required String requestId,
    required String cancelledBy,
    String? cancellationReason,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final updatedRequest = await _repository.cancelRequest(
        requestId: requestId,
        cancelledBy: cancelledBy,
        cancellationReason: cancellationReason,
      );

      // Remove from active requests
      myActiveRequests.removeWhere((r) => r.id == requestId);
      availableRequests.removeWhere((r) => r.id == requestId);

      return updatedRequest;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  // ============= EARNINGS (from completed requests) =============

  bool _completedInPeriod(TestRequestModel r, DateTime from) {
    final ts = r.completedAt;
    if (ts == null) return false;
    final dt = DateTime.tryParse(ts)?.toLocal();
    if (dt == null) return false;
    return !dt.isBefore(from);
  }

  int _sumEarnings(Iterable<TestRequestModel> requests) =>
      requests.fold(0, (sum, r) => sum + r.doctorEarningsMnt);

  @computed
  int get totalEarningsMnt => _sumEarnings(myCompletedRequests);

  @computed
  int get todayEarningsMnt {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return _sumEarnings(
        myCompletedRequests.where((r) => _completedInPeriod(r, startOfDay)));
  }

  @computed
  int get weekEarningsMnt {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startOfWeek = startOfDay.subtract(Duration(days: now.weekday - 1));
    return _sumEarnings(
        myCompletedRequests.where((r) => _completedInPeriod(r, startOfWeek)));
  }

  @computed
  int get monthEarningsMnt {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month);
    return _sumEarnings(
        myCompletedRequests.where((r) => _completedInPeriod(r, startOfMonth)));
  }

  @computed
  int get availableRequestsCount => availableRequests.length;

  @computed
  int get myActiveRequestsCount => myActiveRequests.length;

  @computed
  int get myCompletedRequestsCount => myCompletedRequests.length;

  // ============= REAL-TIME SUBSCRIPTIONS =============

  /// Subscribe to available requests in real-time
  @action
  void subscribeToAvailableRequests({
    RequestType? requestType,
    String? serviceId,
  }) {
    // Cancel existing subscription
    _availableRequestsSubscription?.cancel();

    // Subscribe to real-time updates
    _availableRequestsSubscription = _repository
        .streamPendingRequests(
          requestType: requestType,
          serviceId: serviceId,
        )
        .listen(
          (requests) {
            availableRequests = ObservableList.of(requests);
            isLoading = false;
          },
          onError: (error) {
            errorMessage = error.toString();
            isLoading = false;
          },
        );
  }

  /// Subscribe to doctor's active requests in real-time
  @action
  void subscribeToMyActiveRequests(String doctorId) {
    // Cancel existing subscription
    _activeRequestsSubscription?.cancel();

    // Subscribe to real-time updates
    _activeRequestsSubscription = _repository
        .streamDoctorActiveRequests(doctorId)
        .listen(
          (requests) {
            myActiveRequests = ObservableList.of(requests);
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
    _availableRequestsSubscription?.cancel();
    _activeRequestsSubscription?.cancel();
  }
}

final GetIt _doctorRequestGetIt = GetIt.instance;

DoctorRequestStore get doctorRequestStore =>
    _doctorRequestGetIt<DoctorRequestStore>();
