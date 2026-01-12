// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laboratory_technician_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LaboratoryTechnicianModelImpl _$$LaboratoryTechnicianModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LaboratoryTechnicianModelImpl(
      id: json['id'] as String,
      laboratoryId: json['laboratory_id'] as String,
      technicianId: json['technician_id'] as String,
      isActive: json['is_active'] as bool,
      isPrimaryTechnician: json['is_primary_technician'] as bool? ?? false,
      employmentStartDate: json['employment_start_date'] as String?,
      employmentEndDate: json['employment_end_date'] as String?,
      canCollectSamples: json['can_collect_samples'] as bool? ?? true,
      canPerformTests: json['can_perform_tests'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      doctorProfile: json['doctor_profiles'] == null
          ? null
          : DoctorProfileModel.fromJson(
              json['doctor_profiles'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$LaboratoryTechnicianModelImplToJson(
        _$LaboratoryTechnicianModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'laboratory_id': instance.laboratoryId,
      'technician_id': instance.technicianId,
      'is_active': instance.isActive,
      'is_primary_technician': instance.isPrimaryTechnician,
      'employment_start_date': instance.employmentStartDate,
      'employment_end_date': instance.employmentEndDate,
      'can_collect_samples': instance.canCollectSamples,
      'can_perform_tests': instance.canPerformTests,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'doctor_profiles': instance.doctorProfile,
      'profile': instance.profile,
    };
