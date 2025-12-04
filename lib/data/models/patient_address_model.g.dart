// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PatientAddressModelImpl _$$PatientAddressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PatientAddressModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      addressLine: json['address_line'] as String,
      apartmentNumber: json['apartment_number'] as String?,
      floor: json['floor'] as String?,
      doorNumber: json['door_number'] as String?,
      entrance: json['entrance'] as String?,
      buildingName: json['building_name'] as String?,
      additionalInfo: json['additional_info'] as String?,
      label: json['label'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PatientAddressModelImplToJson(
        _$PatientAddressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address_line': instance.addressLine,
      'apartment_number': instance.apartmentNumber,
      'floor': instance.floor,
      'door_number': instance.doorNumber,
      'entrance': instance.entrance,
      'building_name': instance.buildingName,
      'additional_info': instance.additionalInfo,
      'label': instance.label,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
