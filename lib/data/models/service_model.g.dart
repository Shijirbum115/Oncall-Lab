// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceModelImpl _$$ServiceModelImplFromJson(Map<String, dynamic> json) =>
    _$ServiceModelImpl(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      name: json['name'] as String,
      nameMn: json['name_mn'] as String?,
      description: json['description'] as String?,
      descriptionMn: json['description_mn'] as String?,
      sampleType: json['sample_type'] as String?,
      equipmentNeeded: json['equipment_needed'] as String?,
      preparationInstructions: json['preparation_instructions'] as String?,
      estimatedDurationMinutes:
          (json['estimated_duration_minutes'] as num?)?.toInt(),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['service_categories'] == null
          ? null
          : ServiceCategoryModel.fromJson(
              json['service_categories'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ServiceModelImplToJson(_$ServiceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'name': instance.name,
      'name_mn': instance.nameMn,
      'description': instance.description,
      'description_mn': instance.descriptionMn,
      'sample_type': instance.sampleType,
      'equipment_needed': instance.equipmentNeeded,
      'preparation_instructions': instance.preparationInstructions,
      'estimated_duration_minutes': instance.estimatedDurationMinutes,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'service_categories': instance.category,
    };
