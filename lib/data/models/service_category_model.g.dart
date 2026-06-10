// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceCategoryModelImpl _$$ServiceCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceCategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ServiceCategoryTypeEnumMap, json['type']),
      description: json['description'] as String?,
      nameMn: json['name_mn'] as String?,
      iconName: json['icon_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ServiceCategoryModelImplToJson(
        _$ServiceCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$ServiceCategoryTypeEnumMap[instance.type]!,
      'description': instance.description,
      'name_mn': instance.nameMn,
      'icon_name': instance.iconName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ServiceCategoryTypeEnumMap = {
  ServiceCategoryType.labTest: 'lab_test',
  ServiceCategoryType.diagnosticProcedure: 'diagnostic_procedure',
  ServiceCategoryType.nursingCare: 'nursing_care',
};
