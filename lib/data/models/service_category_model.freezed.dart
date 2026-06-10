// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceCategoryModel _$ServiceCategoryModelFromJson(Map<String, dynamic> json) {
  return _ServiceCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  ServiceCategoryType get type => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'name_mn')
  String? get nameMn =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'icon_name')
  String? get iconName =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceCategoryModelCopyWith<ServiceCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceCategoryModelCopyWith<$Res> {
  factory $ServiceCategoryModelCopyWith(ServiceCategoryModel value,
          $Res Function(ServiceCategoryModel) then) =
      _$ServiceCategoryModelCopyWithImpl<$Res, ServiceCategoryModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      ServiceCategoryType type,
      String? description,
      @JsonKey(name: 'name_mn') String? nameMn,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ServiceCategoryModelCopyWithImpl<$Res,
        $Val extends ServiceCategoryModel>
    implements $ServiceCategoryModelCopyWith<$Res> {
  _$ServiceCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? nameMn = freezed,
    Object? iconName = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceCategoryType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      nameMn: freezed == nameMn
          ? _value.nameMn
          : nameMn // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ServiceCategoryModelImplCopyWith<$Res>
    implements $ServiceCategoryModelCopyWith<$Res> {
  factory _$$ServiceCategoryModelImplCopyWith(_$ServiceCategoryModelImpl value,
          $Res Function(_$ServiceCategoryModelImpl) then) =
      __$$ServiceCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      ServiceCategoryType type,
      String? description,
      @JsonKey(name: 'name_mn') String? nameMn,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ServiceCategoryModelImplCopyWithImpl<$Res>
    extends _$ServiceCategoryModelCopyWithImpl<$Res, _$ServiceCategoryModelImpl>
    implements _$$ServiceCategoryModelImplCopyWith<$Res> {
  __$$ServiceCategoryModelImplCopyWithImpl(_$ServiceCategoryModelImpl _value,
      $Res Function(_$ServiceCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? nameMn = freezed,
    Object? iconName = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ServiceCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ServiceCategoryType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      nameMn: freezed == nameMn
          ? _value.nameMn
          : nameMn // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ServiceCategoryModelImpl implements _ServiceCategoryModel {
  const _$ServiceCategoryModelImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.description,
      @JsonKey(name: 'name_mn') this.nameMn,
      @JsonKey(name: 'icon_name') this.iconName,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ServiceCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final ServiceCategoryType type;
  @override
  final String? description;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'name_mn')
  final String? nameMn;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'icon_name')
  final String? iconName;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ServiceCategoryModel(id: $id, name: $name, type: $type, description: $description, nameMn: $nameMn, iconName: $iconName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.nameMn, nameMn) || other.nameMn == nameMn) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, description,
      nameMn, iconName, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceCategoryModelImplCopyWith<_$ServiceCategoryModelImpl>
      get copyWith =>
          __$$ServiceCategoryModelImplCopyWithImpl<_$ServiceCategoryModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceCategoryModel implements ServiceCategoryModel {
  const factory _ServiceCategoryModel(
          {required final String id,
          required final String name,
          required final ServiceCategoryType type,
          final String? description,
          @JsonKey(name: 'name_mn') final String? nameMn,
          @JsonKey(name: 'icon_name') final String? iconName,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ServiceCategoryModelImpl;

  factory _ServiceCategoryModel.fromJson(Map<String, dynamic> json) =
      _$ServiceCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  ServiceCategoryType get type;
  @override
  String? get description;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'name_mn')
  String? get nameMn;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'icon_name')
  String? get iconName;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ServiceCategoryModelImplCopyWith<_$ServiceCategoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
