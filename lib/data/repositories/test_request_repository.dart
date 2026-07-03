import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/test_request_model.dart';

/// Thrown when a doctor tries to accept a request that has already been
/// claimed by someone else (or cancelled). The caller should surface this
/// distinctly from generic errors.
class RequestUnavailableException implements Exception {
  final String message;
  const RequestUnavailableException([this.message = 'Request is no longer available']);
  @override
  String toString() => message;
}

class TestRequestRepository {
  /// Create a lab service request (patient books lab tests from a laboratory)
  Future<TestRequestModel> createLabServiceRequest({
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
    final data = await supabase.from('test_requests').insert({
      'request_type': 'lab_service',
      'patient_id': patientId,
      'laboratory_id': laboratoryId,
      'laboratory_service_id': laboratoryServiceId,
      'service_id': serviceId,
      'scheduled_date': scheduledDate,
      'scheduled_time_slot': scheduledTimeSlot,
      'patient_address': patientAddress,
      'patient_latitude': patientLatitude,
      'patient_longitude': patientLongitude,
      'patient_notes': patientNotes,
      'price_mnt': priceMnt,
      'status': 'pending',
    }).select().single();

    return TestRequestModel.fromJson(data);
  }

  /// Create a direct service request (patient books diagnostic/nursing services)
  Future<TestRequestModel> createDirectServiceRequest({
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
    final data = await supabase.from('test_requests').insert({
      'request_type': 'direct_service',
      'patient_id': patientId,
      'service_id': serviceId,
      'doctor_id': doctorId, // null if patient selected "any available doctor"
      'doctor_service_id': doctorServiceId,
      'scheduled_date': scheduledDate,
      'scheduled_time_slot': scheduledTimeSlot,
      'patient_address': patientAddress,
      'patient_latitude': patientLatitude,
      'patient_longitude': patientLongitude,
      'patient_notes': patientNotes,
      'price_mnt': priceMnt,
      'status': 'pending',
    }).select().single();

    return TestRequestModel.fromJson(data);
  }

  /// Get all requests for a patient
  Future<List<TestRequestModel>> getPatientRequests(String patientId) async {
    final data = await supabase
        .from('test_requests')
        .select()
        .eq('patient_id', patientId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => TestRequestModel.fromJson(json))
        .toList();
  }

  /// Get all requests for a doctor
  Future<List<TestRequestModel>> getDoctorRequests(String doctorId) async {
    final data = await supabase
        .from('test_requests')
        .select()
        .eq('doctor_id', doctorId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => TestRequestModel.fromJson(json))
        .toList();
  }

  /// Get doctor's active requests (accepted, on_the_way, sample_collected, delivered_to_lab)
  Future<List<TestRequestModel>> getDoctorActiveRequests(String doctorId) async {
    final data = await supabase
        .from('test_requests')
        .select()
        .eq('doctor_id', doctorId)
        .inFilter('status', ['accepted', 'on_the_way', 'sample_collected', 'delivered_to_lab'])
        .order('scheduled_date', ascending: true)
        .order('created_at', ascending: true);

    return (data as List)
        .map((json) => TestRequestModel.fromJson(json))
        .toList();
  }

  /// Get doctor's completed requests
  Future<List<TestRequestModel>> getDoctorCompletedRequests(String doctorId) async {
    final data = await supabase
        .from('test_requests')
        .select()
        .eq('doctor_id', doctorId)
        .eq('status', 'completed')
        .order('completed_at', ascending: false);

    return (data as List)
        .map((json) => TestRequestModel.fromJson(json))
        .toList();
  }

  /// Get pending requests (for doctors to view available requests)
  Future<List<TestRequestModel>> getPendingRequests({
    RequestType? requestType,
    String? serviceId,
  }) async {
    var query = supabase
        .from('test_requests')
        .select()
        .eq('status', 'pending')
        .isFilter('doctor_id', null); // Only requests without assigned doctor

    if (requestType != null) {
      query = query.eq('request_type', requestType.dbValue);
    }

    if (serviceId != null) {
      query = query.eq('service_id', serviceId);
    }

    final data = await query.order('created_at', ascending: true);

    return (data as List)
        .map((json) => TestRequestModel.fromJson(json))
        .toList();
  }

  /// Get a single request by ID
  Future<TestRequestModel> getRequestById(String requestId) async {
    final data =
        await supabase.from('test_requests').select().eq('id', requestId).single();

    return TestRequestModel.fromJson(data);
  }

  /// Update request status
  Future<TestRequestModel> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? doctorId,
  }) async {
    final updateData = <String, dynamic>{
      'status': status.dbValue,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Set timestamp based on status
    switch (status) {
      case RequestStatus.accepted:
        updateData['accepted_at'] = DateTime.now().toIso8601String();
        if (doctorId != null) {
          updateData['doctor_id'] = doctorId;
        }
        break;
      case RequestStatus.onTheWay:
        updateData['on_the_way_at'] = DateTime.now().toIso8601String();
        break;
      case RequestStatus.sampleCollected:
        updateData['sample_collected_at'] = DateTime.now().toIso8601String();
        break;
      case RequestStatus.deliveredToLab:
        updateData['delivered_to_lab_at'] = DateTime.now().toIso8601String();
        break;
      case RequestStatus.completed:
        updateData['completed_at'] = DateTime.now().toIso8601String();
        break;
      case RequestStatus.cancelled:
        updateData['cancelled_at'] = DateTime.now().toIso8601String();
        break;
      default:
        break;
    }

    final data = await supabase
        .from('test_requests')
        .update(updateData)
        .eq('id', requestId)
        .select()
        .single();

    return TestRequestModel.fromJson(data);
  }

  /// Accept a request (doctor accepts).
  /// The caller's identity is taken from the JWT server-side; the loser of a
  /// concurrent accept gets [RequestUnavailableException].
  Future<TestRequestModel> acceptRequest({required String requestId}) async {
    try {
      final data = await supabase.rpc(
        'accept_test_request',
        params: {'p_request_id': requestId},
      );
      return TestRequestModel.fromJson(data as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      if (e.code == 'P0002') {
        throw RequestUnavailableException(e.message);
      }
      rethrow;
    }
  }

  /// Cancel a request
  Future<TestRequestModel> cancelRequest({
    required String requestId,
    required String cancelledBy,
    String? cancellationReason,
  }) async {
    final data = await supabase
        .from('test_requests')
        .update({
          'status': 'cancelled',
          'cancelled_at': DateTime.now().toIso8601String(),
          'cancelled_by': cancelledBy,
          'cancellation_reason': cancellationReason,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', requestId)
        .select()
        .single();

    return TestRequestModel.fromJson(data);
  }

  /// Get request statistics for a patient
  Future<Map<String, int>> getPatientRequestStats(String patientId) async {
    final data = await supabase
        .from('test_requests')
        .select('status')
        .eq('patient_id', patientId);

    final stats = <String, int>{
      'total': data.length,
      'pending': 0,
      'accepted': 0,
      'in_progress': 0,
      'completed': 0,
      'cancelled': 0,
    };

    for (final item in data) {
      final status = item['status'] as String;
      if (status == 'pending') {
        stats['pending'] = (stats['pending'] ?? 0) + 1;
      } else if (status == 'accepted') {
        stats['accepted'] = (stats['accepted'] ?? 0) + 1;
      } else if (status == 'on_the_way' ||
          status == 'sample_collected' ||
          status == 'delivered_to_lab') {
        stats['in_progress'] = (stats['in_progress'] ?? 0) + 1;
      } else if (status == 'completed') {
        stats['completed'] = (stats['completed'] ?? 0) + 1;
      } else if (status == 'cancelled') {
        stats['cancelled'] = (stats['cancelled'] ?? 0) + 1;
      }
    }

    return stats;
  }

  // ============= REAL-TIME STREAMS =============

  /// Stream of pending requests (for doctors)
  Stream<List<TestRequestModel>> streamPendingRequests({
    RequestType? requestType,
    String? serviceId,
  }) {
    return supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('status', 'pending')
        .order('created_at', ascending: true)
        .map((data) {
          var requests = (data as List)
              .map((json) => TestRequestModel.fromJson(json))
              .where((request) => request.doctorId == null) // Filter where doctor_id is null
              .toList();

          // Apply optional filters
          if (requestType != null) {
            requests = requests.where((r) => r.requestType == requestType).toList();
          }

          if (serviceId != null) {
            requests = requests.where((r) => r.serviceId == serviceId).toList();
          }

          return requests;
        });
  }

  /// Stream of patient's own requests
  Stream<List<TestRequestModel>> streamPatientRequests(String patientId) {
    return supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('patient_id', patientId)
        .order('created_at', ascending: false)
        .map((data) => (data as List)
            .map((json) => TestRequestModel.fromJson(json))
            .toList());
  }

  /// Stream of doctor's active requests
  Stream<List<TestRequestModel>> streamDoctorActiveRequests(String doctorId) {
    final activeStatuses = [
      RequestStatus.accepted,
      RequestStatus.onTheWay,
      RequestStatus.sampleCollected,
      RequestStatus.deliveredToLab,
    ];

    return supabase
        .from('test_requests')
        .stream(primaryKey: ['id'])
        .eq('doctor_id', doctorId)
        .order('scheduled_date', ascending: true)
        .map((data) => (data as List)
            .map((json) => TestRequestModel.fromJson(json))
            .where((request) => activeStatuses.contains(request.status))
            .toList());
  }
}
