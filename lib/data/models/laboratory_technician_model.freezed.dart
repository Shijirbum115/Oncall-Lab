// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'laboratory_technician_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LaboratoryTechnicianModel _$LaboratoryTechnicianModelFromJson(
    Map<String, dynamic> json) {
  return _LaboratoryTechnicianModel.fromJson(json);
}

/// @nodoc
mixin _$LaboratoryTechnicianModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'laboratory_id')
  String get laboratoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'technician_id')
  String get technicianId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary_technician')
  bool get isPrimaryTechnician => throw _privateConstructorUsedError;
  @JsonKey(name: 'employment_start_date')
  String? get employmentStartDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'employment_end_date')
  String? get employmentEndDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_collect_samples')
  bool get canCollectSamples => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_perform_tests')
  bool get canPerformTests => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Nested relationships (when fetched with joins)
  @JsonKey(name: 'doctor_profiles')
  DoctorProfileModel? get doctorProfile => throw _privateConstructorUsedError;
  ProfileModel? get profile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LaboratoryTechnicianModelCopyWith<LaboratoryTechnicianModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LaboratoryTechnicianModelCopyWith<$Res> {
  factory $LaboratoryTechnicianModelCopyWith(LaboratoryTechnicianModel value,
          $Res Function(LaboratoryTechnicianModel) then) =
      _$LaboratoryTechnicianModelCopyWithImpl<$Res, LaboratoryTechnicianModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'laboratory_id') String laboratoryId,
      @JsonKey(name: 'technician_id') String technicianId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_primary_technician') bool isPrimaryTechnician,
      @JsonKey(name: 'employment_start_date') String? employmentStartDate,
      @JsonKey(name: 'employment_end_date') String? employmentEndDate,
      @JsonKey(name: 'can_collect_samples') bool canCollectSamples,
      @JsonKey(name: 'can_perform_tests') bool canPerformTests,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'doctor_profiles') DoctorProfileModel? doctorProfile,
      ProfileModel? profile});

  $DoctorProfileModelCopyWith<$Res>? get doctorProfile;
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class _$LaboratoryTechnicianModelCopyWithImpl<$Res,
        $Val extends LaboratoryTechnicianModel>
    implements $LaboratoryTechnicianModelCopyWith<$Res> {
  _$LaboratoryTechnicianModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? laboratoryId = null,
    Object? technicianId = null,
    Object? isActive = null,
    Object? isPrimaryTechnician = null,
    Object? employmentStartDate = freezed,
    Object? employmentEndDate = freezed,
    Object? canCollectSamples = null,
    Object? canPerformTests = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? doctorProfile = freezed,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      laboratoryId: null == laboratoryId
          ? _value.laboratoryId
          : laboratoryId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrimaryTechnician: null == isPrimaryTechnician
          ? _value.isPrimaryTechnician
          : isPrimaryTechnician // ignore: cast_nullable_to_non_nullable
              as bool,
      employmentStartDate: freezed == employmentStartDate
          ? _value.employmentStartDate
          : employmentStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      employmentEndDate: freezed == employmentEndDate
          ? _value.employmentEndDate
          : employmentEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      canCollectSamples: null == canCollectSamples
          ? _value.canCollectSamples
          : canCollectSamples // ignore: cast_nullable_to_non_nullable
              as bool,
      canPerformTests: null == canPerformTests
          ? _value.canPerformTests
          : canPerformTests // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      doctorProfile: freezed == doctorProfile
          ? _value.doctorProfile
          : doctorProfile // ignore: cast_nullable_to_non_nullable
              as DoctorProfileModel?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DoctorProfileModelCopyWith<$Res>? get doctorProfile {
    if (_value.doctorProfile == null) {
      return null;
    }

    return $DoctorProfileModelCopyWith<$Res>(_value.doctorProfile!, (value) {
      return _then(_value.copyWith(doctorProfile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LaboratoryTechnicianModelImplCopyWith<$Res>
    implements $LaboratoryTechnicianModelCopyWith<$Res> {
  factory _$$LaboratoryTechnicianModelImplCopyWith(
          _$LaboratoryTechnicianModelImpl value,
          $Res Function(_$LaboratoryTechnicianModelImpl) then) =
      __$$LaboratoryTechnicianModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'laboratory_id') String laboratoryId,
      @JsonKey(name: 'technician_id') String technicianId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_primary_technician') bool isPrimaryTechnician,
      @JsonKey(name: 'employment_start_date') String? employmentStartDate,
      @JsonKey(name: 'employment_end_date') String? employmentEndDate,
      @JsonKey(name: 'can_collect_samples') bool canCollectSamples,
      @JsonKey(name: 'can_perform_tests') bool canPerformTests,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'doctor_profiles') DoctorProfileModel? doctorProfile,
      ProfileModel? profile});

  @override
  $DoctorProfileModelCopyWith<$Res>? get doctorProfile;
  @override
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$LaboratoryTechnicianModelImplCopyWithImpl<$Res>
    extends _$LaboratoryTechnicianModelCopyWithImpl<$Res,
        _$LaboratoryTechnicianModelImpl>
    implements _$$LaboratoryTechnicianModelImplCopyWith<$Res> {
  __$$LaboratoryTechnicianModelImplCopyWithImpl(
      _$LaboratoryTechnicianModelImpl _value,
      $Res Function(_$LaboratoryTechnicianModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? laboratoryId = null,
    Object? technicianId = null,
    Object? isActive = null,
    Object? isPrimaryTechnician = null,
    Object? employmentStartDate = freezed,
    Object? employmentEndDate = freezed,
    Object? canCollectSamples = null,
    Object? canPerformTests = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? doctorProfile = freezed,
    Object? profile = freezed,
  }) {
    return _then(_$LaboratoryTechnicianModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      laboratoryId: null == laboratoryId
          ? _value.laboratoryId
          : laboratoryId // ignore: cast_nullable_to_non_nullable
              as String,
      technicianId: null == technicianId
          ? _value.technicianId
          : technicianId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isPrimaryTechnician: null == isPrimaryTechnician
          ? _value.isPrimaryTechnician
          : isPrimaryTechnician // ignore: cast_nullable_to_non_nullable
              as bool,
      employmentStartDate: freezed == employmentStartDate
          ? _value.employmentStartDate
          : employmentStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      employmentEndDate: freezed == employmentEndDate
          ? _value.employmentEndDate
          : employmentEndDate // ignore: cast_nullable_to_non_nullable
              as String?,
      canCollectSamples: null == canCollectSamples
          ? _value.canCollectSamples
          : canCollectSamples // ignore: cast_nullable_to_non_nullable
              as bool,
      canPerformTests: null == canPerformTests
          ? _value.canPerformTests
          : canPerformTests // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      doctorProfile: freezed == doctorProfile
          ? _value.doctorProfile
          : doctorProfile // ignore: cast_nullable_to_non_nullable
              as DoctorProfileModel?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LaboratoryTechnicianModelImpl implements _LaboratoryTechnicianModel {
  const _$LaboratoryTechnicianModelImpl(
      {required this.id,
      @JsonKey(name: 'laboratory_id') required this.laboratoryId,
      @JsonKey(name: 'technician_id') required this.technicianId,
      @JsonKey(name: 'is_active') required this.isActive,
      @JsonKey(name: 'is_primary_technician') this.isPrimaryTechnician = false,
      @JsonKey(name: 'employment_start_date') this.employmentStartDate,
      @JsonKey(name: 'employment_end_date') this.employmentEndDate,
      @JsonKey(name: 'can_collect_samples') this.canCollectSamples = true,
      @JsonKey(name: 'can_perform_tests') this.canPerformTests = true,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'doctor_profiles') this.doctorProfile,
      this.profile});

  factory _$LaboratoryTechnicianModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LaboratoryTechnicianModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'laboratory_id')
  final String laboratoryId;
  @override
  @JsonKey(name: 'technician_id')
  final String technicianId;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_primary_technician')
  final bool isPrimaryTechnician;
  @override
  @JsonKey(name: 'employment_start_date')
  final String? employmentStartDate;
  @override
  @JsonKey(name: 'employment_end_date')
  final String? employmentEndDate;
  @override
  @JsonKey(name: 'can_collect_samples')
  final bool canCollectSamples;
  @override
  @JsonKey(name: 'can_perform_tests')
  final bool canPerformTests;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Nested relationships (when fetched with joins)
  @override
  @JsonKey(name: 'doctor_profiles')
  final DoctorProfileModel? doctorProfile;
  @override
  final ProfileModel? profile;

  @override
  String toString() {
    return 'LaboratoryTechnicianModel(id: $id, laboratoryId: $laboratoryId, technicianId: $technicianId, isActive: $isActive, isPrimaryTechnician: $isPrimaryTechnician, employmentStartDate: $employmentStartDate, employmentEndDate: $employmentEndDate, canCollectSamples: $canCollectSamples, canPerformTests: $canPerformTests, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, doctorProfile: $doctorProfile, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LaboratoryTechnicianModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.laboratoryId, laboratoryId) ||
                other.laboratoryId == laboratoryId) &&
            (identical(other.technicianId, technicianId) ||
                other.technicianId == technicianId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isPrimaryTechnician, isPrimaryTechnician) ||
                other.isPrimaryTechnician == isPrimaryTechnician) &&
            (identical(other.employmentStartDate, employmentStartDate) ||
                other.employmentStartDate == employmentStartDate) &&
            (identical(other.employmentEndDate, employmentEndDate) ||
                other.employmentEndDate == employmentEndDate) &&
            (identical(other.canCollectSamples, canCollectSamples) ||
                other.canCollectSamples == canCollectSamples) &&
            (identical(other.canPerformTests, canPerformTests) ||
                other.canPerformTests == canPerformTests) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.doctorProfile, doctorProfile) ||
                other.doctorProfile == doctorProfile) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      laboratoryId,
      technicianId,
      isActive,
      isPrimaryTechnician,
      employmentStartDate,
      employmentEndDate,
      canCollectSamples,
      canPerformTests,
      notes,
      createdAt,
      updatedAt,
      doctorProfile,
      profile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LaboratoryTechnicianModelImplCopyWith<_$LaboratoryTechnicianModelImpl>
      get copyWith => __$$LaboratoryTechnicianModelImplCopyWithImpl<
          _$LaboratoryTechnicianModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LaboratoryTechnicianModelImplToJson(
      this,
    );
  }
}

abstract class _LaboratoryTechnicianModel implements LaboratoryTechnicianModel {
  const factory _LaboratoryTechnicianModel(
      {required final String id,
      @JsonKey(name: 'laboratory_id') required final String laboratoryId,
      @JsonKey(name: 'technician_id') required final String technicianId,
      @JsonKey(name: 'is_active') required final bool isActive,
      @JsonKey(name: 'is_primary_technician') final bool isPrimaryTechnician,
      @JsonKey(name: 'employment_start_date') final String? employmentStartDate,
      @JsonKey(name: 'employment_end_date') final String? employmentEndDate,
      @JsonKey(name: 'can_collect_samples') final bool canCollectSamples,
      @JsonKey(name: 'can_perform_tests') final bool canPerformTests,
      final String? notes,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'doctor_profiles') final DoctorProfileModel? doctorProfile,
      final ProfileModel? profile}) = _$LaboratoryTechnicianModelImpl;

  factory _LaboratoryTechnicianModel.fromJson(Map<String, dynamic> json) =
      _$LaboratoryTechnicianModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'laboratory_id')
  String get laboratoryId;
  @override
  @JsonKey(name: 'technician_id')
  String get technicianId;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_primary_technician')
  bool get isPrimaryTechnician;
  @override
  @JsonKey(name: 'employment_start_date')
  String? get employmentStartDate;
  @override
  @JsonKey(name: 'employment_end_date')
  String? get employmentEndDate;
  @override
  @JsonKey(name: 'can_collect_samples')
  bool get canCollectSamples;
  @override
  @JsonKey(name: 'can_perform_tests')
  bool get canPerformTests;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override // Nested relationships (when fetched with joins)
  @JsonKey(name: 'doctor_profiles')
  DoctorProfileModel? get doctorProfile;
  @override
  ProfileModel? get profile;
  @override
  @JsonKey(ignore: true)
  _$$LaboratoryTechnicianModelImplCopyWith<_$LaboratoryTechnicianModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
