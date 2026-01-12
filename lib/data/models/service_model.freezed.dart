// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) {
  return _ServiceModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String get categoryId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_mn')
  String? get nameMn => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'description_mn')
  String? get descriptionMn => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_type')
  String? get sampleType => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipment_needed')
  String? get equipmentNeeded => throw _privateConstructorUsedError;
  @JsonKey(name: 'preparation_instructions')
  String? get preparationInstructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_duration_minutes')
  int? get estimatedDurationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Nested relationships (when fetched with joins)
  @JsonKey(name: 'service_categories')
  ServiceCategoryModel? get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ServiceModelCopyWith<ServiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceModelCopyWith<$Res> {
  factory $ServiceModelCopyWith(
          ServiceModel value, $Res Function(ServiceModel) then) =
      _$ServiceModelCopyWithImpl<$Res, ServiceModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'category_id') String categoryId,
      String name,
      @JsonKey(name: 'name_mn') String? nameMn,
      String? description,
      @JsonKey(name: 'description_mn') String? descriptionMn,
      @JsonKey(name: 'sample_type') String? sampleType,
      @JsonKey(name: 'equipment_needed') String? equipmentNeeded,
      @JsonKey(name: 'preparation_instructions')
      String? preparationInstructions,
      @JsonKey(name: 'estimated_duration_minutes')
      int? estimatedDurationMinutes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'service_categories') ServiceCategoryModel? category});

  $ServiceCategoryModelCopyWith<$Res>? get category;
}

/// @nodoc
class _$ServiceModelCopyWithImpl<$Res, $Val extends ServiceModel>
    implements $ServiceModelCopyWith<$Res> {
  _$ServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? name = null,
    Object? nameMn = freezed,
    Object? description = freezed,
    Object? descriptionMn = freezed,
    Object? sampleType = freezed,
    Object? equipmentNeeded = freezed,
    Object? preparationInstructions = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      descriptionMn: freezed == descriptionMn
          ? _value.descriptionMn
          : descriptionMn // ignore: cast_nullable_to_non_nullable
              as String?,
      sampleType: freezed == sampleType
          ? _value.sampleType
          : sampleType // ignore: cast_nullable_to_non_nullable
              as String?,
      equipmentNeeded: freezed == equipmentNeeded
          ? _value.equipmentNeeded
          : equipmentNeeded // ignore: cast_nullable_to_non_nullable
              as String?,
      preparationInstructions: freezed == preparationInstructions
          ? _value.preparationInstructions
          : preparationInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDurationMinutes: freezed == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ServiceCategoryModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ServiceCategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $ServiceCategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceModelImplCopyWith<$Res>
    implements $ServiceModelCopyWith<$Res> {
  factory _$$ServiceModelImplCopyWith(
          _$ServiceModelImpl value, $Res Function(_$ServiceModelImpl) then) =
      __$$ServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'category_id') String categoryId,
      String name,
      @JsonKey(name: 'name_mn') String? nameMn,
      String? description,
      @JsonKey(name: 'description_mn') String? descriptionMn,
      @JsonKey(name: 'sample_type') String? sampleType,
      @JsonKey(name: 'equipment_needed') String? equipmentNeeded,
      @JsonKey(name: 'preparation_instructions')
      String? preparationInstructions,
      @JsonKey(name: 'estimated_duration_minutes')
      int? estimatedDurationMinutes,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'service_categories') ServiceCategoryModel? category});

  @override
  $ServiceCategoryModelCopyWith<$Res>? get category;
}

/// @nodoc
class __$$ServiceModelImplCopyWithImpl<$Res>
    extends _$ServiceModelCopyWithImpl<$Res, _$ServiceModelImpl>
    implements _$$ServiceModelImplCopyWith<$Res> {
  __$$ServiceModelImplCopyWithImpl(
      _$ServiceModelImpl _value, $Res Function(_$ServiceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? name = null,
    Object? nameMn = freezed,
    Object? description = freezed,
    Object? descriptionMn = freezed,
    Object? sampleType = freezed,
    Object? equipmentNeeded = freezed,
    Object? preparationInstructions = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = freezed,
  }) {
    return _then(_$ServiceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
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
      descriptionMn: freezed == descriptionMn
          ? _value.descriptionMn
          : descriptionMn // ignore: cast_nullable_to_non_nullable
              as String?,
      sampleType: freezed == sampleType
          ? _value.sampleType
          : sampleType // ignore: cast_nullable_to_non_nullable
              as String?,
      equipmentNeeded: freezed == equipmentNeeded
          ? _value.equipmentNeeded
          : equipmentNeeded // ignore: cast_nullable_to_non_nullable
              as String?,
      preparationInstructions: freezed == preparationInstructions
          ? _value.preparationInstructions
          : preparationInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDurationMinutes: freezed == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
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
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ServiceCategoryModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceModelImpl implements _ServiceModel {
  const _$ServiceModelImpl(
      {required this.id,
      @JsonKey(name: 'category_id') required this.categoryId,
      required this.name,
      @JsonKey(name: 'name_mn') this.nameMn,
      this.description,
      @JsonKey(name: 'description_mn') this.descriptionMn,
      @JsonKey(name: 'sample_type') this.sampleType,
      @JsonKey(name: 'equipment_needed') this.equipmentNeeded,
      @JsonKey(name: 'preparation_instructions') this.preparationInstructions,
      @JsonKey(name: 'estimated_duration_minutes')
      this.estimatedDurationMinutes,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'service_categories') this.category});

  factory _$ServiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'category_id')
  final String categoryId;
  @override
  final String name;
  @override
  @JsonKey(name: 'name_mn')
  final String? nameMn;
  @override
  final String? description;
  @override
  @JsonKey(name: 'description_mn')
  final String? descriptionMn;
  @override
  @JsonKey(name: 'sample_type')
  final String? sampleType;
  @override
  @JsonKey(name: 'equipment_needed')
  final String? equipmentNeeded;
  @override
  @JsonKey(name: 'preparation_instructions')
  final String? preparationInstructions;
  @override
  @JsonKey(name: 'estimated_duration_minutes')
  final int? estimatedDurationMinutes;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Nested relationships (when fetched with joins)
  @override
  @JsonKey(name: 'service_categories')
  final ServiceCategoryModel? category;

  @override
  String toString() {
    return 'ServiceModel(id: $id, categoryId: $categoryId, name: $name, nameMn: $nameMn, description: $description, descriptionMn: $descriptionMn, sampleType: $sampleType, equipmentNeeded: $equipmentNeeded, preparationInstructions: $preparationInstructions, estimatedDurationMinutes: $estimatedDurationMinutes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameMn, nameMn) || other.nameMn == nameMn) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.descriptionMn, descriptionMn) ||
                other.descriptionMn == descriptionMn) &&
            (identical(other.sampleType, sampleType) ||
                other.sampleType == sampleType) &&
            (identical(other.equipmentNeeded, equipmentNeeded) ||
                other.equipmentNeeded == equipmentNeeded) &&
            (identical(
                    other.preparationInstructions, preparationInstructions) ||
                other.preparationInstructions == preparationInstructions) &&
            (identical(
                    other.estimatedDurationMinutes, estimatedDurationMinutes) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      categoryId,
      name,
      nameMn,
      description,
      descriptionMn,
      sampleType,
      equipmentNeeded,
      preparationInstructions,
      estimatedDurationMinutes,
      isActive,
      createdAt,
      updatedAt,
      category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceModelImplCopyWith<_$ServiceModelImpl> get copyWith =>
      __$$ServiceModelImplCopyWithImpl<_$ServiceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceModel implements ServiceModel {
  const factory _ServiceModel(
      {required final String id,
      @JsonKey(name: 'category_id') required final String categoryId,
      required final String name,
      @JsonKey(name: 'name_mn') final String? nameMn,
      final String? description,
      @JsonKey(name: 'description_mn') final String? descriptionMn,
      @JsonKey(name: 'sample_type') final String? sampleType,
      @JsonKey(name: 'equipment_needed') final String? equipmentNeeded,
      @JsonKey(name: 'preparation_instructions')
      final String? preparationInstructions,
      @JsonKey(name: 'estimated_duration_minutes')
      final int? estimatedDurationMinutes,
      @JsonKey(name: 'is_active') required final bool isActive,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'service_categories')
      final ServiceCategoryModel? category}) = _$ServiceModelImpl;

  factory _ServiceModel.fromJson(Map<String, dynamic> json) =
      _$ServiceModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'category_id')
  String get categoryId;
  @override
  String get name;
  @override
  @JsonKey(name: 'name_mn')
  String? get nameMn;
  @override
  String? get description;
  @override
  @JsonKey(name: 'description_mn')
  String? get descriptionMn;
  @override
  @JsonKey(name: 'sample_type')
  String? get sampleType;
  @override
  @JsonKey(name: 'equipment_needed')
  String? get equipmentNeeded;
  @override
  @JsonKey(name: 'preparation_instructions')
  String? get preparationInstructions;
  @override
  @JsonKey(name: 'estimated_duration_minutes')
  int? get estimatedDurationMinutes;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override // Nested relationships (when fetched with joins)
  @JsonKey(name: 'service_categories')
  ServiceCategoryModel? get category;
  @override
  @JsonKey(ignore: true)
  _$$ServiceModelImplCopyWith<_$ServiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
