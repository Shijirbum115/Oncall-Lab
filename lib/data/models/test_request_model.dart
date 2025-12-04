// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_request_model.freezed.dart';
part 'test_request_model.g.dart';

enum RequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('on_the_way')
  onTheWay,
  @JsonValue('sample_collected')
  sampleCollected,
  @JsonValue('delivered_to_lab')
  deliveredToLab,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

extension RequestStatusX on RequestStatus {
  String get dbValue {
    switch (this) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.onTheWay:
        return 'on_the_way';
      case RequestStatus.sampleCollected:
        return 'sample_collected';
      case RequestStatus.deliveredToLab:
        return 'delivered_to_lab';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }
}

enum RequestType {
  @JsonValue('lab_service')
  labService,
  @JsonValue('direct_service')
  directService,
}

extension RequestTypeX on RequestType {
  String get dbValue {
    switch (this) {
      case RequestType.labService:
        return 'lab_service';
      case RequestType.directService:
        return 'direct_service';
    }
  }
}

@freezed
class TestRequestModel with _$TestRequestModel {
  const factory TestRequestModel({
    required String id,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'doctor_id') String? doctorId,
    @JsonKey(name: 'laboratory_id') String? laboratoryId,
    @JsonKey(name: 'request_type') required RequestType requestType,
    @JsonKey(name: 'service_id') String? serviceId,
    @JsonKey(name: 'laboratory_service_id') String? laboratoryServiceId,
    @JsonKey(name: 'doctor_service_id') String? doctorServiceId,
    required RequestStatus status,
    @JsonKey(name: 'scheduled_date') required String scheduledDate,
    @JsonKey(name: 'scheduled_time_slot') String? scheduledTimeSlot,
    @JsonKey(name: 'patient_address') required String patientAddress,
    @JsonKey(name: 'patient_latitude') double? patientLatitude,
    @JsonKey(name: 'patient_longitude') double? patientLongitude,
    @JsonKey(name: 'patient_notes') String? patientNotes,
    @JsonKey(name: 'accepted_at') String? acceptedAt,
    @JsonKey(name: 'on_the_way_at') String? onTheWayAt,
    @JsonKey(name: 'sample_collected_at') String? sampleCollectedAt,
    @JsonKey(name: 'delivered_to_lab_at') String? deliveredToLabAt,
    @JsonKey(name: 'completed_at') String? completedAt,
    @JsonKey(name: 'cancelled_at') String? cancelledAt,
    @JsonKey(name: 'price_mnt') required int priceMnt,
    @JsonKey(name: 'doctor_commission_mnt') int? doctorCommissionMnt,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,
    @JsonKey(name: 'cancelled_by') String? cancelledBy,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _TestRequestModel;

  factory TestRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TestRequestModelFromJson(json);
}
