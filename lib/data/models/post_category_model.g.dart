// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCategoryModelImpl _$$PostCategoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PostCategoryModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      nameMn: json['name_mn'] as String?,
      description: json['description'] as String?,
      iconName: json['icon_name'] as String?,
      colorHex: json['color_hex'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PostCategoryModelImplToJson(
        _$PostCategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_mn': instance.nameMn,
      'description': instance.description,
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
