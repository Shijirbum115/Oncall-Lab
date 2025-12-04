// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TestRequestModelImpl _$$TestRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TestRequestModelImpl(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String?,
      laboratoryId: json['laboratory_id'] as String?,
      requestType: $enumDecode(_$RequestTypeEnumMap, json['request_type']),
      serviceId: json['service_id'] as String?,
      laboratoryServiceId: json['laboratory_service_id'] as String?,
      doctorServiceId: json['doctor_service_id'] as String?,
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      scheduledDate: json['scheduled_date'] as String,
      scheduledTimeSlot: json['scheduled_time_slot'] as String?,
      patientAddress: json['patient_address'] as String,
      patientLatitude: (json['patient_latitude'] as num?)?.toDouble(),
      patientLongitude: (json['patient_longitude'] as num?)?.toDouble(),
      patientNotes: json['patient_notes'] as String?,
      acceptedAt: json['accepted_at'] as String?,
      onTheWayAt: json['on_the_way_at'] as String?,
      sampleCollectedAt: json['sample_collected_at'] as String?,
      deliveredToLabAt: json['delivered_to_lab_at'] as String?,
      completedAt: json['completed_at'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      priceMnt: (json['price_mnt'] as num).toInt(),
      doctorCommissionMnt: (json['doctor_commission_mnt'] as num?)?.toInt(),
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledBy: json['cancelled_by'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$TestRequestModelImplToJson(
        _$TestRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'doctor_id': instance.doctorId,
      'laboratory_id': instance.laboratoryId,
      'request_type': _$RequestTypeEnumMap[instance.requestType]!,
      'service_id': instance.serviceId,
      'laboratory_service_id': instance.laboratoryServiceId,
      'doctor_service_id': instance.doctorServiceId,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'scheduled_date': instance.scheduledDate,
      'scheduled_time_slot': instance.scheduledTimeSlot,
      'patient_address': instance.patientAddress,
      'patient_latitude': instance.patientLatitude,
      'patient_longitude': instance.patientLongitude,
      'patient_notes': instance.patientNotes,
      'accepted_at': instance.acceptedAt,
      'on_the_way_at': instance.onTheWayAt,
      'sample_collected_at': instance.sampleCollectedAt,
      'delivered_to_lab_at': instance.deliveredToLabAt,
      'completed_at': instance.completedAt,
      'cancelled_at': instance.cancelledAt,
      'price_mnt': instance.priceMnt,
      'doctor_commission_mnt': instance.doctorCommissionMnt,
      'cancellation_reason': instance.cancellationReason,
      'cancelled_by': instance.cancelledBy,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

const _$RequestTypeEnumMap = {
  RequestType.labService: 'lab_service',
  RequestType.directService: 'direct_service',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.accepted: 'accepted',
  RequestStatus.onTheWay: 'on_the_way',
  RequestStatus.sampleCollected: 'sample_collected',
  RequestStatus.deliveredToLab: 'delivered_to_lab',
  RequestStatus.completed: 'completed',
  RequestStatus.cancelled: 'cancelled',
};
