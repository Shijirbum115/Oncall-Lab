// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostCategoryModel _$PostCategoryModelFromJson(Map<String, dynamic> json) {
  return _PostCategoryModel.fromJson(json);
}

/// @nodoc
mixin _$PostCategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_mn')
  String? get nameMn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_name')
  String? get iconName => throw _privateConstructorUsedError;
  @JsonKey(name: 'color_hex')
  String? get colorHex => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostCategoryModelCopyWith<PostCategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCategoryModelCopyWith<$Res> {
  factory $PostCategoryModelCopyWith(
          PostCategoryModel value, $Res Function(PostCategoryModel) then) =
      _$PostCategoryModelCopyWithImpl<$Res, PostCategoryModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'name_mn') String? nameMn,
      String? description,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'color_hex') String? colorHex,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PostCategoryModelCopyWithImpl<$Res, $Val extends PostCategoryModel>
    implements $PostCategoryModelCopyWith<$Res> {
  _$PostCategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameMn = freezed,
    Object? description = freezed,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
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
      nameMn: freezed == nameMn
          ? _value.nameMn
          : nameMn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorHex: freezed == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
abstract class _$$PostCategoryModelImplCopyWith<$Res>
    implements $PostCategoryModelCopyWith<$Res> {
  factory _$$PostCategoryModelImplCopyWith(_$PostCategoryModelImpl value,
          $Res Function(_$PostCategoryModelImpl) then) =
      __$$PostCategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'name_mn') String? nameMn,
      String? description,
      @JsonKey(name: 'icon_name') String? iconName,
      @JsonKey(name: 'color_hex') String? colorHex,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PostCategoryModelImplCopyWithImpl<$Res>
    extends _$PostCategoryModelCopyWithImpl<$Res, _$PostCategoryModelImpl>
    implements _$$PostCategoryModelImplCopyWith<$Res> {
  __$$PostCategoryModelImplCopyWithImpl(_$PostCategoryModelImpl _value,
      $Res Function(_$PostCategoryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? nameMn = freezed,
    Object? description = freezed,
    Object? iconName = freezed,
    Object? colorHex = freezed,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PostCategoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nameMn: freezed == nameMn
          ? _value.nameMn
          : nameMn // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: freezed == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String?,
      colorHex: freezed == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
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
class _$PostCategoryModelImpl extends _PostCategoryModel {
  const _$PostCategoryModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'name_mn') this.nameMn,
      this.description,
      @JsonKey(name: 'icon_name') this.iconName,
      @JsonKey(name: 'color_hex') this.colorHex,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$PostCategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostCategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_mn')
  final String? nameMn;
  @override
  final String? description;
  @override
  @JsonKey(name: 'icon_name')
  final String? iconName;
  @override
  @JsonKey(name: 'color_hex')
  final String? colorHex;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PostCategoryModel(id: $id, name: $name, nameMn: $nameMn, description: $description, iconName: $iconName, colorHex: $colorHex, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostCategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameMn, nameMn) || other.nameMn == nameMn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, nameMn, description,
      iconName, colorHex, sortOrder, isActive, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostCategoryModelImplCopyWith<_$PostCategoryModelImpl> get copyWith =>
      __$$PostCategoryModelImplCopyWithImpl<_$PostCategoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostCategoryModelImplToJson(
      this,
    );
  }
}

abstract class _PostCategoryModel extends PostCategoryModel {
  const factory _PostCategoryModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'name_mn') final String? nameMn,
          final String? description,
          @JsonKey(name: 'icon_name') final String? iconName,
          @JsonKey(name: 'color_hex') final String? colorHex,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$PostCategoryModelImpl;
  const _PostCategoryModel._() : super._();

  factory _PostCategoryModel.fromJson(Map<String, dynamic> json) =
      _$PostCategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_mn')
  String? get nameMn;
  @override
  String? get description;
  @override
  @JsonKey(name: 'icon_name')
  String? get iconName;
  @override
  @JsonKey(name: 'color_hex')
  String? get colorHex;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PostCategoryModelImplCopyWith<_$PostCategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
