// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doctor_review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DoctorReviewModel _$DoctorReviewModelFromJson(Map<String, dynamic> json) {
  return _DoctorReviewModel.fromJson(json);
}

/// @nodoc
mixin _$DoctorReviewModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_id')
  String get doctorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_id')
  String get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'test_request_id')
  String? get testRequestId => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_title')
  String? get reviewTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_text')
  String? get reviewText => throw _privateConstructorUsedError;
  @JsonKey(name: 'professionalism_rating')
  double? get professionalismRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'punctuality_rating')
  double? get punctualityRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'communication_rating')
  double? get communicationRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_visible')
  bool get isVisible => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_response')
  String? get doctorResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'responded_at')
  DateTime? get respondedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpful_count')
  int get helpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'not_helpful_count')
  int get notHelpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Nested relationships (when fetched with joins)
  ProfileModel? get profile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DoctorReviewModelCopyWith<DoctorReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoctorReviewModelCopyWith<$Res> {
  factory $DoctorReviewModelCopyWith(
          DoctorReviewModel value, $Res Function(DoctorReviewModel) then) =
      _$DoctorReviewModelCopyWithImpl<$Res, DoctorReviewModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'doctor_id') String doctorId,
      @JsonKey(name: 'patient_id') String patientId,
      @JsonKey(name: 'test_request_id') String? testRequestId,
      double rating,
      @JsonKey(name: 'review_title') String? reviewTitle,
      @JsonKey(name: 'review_text') String? reviewText,
      @JsonKey(name: 'professionalism_rating') double? professionalismRating,
      @JsonKey(name: 'punctuality_rating') double? punctualityRating,
      @JsonKey(name: 'communication_rating') double? communicationRating,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_visible') bool isVisible,
      @JsonKey(name: 'doctor_response') String? doctorResponse,
      @JsonKey(name: 'responded_at') DateTime? respondedAt,
      @JsonKey(name: 'helpful_count') int helpfulCount,
      @JsonKey(name: 'not_helpful_count') int notHelpfulCount,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      ProfileModel? profile});

  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class _$DoctorReviewModelCopyWithImpl<$Res, $Val extends DoctorReviewModel>
    implements $DoctorReviewModelCopyWith<$Res> {
  _$DoctorReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? doctorId = null,
    Object? patientId = null,
    Object? testRequestId = freezed,
    Object? rating = null,
    Object? reviewTitle = freezed,
    Object? reviewText = freezed,
    Object? professionalismRating = freezed,
    Object? punctualityRating = freezed,
    Object? communicationRating = freezed,
    Object? isVerified = null,
    Object? isVisible = null,
    Object? doctorResponse = freezed,
    Object? respondedAt = freezed,
    Object? helpfulCount = null,
    Object? notHelpfulCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      testRequestId: freezed == testRequestId
          ? _value.testRequestId
          : testRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewTitle: freezed == reviewTitle
          ? _value.reviewTitle
          : reviewTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalismRating: freezed == professionalismRating
          ? _value.professionalismRating
          : professionalismRating // ignore: cast_nullable_to_non_nullable
              as double?,
      punctualityRating: freezed == punctualityRating
          ? _value.punctualityRating
          : punctualityRating // ignore: cast_nullable_to_non_nullable
              as double?,
      communicationRating: freezed == communicationRating
          ? _value.communicationRating
          : communicationRating // ignore: cast_nullable_to_non_nullable
              as double?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      doctorResponse: freezed == doctorResponse
          ? _value.doctorResponse
          : doctorResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCount: null == notHelpfulCount
          ? _value.notHelpfulCount
          : notHelpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
    ) as $Val);
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
abstract class _$$DoctorReviewModelImplCopyWith<$Res>
    implements $DoctorReviewModelCopyWith<$Res> {
  factory _$$DoctorReviewModelImplCopyWith(_$DoctorReviewModelImpl value,
          $Res Function(_$DoctorReviewModelImpl) then) =
      __$$DoctorReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'doctor_id') String doctorId,
      @JsonKey(name: 'patient_id') String patientId,
      @JsonKey(name: 'test_request_id') String? testRequestId,
      double rating,
      @JsonKey(name: 'review_title') String? reviewTitle,
      @JsonKey(name: 'review_text') String? reviewText,
      @JsonKey(name: 'professionalism_rating') double? professionalismRating,
      @JsonKey(name: 'punctuality_rating') double? punctualityRating,
      @JsonKey(name: 'communication_rating') double? communicationRating,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'is_visible') bool isVisible,
      @JsonKey(name: 'doctor_response') String? doctorResponse,
      @JsonKey(name: 'responded_at') DateTime? respondedAt,
      @JsonKey(name: 'helpful_count') int helpfulCount,
      @JsonKey(name: 'not_helpful_count') int notHelpfulCount,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      ProfileModel? profile});

  @override
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$DoctorReviewModelImplCopyWithImpl<$Res>
    extends _$DoctorReviewModelCopyWithImpl<$Res, _$DoctorReviewModelImpl>
    implements _$$DoctorReviewModelImplCopyWith<$Res> {
  __$$DoctorReviewModelImplCopyWithImpl(_$DoctorReviewModelImpl _value,
      $Res Function(_$DoctorReviewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? doctorId = null,
    Object? patientId = null,
    Object? testRequestId = freezed,
    Object? rating = null,
    Object? reviewTitle = freezed,
    Object? reviewText = freezed,
    Object? professionalismRating = freezed,
    Object? punctualityRating = freezed,
    Object? communicationRating = freezed,
    Object? isVerified = null,
    Object? isVisible = null,
    Object? doctorResponse = freezed,
    Object? respondedAt = freezed,
    Object? helpfulCount = null,
    Object? notHelpfulCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? profile = freezed,
  }) {
    return _then(_$DoctorReviewModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      testRequestId: freezed == testRequestId
          ? _value.testRequestId
          : testRequestId // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewTitle: freezed == reviewTitle
          ? _value.reviewTitle
          : reviewTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalismRating: freezed == professionalismRating
          ? _value.professionalismRating
          : professionalismRating // ignore: cast_nullable_to_non_nullable
              as double?,
      punctualityRating: freezed == punctualityRating
          ? _value.punctualityRating
          : punctualityRating // ignore: cast_nullable_to_non_nullable
              as double?,
      communicationRating: freezed == communicationRating
          ? _value.communicationRating
          : communicationRating // ignore: cast_nullable_to_non_nullable
              as double?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      doctorResponse: freezed == doctorResponse
          ? _value.doctorResponse
          : doctorResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCount: null == notHelpfulCount
          ? _value.notHelpfulCount
          : notHelpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DoctorReviewModelImpl extends _DoctorReviewModel {
  const _$DoctorReviewModelImpl(
      {required this.id,
      @JsonKey(name: 'doctor_id') required this.doctorId,
      @JsonKey(name: 'patient_id') required this.patientId,
      @JsonKey(name: 'test_request_id') this.testRequestId,
      required this.rating,
      @JsonKey(name: 'review_title') this.reviewTitle,
      @JsonKey(name: 'review_text') this.reviewText,
      @JsonKey(name: 'professionalism_rating') this.professionalismRating,
      @JsonKey(name: 'punctuality_rating') this.punctualityRating,
      @JsonKey(name: 'communication_rating') this.communicationRating,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'is_visible') this.isVisible = true,
      @JsonKey(name: 'doctor_response') this.doctorResponse,
      @JsonKey(name: 'responded_at') this.respondedAt,
      @JsonKey(name: 'helpful_count') this.helpfulCount = 0,
      @JsonKey(name: 'not_helpful_count') this.notHelpfulCount = 0,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      this.profile})
      : super._();

  factory _$DoctorReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoctorReviewModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'doctor_id')
  final String doctorId;
  @override
  @JsonKey(name: 'patient_id')
  final String patientId;
  @override
  @JsonKey(name: 'test_request_id')
  final String? testRequestId;
  @override
  final double rating;
  @override
  @JsonKey(name: 'review_title')
  final String? reviewTitle;
  @override
  @JsonKey(name: 'review_text')
  final String? reviewText;
  @override
  @JsonKey(name: 'professionalism_rating')
  final double? professionalismRating;
  @override
  @JsonKey(name: 'punctuality_rating')
  final double? punctualityRating;
  @override
  @JsonKey(name: 'communication_rating')
  final double? communicationRating;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'is_visible')
  final bool isVisible;
  @override
  @JsonKey(name: 'doctor_response')
  final String? doctorResponse;
  @override
  @JsonKey(name: 'responded_at')
  final DateTime? respondedAt;
  @override
  @JsonKey(name: 'helpful_count')
  final int helpfulCount;
  @override
  @JsonKey(name: 'not_helpful_count')
  final int notHelpfulCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Nested relationships (when fetched with joins)
  @override
  final ProfileModel? profile;

  @override
  String toString() {
    return 'DoctorReviewModel(id: $id, doctorId: $doctorId, patientId: $patientId, testRequestId: $testRequestId, rating: $rating, reviewTitle: $reviewTitle, reviewText: $reviewText, professionalismRating: $professionalismRating, punctualityRating: $punctualityRating, communicationRating: $communicationRating, isVerified: $isVerified, isVisible: $isVisible, doctorResponse: $doctorResponse, respondedAt: $respondedAt, helpfulCount: $helpfulCount, notHelpfulCount: $notHelpfulCount, createdAt: $createdAt, updatedAt: $updatedAt, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoctorReviewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.testRequestId, testRequestId) ||
                other.testRequestId == testRequestId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewTitle, reviewTitle) ||
                other.reviewTitle == reviewTitle) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.professionalismRating, professionalismRating) ||
                other.professionalismRating == professionalismRating) &&
            (identical(other.punctualityRating, punctualityRating) ||
                other.punctualityRating == punctualityRating) &&
            (identical(other.communicationRating, communicationRating) ||
                other.communicationRating == communicationRating) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.doctorResponse, doctorResponse) ||
                other.doctorResponse == doctorResponse) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.notHelpfulCount, notHelpfulCount) ||
                other.notHelpfulCount == notHelpfulCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        doctorId,
        patientId,
        testRequestId,
        rating,
        reviewTitle,
        reviewText,
        professionalismRating,
        punctualityRating,
        communicationRating,
        isVerified,
        isVisible,
        doctorResponse,
        respondedAt,
        helpfulCount,
        notHelpfulCount,
        createdAt,
        updatedAt,
        profile
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DoctorReviewModelImplCopyWith<_$DoctorReviewModelImpl> get copyWith =>
      __$$DoctorReviewModelImplCopyWithImpl<_$DoctorReviewModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DoctorReviewModelImplToJson(
      this,
    );
  }
}

abstract class _DoctorReviewModel extends DoctorReviewModel {
  const factory _DoctorReviewModel(
      {required final String id,
      @JsonKey(name: 'doctor_id') required final String doctorId,
      @JsonKey(name: 'patient_id') required final String patientId,
      @JsonKey(name: 'test_request_id') final String? testRequestId,
      required final double rating,
      @JsonKey(name: 'review_title') final String? reviewTitle,
      @JsonKey(name: 'review_text') final String? reviewText,
      @JsonKey(name: 'professionalism_rating')
      final double? professionalismRating,
      @JsonKey(name: 'punctuality_rating') final double? punctualityRating,
      @JsonKey(name: 'communication_rating') final double? communicationRating,
      @JsonKey(name: 'is_verified') final bool isVerified,
      @JsonKey(name: 'is_visible') final bool isVisible,
      @JsonKey(name: 'doctor_response') final String? doctorResponse,
      @JsonKey(name: 'responded_at') final DateTime? respondedAt,
      @JsonKey(name: 'helpful_count') final int helpfulCount,
      @JsonKey(name: 'not_helpful_count') final int notHelpfulCount,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      final ProfileModel? profile}) = _$DoctorReviewModelImpl;
  const _DoctorReviewModel._() : super._();

  factory _DoctorReviewModel.fromJson(Map<String, dynamic> json) =
      _$DoctorReviewModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'doctor_id')
  String get doctorId;
  @override
  @JsonKey(name: 'patient_id')
  String get patientId;
  @override
  @JsonKey(name: 'test_request_id')
  String? get testRequestId;
  @override
  double get rating;
  @override
  @JsonKey(name: 'review_title')
  String? get reviewTitle;
  @override
  @JsonKey(name: 'review_text')
  String? get reviewText;
  @override
  @JsonKey(name: 'professionalism_rating')
  double? get professionalismRating;
  @override
  @JsonKey(name: 'punctuality_rating')
  double? get punctualityRating;
  @override
  @JsonKey(name: 'communication_rating')
  double? get communicationRating;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'is_visible')
  bool get isVisible;
  @override
  @JsonKey(name: 'doctor_response')
  String? get doctorResponse;
  @override
  @JsonKey(name: 'responded_at')
  DateTime? get respondedAt;
  @override
  @JsonKey(name: 'helpful_count')
  int get helpfulCount;
  @override
  @JsonKey(name: 'not_helpful_count')
  int get notHelpfulCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override // Nested relationships (when fetched with joins)
  ProfileModel? get profile;
  @override
  @JsonKey(ignore: true)
  _$$DoctorReviewModelImplCopyWith<_$DoctorReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
