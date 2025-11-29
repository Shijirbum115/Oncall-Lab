// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PatientAddressModel _$PatientAddressModelFromJson(Map<String, dynamic> json) {
  return _PatientAddressModel.fromJson(json);
}

/// @nodoc
mixin _$PatientAddressModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId =>
      throw _privateConstructorUsedError; // Location coordinates
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError; // Address details
  @JsonKey(name: 'address_line')
  String get addressLine => throw _privateConstructorUsedError;
  @JsonKey(name: 'apartment_number')
  String? get apartmentNumber => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  @JsonKey(name: 'door_number')
  String? get doorNumber => throw _privateConstructorUsedError;
  String? get entrance => throw _privateConstructorUsedError;
  @JsonKey(name: 'building_name')
  String? get buildingName => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_info')
  String? get additionalInfo => throw _privateConstructorUsedError; // Metadata
  String? get label =>
      throw _privateConstructorUsedError; // e.g., "Home", "Work", "Parent's House"
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PatientAddressModelCopyWith<PatientAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientAddressModelCopyWith<$Res> {
  factory $PatientAddressModelCopyWith(
          PatientAddressModel value, $Res Function(PatientAddressModel) then) =
      _$PatientAddressModelCopyWithImpl<$Res, PatientAddressModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      double latitude,
      double longitude,
      @JsonKey(name: 'address_line') String addressLine,
      @JsonKey(name: 'apartment_number') String? apartmentNumber,
      String? floor,
      @JsonKey(name: 'door_number') String? doorNumber,
      String? entrance,
      @JsonKey(name: 'building_name') String? buildingName,
      @JsonKey(name: 'additional_info') String? additionalInfo,
      String? label,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PatientAddressModelCopyWithImpl<$Res, $Val extends PatientAddressModel>
    implements $PatientAddressModelCopyWith<$Res> {
  _$PatientAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? addressLine = null,
    Object? apartmentNumber = freezed,
    Object? floor = freezed,
    Object? doorNumber = freezed,
    Object? entrance = freezed,
    Object? buildingName = freezed,
    Object? additionalInfo = freezed,
    Object? label = freezed,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      addressLine: null == addressLine
          ? _value.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String,
      apartmentNumber: freezed == apartmentNumber
          ? _value.apartmentNumber
          : apartmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      doorNumber: freezed == doorNumber
          ? _value.doorNumber
          : doorNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      entrance: freezed == entrance
          ? _value.entrance
          : entrance // ignore: cast_nullable_to_non_nullable
              as String?,
      buildingName: freezed == buildingName
          ? _value.buildingName
          : buildingName // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientAddressModelImplCopyWith<$Res>
    implements $PatientAddressModelCopyWith<$Res> {
  factory _$$PatientAddressModelImplCopyWith(_$PatientAddressModelImpl value,
          $Res Function(_$PatientAddressModelImpl) then) =
      __$$PatientAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      double latitude,
      double longitude,
      @JsonKey(name: 'address_line') String addressLine,
      @JsonKey(name: 'apartment_number') String? apartmentNumber,
      String? floor,
      @JsonKey(name: 'door_number') String? doorNumber,
      String? entrance,
      @JsonKey(name: 'building_name') String? buildingName,
      @JsonKey(name: 'additional_info') String? additionalInfo,
      String? label,
      @JsonKey(name: 'is_default') bool isDefault,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PatientAddressModelImplCopyWithImpl<$Res>
    extends _$PatientAddressModelCopyWithImpl<$Res, _$PatientAddressModelImpl>
    implements _$$PatientAddressModelImplCopyWith<$Res> {
  __$$PatientAddressModelImplCopyWithImpl(_$PatientAddressModelImpl _value,
      $Res Function(_$PatientAddressModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? addressLine = null,
    Object? apartmentNumber = freezed,
    Object? floor = freezed,
    Object? doorNumber = freezed,
    Object? entrance = freezed,
    Object? buildingName = freezed,
    Object? additionalInfo = freezed,
    Object? label = freezed,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PatientAddressModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      addressLine: null == addressLine
          ? _value.addressLine
          : addressLine // ignore: cast_nullable_to_non_nullable
              as String,
      apartmentNumber: freezed == apartmentNumber
          ? _value.apartmentNumber
          : apartmentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      doorNumber: freezed == doorNumber
          ? _value.doorNumber
          : doorNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      entrance: freezed == entrance
          ? _value.entrance
          : entrance // ignore: cast_nullable_to_non_nullable
              as String?,
      buildingName: freezed == buildingName
          ? _value.buildingName
          : buildingName // ignore: cast_nullable_to_non_nullable
              as String?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientAddressModelImpl extends _PatientAddressModel {
  const _$PatientAddressModelImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.latitude,
      required this.longitude,
      @JsonKey(name: 'address_line') required this.addressLine,
      @JsonKey(name: 'apartment_number') this.apartmentNumber,
      this.floor,
      @JsonKey(name: 'door_number') this.doorNumber,
      this.entrance,
      @JsonKey(name: 'building_name') this.buildingName,
      @JsonKey(name: 'additional_info') this.additionalInfo,
      this.label,
      @JsonKey(name: 'is_default') this.isDefault = false,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$PatientAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientAddressModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
// Location coordinates
  @override
  final double latitude;
  @override
  final double longitude;
// Address details
  @override
  @JsonKey(name: 'address_line')
  final String addressLine;
  @override
  @JsonKey(name: 'apartment_number')
  final String? apartmentNumber;
  @override
  final String? floor;
  @override
  @JsonKey(name: 'door_number')
  final String? doorNumber;
  @override
  final String? entrance;
  @override
  @JsonKey(name: 'building_name')
  final String? buildingName;
  @override
  @JsonKey(name: 'additional_info')
  final String? additionalInfo;
// Metadata
  @override
  final String? label;
// e.g., "Home", "Work", "Parent's House"
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PatientAddressModel(id: $id, userId: $userId, latitude: $latitude, longitude: $longitude, addressLine: $addressLine, apartmentNumber: $apartmentNumber, floor: $floor, doorNumber: $doorNumber, entrance: $entrance, buildingName: $buildingName, additionalInfo: $additionalInfo, label: $label, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientAddressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.addressLine, addressLine) ||
                other.addressLine == addressLine) &&
            (identical(other.apartmentNumber, apartmentNumber) ||
                other.apartmentNumber == apartmentNumber) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.doorNumber, doorNumber) ||
                other.doorNumber == doorNumber) &&
            (identical(other.entrance, entrance) ||
                other.entrance == entrance) &&
            (identical(other.buildingName, buildingName) ||
                other.buildingName == buildingName) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      latitude,
      longitude,
      addressLine,
      apartmentNumber,
      floor,
      doorNumber,
      entrance,
      buildingName,
      additionalInfo,
      label,
      isDefault,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientAddressModelImplCopyWith<_$PatientAddressModelImpl> get copyWith =>
      __$$PatientAddressModelImplCopyWithImpl<_$PatientAddressModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientAddressModelImplToJson(
      this,
    );
  }
}

abstract class _PatientAddressModel extends PatientAddressModel {
  const factory _PatientAddressModel(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final double latitude,
          required final double longitude,
          @JsonKey(name: 'address_line') required final String addressLine,
          @JsonKey(name: 'apartment_number') final String? apartmentNumber,
          final String? floor,
          @JsonKey(name: 'door_number') final String? doorNumber,
          final String? entrance,
          @JsonKey(name: 'building_name') final String? buildingName,
          @JsonKey(name: 'additional_info') final String? additionalInfo,
          final String? label,
          @JsonKey(name: 'is_default') final bool isDefault,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$PatientAddressModelImpl;
  const _PatientAddressModel._() : super._();

  factory _PatientAddressModel.fromJson(Map<String, dynamic> json) =
      _$PatientAddressModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override // Location coordinates
  double get latitude;
  @override
  double get longitude;
  @override // Address details
  @JsonKey(name: 'address_line')
  String get addressLine;
  @override
  @JsonKey(name: 'apartment_number')
  String? get apartmentNumber;
  @override
  String? get floor;
  @override
  @JsonKey(name: 'door_number')
  String? get doorNumber;
  @override
  String? get entrance;
  @override
  @JsonKey(name: 'building_name')
  String? get buildingName;
  @override
  @JsonKey(name: 'additional_info')
  String? get additionalInfo;
  @override // Metadata
  String? get label;
  @override // e.g., "Home", "Work", "Parent's House"
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PatientAddressModelImplCopyWith<_$PatientAddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
