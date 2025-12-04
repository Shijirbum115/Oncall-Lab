// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TestRequestModel _$TestRequestModelFromJson(Map<String, dynamic> json) {
  return _TestRequestModel.fromJson(json);
}

/// @nodoc
mixin _$TestRequestModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_id')
  String get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_id')
  String? get doctorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'laboratory_id')
  String? get laboratoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'request_type')
  RequestType get requestType => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_id')
  String? get serviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'laboratory_service_id')
  String? get laboratoryServiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_service_id')
  String? get doctorServiceId => throw _privateConstructorUsedError;
  RequestStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_date')
  String get scheduledDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_time_slot')
  String? get scheduledTimeSlot => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_address')
  String get patientAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_latitude')
  double? get patientLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_longitude')
  double? get patientLongitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_notes')
  String? get patientNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at')
  String? get acceptedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_the_way_at')
  String? get onTheWayAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'sample_collected_at')
  String? get sampleCollectedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivered_to_lab_at')
  String? get deliveredToLabAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  String? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  String? get cancelledAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_mnt')
  int get priceMnt => throw _privateConstructorUsedError;
  @JsonKey(name: 'doctor_commission_mnt')
  int? get doctorCommissionMnt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_by')
  String? get cancelledBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TestRequestModelCopyWith<TestRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestRequestModelCopyWith<$Res> {
  factory $TestRequestModelCopyWith(
          TestRequestModel value, $Res Function(TestRequestModel) then) =
      _$TestRequestModelCopyWithImpl<$Res, TestRequestModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'patient_id') String patientId,
      @JsonKey(name: 'doctor_id') String? doctorId,
      @JsonKey(name: 'laboratory_id') String? laboratoryId,
      @JsonKey(name: 'request_type') RequestType requestType,
      @JsonKey(name: 'service_id') String? serviceId,
      @JsonKey(name: 'laboratory_service_id') String? laboratoryServiceId,
      @JsonKey(name: 'doctor_service_id') String? doctorServiceId,
      RequestStatus status,
      @JsonKey(name: 'scheduled_date') String scheduledDate,
      @JsonKey(name: 'scheduled_time_slot') String? scheduledTimeSlot,
      @JsonKey(name: 'patient_address') String patientAddress,
      @JsonKey(name: 'patient_latitude') double? patientLatitude,
      @JsonKey(name: 'patient_longitude') double? patientLongitude,
      @JsonKey(name: 'patient_notes') String? patientNotes,
      @JsonKey(name: 'accepted_at') String? acceptedAt,
      @JsonKey(name: 'on_the_way_at') String? onTheWayAt,
      @JsonKey(name: 'sample_collected_at') String? sampleCollectedAt,
      @JsonKey(name: 'delivered_to_lab_at') String? deliveredToLabAt,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'cancelled_at') String? cancelledAt,
      @JsonKey(name: 'price_mnt') int priceMnt,
      @JsonKey(name: 'doctor_commission_mnt') int? doctorCommissionMnt,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      @JsonKey(name: 'cancelled_by') String? cancelledBy,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class _$TestRequestModelCopyWithImpl<$Res, $Val extends TestRequestModel>
    implements $TestRequestModelCopyWith<$Res> {
  _$TestRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? doctorId = freezed,
    Object? laboratoryId = freezed,
    Object? requestType = null,
    Object? serviceId = freezed,
    Object? laboratoryServiceId = freezed,
    Object? doctorServiceId = freezed,
    Object? status = null,
    Object? scheduledDate = null,
    Object? scheduledTimeSlot = freezed,
    Object? patientAddress = null,
    Object? patientLatitude = freezed,
    Object? patientLongitude = freezed,
    Object? patientNotes = freezed,
    Object? acceptedAt = freezed,
    Object? onTheWayAt = freezed,
    Object? sampleCollectedAt = freezed,
    Object? deliveredToLabAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? priceMnt = null,
    Object? doctorCommissionMnt = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: freezed == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String?,
      laboratoryId: freezed == laboratoryId
          ? _value.laboratoryId
          : laboratoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as RequestType,
      serviceId: freezed == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      laboratoryServiceId: freezed == laboratoryServiceId
          ? _value.laboratoryServiceId
          : laboratoryServiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      doctorServiceId: freezed == doctorServiceId
          ? _value.doctorServiceId
          : doctorServiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledTimeSlot: freezed == scheduledTimeSlot
          ? _value.scheduledTimeSlot
          : scheduledTimeSlot // ignore: cast_nullable_to_non_nullable
              as String?,
      patientAddress: null == patientAddress
          ? _value.patientAddress
          : patientAddress // ignore: cast_nullable_to_non_nullable
              as String,
      patientLatitude: freezed == patientLatitude
          ? _value.patientLatitude
          : patientLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      patientLongitude: freezed == patientLongitude
          ? _value.patientLongitude
          : patientLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      patientNotes: freezed == patientNotes
          ? _value.patientNotes
          : patientNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      onTheWayAt: freezed == onTheWayAt
          ? _value.onTheWayAt
          : onTheWayAt // ignore: cast_nullable_to_non_nullable
              as String?,
      sampleCollectedAt: freezed == sampleCollectedAt
          ? _value.sampleCollectedAt
          : sampleCollectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredToLabAt: freezed == deliveredToLabAt
          ? _value.deliveredToLabAt
          : deliveredToLabAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as String?,
      priceMnt: null == priceMnt
          ? _value.priceMnt
          : priceMnt // ignore: cast_nullable_to_non_nullable
              as int,
      doctorCommissionMnt: freezed == doctorCommissionMnt
          ? _value.doctorCommissionMnt
          : doctorCommissionMnt // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TestRequestModelImplCopyWith<$Res>
    implements $TestRequestModelCopyWith<$Res> {
  factory _$$TestRequestModelImplCopyWith(_$TestRequestModelImpl value,
          $Res Function(_$TestRequestModelImpl) then) =
      __$$TestRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'patient_id') String patientId,
      @JsonKey(name: 'doctor_id') String? doctorId,
      @JsonKey(name: 'laboratory_id') String? laboratoryId,
      @JsonKey(name: 'request_type') RequestType requestType,
      @JsonKey(name: 'service_id') String? serviceId,
      @JsonKey(name: 'laboratory_service_id') String? laboratoryServiceId,
      @JsonKey(name: 'doctor_service_id') String? doctorServiceId,
      RequestStatus status,
      @JsonKey(name: 'scheduled_date') String scheduledDate,
      @JsonKey(name: 'scheduled_time_slot') String? scheduledTimeSlot,
      @JsonKey(name: 'patient_address') String patientAddress,
      @JsonKey(name: 'patient_latitude') double? patientLatitude,
      @JsonKey(name: 'patient_longitude') double? patientLongitude,
      @JsonKey(name: 'patient_notes') String? patientNotes,
      @JsonKey(name: 'accepted_at') String? acceptedAt,
      @JsonKey(name: 'on_the_way_at') String? onTheWayAt,
      @JsonKey(name: 'sample_collected_at') String? sampleCollectedAt,
      @JsonKey(name: 'delivered_to_lab_at') String? deliveredToLabAt,
      @JsonKey(name: 'completed_at') String? completedAt,
      @JsonKey(name: 'cancelled_at') String? cancelledAt,
      @JsonKey(name: 'price_mnt') int priceMnt,
      @JsonKey(name: 'doctor_commission_mnt') int? doctorCommissionMnt,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      @JsonKey(name: 'cancelled_by') String? cancelledBy,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt});
}

/// @nodoc
class __$$TestRequestModelImplCopyWithImpl<$Res>
    extends _$TestRequestModelCopyWithImpl<$Res, _$TestRequestModelImpl>
    implements _$$TestRequestModelImplCopyWith<$Res> {
  __$$TestRequestModelImplCopyWithImpl(_$TestRequestModelImpl _value,
      $Res Function(_$TestRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? doctorId = freezed,
    Object? laboratoryId = freezed,
    Object? requestType = null,
    Object? serviceId = freezed,
    Object? laboratoryServiceId = freezed,
    Object? doctorServiceId = freezed,
    Object? status = null,
    Object? scheduledDate = null,
    Object? scheduledTimeSlot = freezed,
    Object? patientAddress = null,
    Object? patientLatitude = freezed,
    Object? patientLongitude = freezed,
    Object? patientNotes = freezed,
    Object? acceptedAt = freezed,
    Object? onTheWayAt = freezed,
    Object? sampleCollectedAt = freezed,
    Object? deliveredToLabAt = freezed,
    Object? completedAt = freezed,
    Object? cancelledAt = freezed,
    Object? priceMnt = null,
    Object? doctorCommissionMnt = freezed,
    Object? cancellationReason = freezed,
    Object? cancelledBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TestRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: freezed == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String?,
      laboratoryId: freezed == laboratoryId
          ? _value.laboratoryId
          : laboratoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      requestType: null == requestType
          ? _value.requestType
          : requestType // ignore: cast_nullable_to_non_nullable
              as RequestType,
      serviceId: freezed == serviceId
          ? _value.serviceId
          : serviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      laboratoryServiceId: freezed == laboratoryServiceId
          ? _value.laboratoryServiceId
          : laboratoryServiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      doctorServiceId: freezed == doctorServiceId
          ? _value.doctorServiceId
          : doctorServiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as RequestStatus,
      scheduledDate: null == scheduledDate
          ? _value.scheduledDate
          : scheduledDate // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledTimeSlot: freezed == scheduledTimeSlot
          ? _value.scheduledTimeSlot
          : scheduledTimeSlot // ignore: cast_nullable_to_non_nullable
              as String?,
      patientAddress: null == patientAddress
          ? _value.patientAddress
          : patientAddress // ignore: cast_nullable_to_non_nullable
              as String,
      patientLatitude: freezed == patientLatitude
          ? _value.patientLatitude
          : patientLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      patientLongitude: freezed == patientLongitude
          ? _value.patientLongitude
          : patientLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      patientNotes: freezed == patientNotes
          ? _value.patientNotes
          : patientNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      onTheWayAt: freezed == onTheWayAt
          ? _value.onTheWayAt
          : onTheWayAt // ignore: cast_nullable_to_non_nullable
              as String?,
      sampleCollectedAt: freezed == sampleCollectedAt
          ? _value.sampleCollectedAt
          : sampleCollectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveredToLabAt: freezed == deliveredToLabAt
          ? _value.deliveredToLabAt
          : deliveredToLabAt // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as String?,
      priceMnt: null == priceMnt
          ? _value.priceMnt
          : priceMnt // ignore: cast_nullable_to_non_nullable
              as int,
      doctorCommissionMnt: freezed == doctorCommissionMnt
          ? _value.doctorCommissionMnt
          : doctorCommissionMnt // ignore: cast_nullable_to_non_nullable
              as int?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancelledBy: freezed == cancelledBy
          ? _value.cancelledBy
          : cancelledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestRequestModelImpl implements _TestRequestModel {
  const _$TestRequestModelImpl(
      {required this.id,
      @JsonKey(name: 'patient_id') required this.patientId,
      @JsonKey(name: 'doctor_id') this.doctorId,
      @JsonKey(name: 'laboratory_id') this.laboratoryId,
      @JsonKey(name: 'request_type') required this.requestType,
      @JsonKey(name: 'service_id') this.serviceId,
      @JsonKey(name: 'laboratory_service_id') this.laboratoryServiceId,
      @JsonKey(name: 'doctor_service_id') this.doctorServiceId,
      required this.status,
      @JsonKey(name: 'scheduled_date') required this.scheduledDate,
      @JsonKey(name: 'scheduled_time_slot') this.scheduledTimeSlot,
      @JsonKey(name: 'patient_address') required this.patientAddress,
      @JsonKey(name: 'patient_latitude') this.patientLatitude,
      @JsonKey(name: 'patient_longitude') this.patientLongitude,
      @JsonKey(name: 'patient_notes') this.patientNotes,
      @JsonKey(name: 'accepted_at') this.acceptedAt,
      @JsonKey(name: 'on_the_way_at') this.onTheWayAt,
      @JsonKey(name: 'sample_collected_at') this.sampleCollectedAt,
      @JsonKey(name: 'delivered_to_lab_at') this.deliveredToLabAt,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'cancelled_at') this.cancelledAt,
      @JsonKey(name: 'price_mnt') required this.priceMnt,
      @JsonKey(name: 'doctor_commission_mnt') this.doctorCommissionMnt,
      @JsonKey(name: 'cancellation_reason') this.cancellationReason,
      @JsonKey(name: 'cancelled_by') this.cancelledBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$TestRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TestRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'patient_id')
  final String patientId;
  @override
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @override
  @JsonKey(name: 'laboratory_id')
  final String? laboratoryId;
  @override
  @JsonKey(name: 'request_type')
  final RequestType requestType;
  @override
  @JsonKey(name: 'service_id')
  final String? serviceId;
  @override
  @JsonKey(name: 'laboratory_service_id')
  final String? laboratoryServiceId;
  @override
  @JsonKey(name: 'doctor_service_id')
  final String? doctorServiceId;
  @override
  final RequestStatus status;
  @override
  @JsonKey(name: 'scheduled_date')
  final String scheduledDate;
  @override
  @JsonKey(name: 'scheduled_time_slot')
  final String? scheduledTimeSlot;
  @override
  @JsonKey(name: 'patient_address')
  final String patientAddress;
  @override
  @JsonKey(name: 'patient_latitude')
  final double? patientLatitude;
  @override
  @JsonKey(name: 'patient_longitude')
  final double? patientLongitude;
  @override
  @JsonKey(name: 'patient_notes')
  final String? patientNotes;
  @override
  @JsonKey(name: 'accepted_at')
  final String? acceptedAt;
  @override
  @JsonKey(name: 'on_the_way_at')
  final String? onTheWayAt;
  @override
  @JsonKey(name: 'sample_collected_at')
  final String? sampleCollectedAt;
  @override
  @JsonKey(name: 'delivered_to_lab_at')
  final String? deliveredToLabAt;
  @override
  @JsonKey(name: 'completed_at')
  final String? completedAt;
  @override
  @JsonKey(name: 'cancelled_at')
  final String? cancelledAt;
  @override
  @JsonKey(name: 'price_mnt')
  final int priceMnt;
  @override
  @JsonKey(name: 'doctor_commission_mnt')
  final int? doctorCommissionMnt;
  @override
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
  @override
  @JsonKey(name: 'cancelled_by')
  final String? cancelledBy;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'TestRequestModel(id: $id, patientId: $patientId, doctorId: $doctorId, laboratoryId: $laboratoryId, requestType: $requestType, serviceId: $serviceId, laboratoryServiceId: $laboratoryServiceId, doctorServiceId: $doctorServiceId, status: $status, scheduledDate: $scheduledDate, scheduledTimeSlot: $scheduledTimeSlot, patientAddress: $patientAddress, patientLatitude: $patientLatitude, patientLongitude: $patientLongitude, patientNotes: $patientNotes, acceptedAt: $acceptedAt, onTheWayAt: $onTheWayAt, sampleCollectedAt: $sampleCollectedAt, deliveredToLabAt: $deliveredToLabAt, completedAt: $completedAt, cancelledAt: $cancelledAt, priceMnt: $priceMnt, doctorCommissionMnt: $doctorCommissionMnt, cancellationReason: $cancellationReason, cancelledBy: $cancelledBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.laboratoryId, laboratoryId) ||
                other.laboratoryId == laboratoryId) &&
            (identical(other.requestType, requestType) ||
                other.requestType == requestType) &&
            (identical(other.serviceId, serviceId) ||
                other.serviceId == serviceId) &&
            (identical(other.laboratoryServiceId, laboratoryServiceId) ||
                other.laboratoryServiceId == laboratoryServiceId) &&
            (identical(other.doctorServiceId, doctorServiceId) ||
                other.doctorServiceId == doctorServiceId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.scheduledDate, scheduledDate) ||
                other.scheduledDate == scheduledDate) &&
            (identical(other.scheduledTimeSlot, scheduledTimeSlot) ||
                other.scheduledTimeSlot == scheduledTimeSlot) &&
            (identical(other.patientAddress, patientAddress) ||
                other.patientAddress == patientAddress) &&
            (identical(other.patientLatitude, patientLatitude) ||
                other.patientLatitude == patientLatitude) &&
            (identical(other.patientLongitude, patientLongitude) ||
                other.patientLongitude == patientLongitude) &&
            (identical(other.patientNotes, patientNotes) ||
                other.patientNotes == patientNotes) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.onTheWayAt, onTheWayAt) ||
                other.onTheWayAt == onTheWayAt) &&
            (identical(other.sampleCollectedAt, sampleCollectedAt) ||
                other.sampleCollectedAt == sampleCollectedAt) &&
            (identical(other.deliveredToLabAt, deliveredToLabAt) ||
                other.deliveredToLabAt == deliveredToLabAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.priceMnt, priceMnt) ||
                other.priceMnt == priceMnt) &&
            (identical(other.doctorCommissionMnt, doctorCommissionMnt) ||
                other.doctorCommissionMnt == doctorCommissionMnt) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.cancelledBy, cancelledBy) ||
                other.cancelledBy == cancelledBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        patientId,
        doctorId,
        laboratoryId,
        requestType,
        serviceId,
        laboratoryServiceId,
        doctorServiceId,
        status,
        scheduledDate,
        scheduledTimeSlot,
        patientAddress,
        patientLatitude,
        patientLongitude,
        patientNotes,
        acceptedAt,
        onTheWayAt,
        sampleCollectedAt,
        deliveredToLabAt,
        completedAt,
        cancelledAt,
        priceMnt,
        doctorCommissionMnt,
        cancellationReason,
        cancelledBy,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestRequestModelImplCopyWith<_$TestRequestModelImpl> get copyWith =>
      __$$TestRequestModelImplCopyWithImpl<_$TestRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TestRequestModelImplToJson(
      this,
    );
  }
}

abstract class _TestRequestModel implements TestRequestModel {
  const factory _TestRequestModel(
      {required final String id,
      @JsonKey(name: 'patient_id') required final String patientId,
      @JsonKey(name: 'doctor_id') final String? doctorId,
      @JsonKey(name: 'laboratory_id') final String? laboratoryId,
      @JsonKey(name: 'request_type') required final RequestType requestType,
      @JsonKey(name: 'service_id') final String? serviceId,
      @JsonKey(name: 'laboratory_service_id') final String? laboratoryServiceId,
      @JsonKey(name: 'doctor_service_id') final String? doctorServiceId,
      required final RequestStatus status,
      @JsonKey(name: 'scheduled_date') required final String scheduledDate,
      @JsonKey(name: 'scheduled_time_slot') final String? scheduledTimeSlot,
      @JsonKey(name: 'patient_address') required final String patientAddress,
      @JsonKey(name: 'patient_latitude') final double? patientLatitude,
      @JsonKey(name: 'patient_longitude') final double? patientLongitude,
      @JsonKey(name: 'patient_notes') final String? patientNotes,
      @JsonKey(name: 'accepted_at') final String? acceptedAt,
      @JsonKey(name: 'on_the_way_at') final String? onTheWayAt,
      @JsonKey(name: 'sample_collected_at') final String? sampleCollectedAt,
      @JsonKey(name: 'delivered_to_lab_at') final String? deliveredToLabAt,
      @JsonKey(name: 'completed_at') final String? completedAt,
      @JsonKey(name: 'cancelled_at') final String? cancelledAt,
      @JsonKey(name: 'price_mnt') required final int priceMnt,
      @JsonKey(name: 'doctor_commission_mnt') final int? doctorCommissionMnt,
      @JsonKey(name: 'cancellation_reason') final String? cancellationReason,
      @JsonKey(name: 'cancelled_by') final String? cancelledBy,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at')
      final String? updatedAt}) = _$TestRequestModelImpl;

  factory _TestRequestModel.fromJson(Map<String, dynamic> json) =
      _$TestRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'patient_id')
  String get patientId;
  @override
  @JsonKey(name: 'doctor_id')
  String? get doctorId;
  @override
  @JsonKey(name: 'laboratory_id')
  String? get laboratoryId;
  @override
  @JsonKey(name: 'request_type')
  RequestType get requestType;
  @override
  @JsonKey(name: 'service_id')
  String? get serviceId;
  @override
  @JsonKey(name: 'laboratory_service_id')
  String? get laboratoryServiceId;
  @override
  @JsonKey(name: 'doctor_service_id')
  String? get doctorServiceId;
  @override
  RequestStatus get status;
  @override
  @JsonKey(name: 'scheduled_date')
  String get scheduledDate;
  @override
  @JsonKey(name: 'scheduled_time_slot')
  String? get scheduledTimeSlot;
  @override
  @JsonKey(name: 'patient_address')
  String get patientAddress;
  @override
  @JsonKey(name: 'patient_latitude')
  double? get patientLatitude;
  @override
  @JsonKey(name: 'patient_longitude')
  double? get patientLongitude;
  @override
  @JsonKey(name: 'patient_notes')
  String? get patientNotes;
  @override
  @JsonKey(name: 'accepted_at')
  String? get acceptedAt;
  @override
  @JsonKey(name: 'on_the_way_at')
  String? get onTheWayAt;
  @override
  @JsonKey(name: 'sample_collected_at')
  String? get sampleCollectedAt;
  @override
  @JsonKey(name: 'delivered_to_lab_at')
  String? get deliveredToLabAt;
  @override
  @JsonKey(name: 'completed_at')
  String? get completedAt;
  @override
  @JsonKey(name: 'cancelled_at')
  String? get cancelledAt;
  @override
  @JsonKey(name: 'price_mnt')
  int get priceMnt;
  @override
  @JsonKey(name: 'doctor_commission_mnt')
  int? get doctorCommissionMnt;
  @override
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason;
  @override
  @JsonKey(name: 'cancelled_by')
  String? get cancelledBy;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TestRequestModelImplCopyWith<_$TestRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
