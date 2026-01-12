// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'patient_id')
  String get patientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'test_request_id')
  String get testRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount_mnt')
  int get amountMnt => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_method')
  PaymentMethod get paymentMethod => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  PaymentStatus get paymentStatus =>
      throw _privateConstructorUsedError; // QPay specific fields
  @JsonKey(name: 'qpay_invoice_id')
  String? get qpayInvoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qpay_qr_text')
  String? get qpayQrText => throw _privateConstructorUsedError;
  @JsonKey(name: 'qpay_urls')
  Map<String, dynamic>? get qpayUrls =>
      throw _privateConstructorUsedError; // Transaction tracking
  @JsonKey(name: 'transaction_id')
  String? get transactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'transaction_reference')
  String? get transactionReference =>
      throw _privateConstructorUsedError; // Timestamps
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'failed_at')
  DateTime? get failedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'refunded_at')
  DateTime? get refundedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt => throw _privateConstructorUsedError; // Reasons
  @JsonKey(name: 'failure_reason')
  String? get failureReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'refund_reason')
  String? get refundReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason =>
      throw _privateConstructorUsedError; // Metadata
  Map<String, dynamic>? get metadata =>
      throw _privateConstructorUsedError; // Audit fields
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
          PaymentModel value, $Res Function(PaymentModel) then) =
      _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'patient_id') String patientId,
      @JsonKey(name: 'test_request_id') String testRequestId,
      @JsonKey(name: 'amount_mnt') int amountMnt,
      @JsonKey(name: 'payment_method') PaymentMethod paymentMethod,
      @JsonKey(name: 'payment_status') PaymentStatus paymentStatus,
      @JsonKey(name: 'qpay_invoice_id') String? qpayInvoiceId,
      @JsonKey(name: 'qpay_qr_text') String? qpayQrText,
      @JsonKey(name: 'qpay_urls') Map<String, dynamic>? qpayUrls,
      @JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'transaction_reference') String? transactionReference,
      @JsonKey(name: 'paid_at') DateTime? paidAt,
      @JsonKey(name: 'failed_at') DateTime? failedAt,
      @JsonKey(name: 'refunded_at') DateTime? refundedAt,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
      @JsonKey(name: 'failure_reason') String? failureReason,
      @JsonKey(name: 'refund_reason') String? refundReason,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? testRequestId = null,
    Object? amountMnt = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? qpayInvoiceId = freezed,
    Object? qpayQrText = freezed,
    Object? qpayUrls = freezed,
    Object? transactionId = freezed,
    Object? transactionReference = freezed,
    Object? paidAt = freezed,
    Object? failedAt = freezed,
    Object? refundedAt = freezed,
    Object? cancelledAt = freezed,
    Object? failureReason = freezed,
    Object? refundReason = freezed,
    Object? cancellationReason = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      testRequestId: null == testRequestId
          ? _value.testRequestId
          : testRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMnt: null == amountMnt
          ? _value.amountMnt
          : amountMnt // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      qpayInvoiceId: freezed == qpayInvoiceId
          ? _value.qpayInvoiceId
          : qpayInvoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      qpayQrText: freezed == qpayQrText
          ? _value.qpayQrText
          : qpayQrText // ignore: cast_nullable_to_non_nullable
              as String?,
      qpayUrls: freezed == qpayUrls
          ? _value.qpayUrls
          : qpayUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionReference: freezed == transactionReference
          ? _value.transactionReference
          : transactionReference // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedAt: freezed == failedAt
          ? _value.failedAt
          : failedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundReason: freezed == refundReason
          ? _value.refundReason
          : refundReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
          _$PaymentModelImpl value, $Res Function(_$PaymentModelImpl) then) =
      __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'patient_id') String patientId,
      @JsonKey(name: 'test_request_id') String testRequestId,
      @JsonKey(name: 'amount_mnt') int amountMnt,
      @JsonKey(name: 'payment_method') PaymentMethod paymentMethod,
      @JsonKey(name: 'payment_status') PaymentStatus paymentStatus,
      @JsonKey(name: 'qpay_invoice_id') String? qpayInvoiceId,
      @JsonKey(name: 'qpay_qr_text') String? qpayQrText,
      @JsonKey(name: 'qpay_urls') Map<String, dynamic>? qpayUrls,
      @JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'transaction_reference') String? transactionReference,
      @JsonKey(name: 'paid_at') DateTime? paidAt,
      @JsonKey(name: 'failed_at') DateTime? failedAt,
      @JsonKey(name: 'refunded_at') DateTime? refundedAt,
      @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
      @JsonKey(name: 'failure_reason') String? failureReason,
      @JsonKey(name: 'refund_reason') String? refundReason,
      @JsonKey(name: 'cancellation_reason') String? cancellationReason,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
      _$PaymentModelImpl _value, $Res Function(_$PaymentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? testRequestId = null,
    Object? amountMnt = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? qpayInvoiceId = freezed,
    Object? qpayQrText = freezed,
    Object? qpayUrls = freezed,
    Object? transactionId = freezed,
    Object? transactionReference = freezed,
    Object? paidAt = freezed,
    Object? failedAt = freezed,
    Object? refundedAt = freezed,
    Object? cancelledAt = freezed,
    Object? failureReason = freezed,
    Object? refundReason = freezed,
    Object? cancellationReason = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$PaymentModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      testRequestId: null == testRequestId
          ? _value.testRequestId
          : testRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMnt: null == amountMnt
          ? _value.amountMnt
          : amountMnt // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      qpayInvoiceId: freezed == qpayInvoiceId
          ? _value.qpayInvoiceId
          : qpayInvoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      qpayQrText: freezed == qpayQrText
          ? _value.qpayQrText
          : qpayQrText // ignore: cast_nullable_to_non_nullable
              as String?,
      qpayUrls: freezed == qpayUrls
          ? _value._qpayUrls
          : qpayUrls // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionReference: freezed == transactionReference
          ? _value.transactionReference
          : transactionReference // ignore: cast_nullable_to_non_nullable
              as String?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedAt: freezed == failedAt
          ? _value.failedAt
          : failedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failureReason: freezed == failureReason
          ? _value.failureReason
          : failureReason // ignore: cast_nullable_to_non_nullable
              as String?,
      refundReason: freezed == refundReason
          ? _value.refundReason
          : refundReason // ignore: cast_nullable_to_non_nullable
              as String?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
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
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl(
      {required this.id,
      @JsonKey(name: 'patient_id') required this.patientId,
      @JsonKey(name: 'test_request_id') required this.testRequestId,
      @JsonKey(name: 'amount_mnt') required this.amountMnt,
      @JsonKey(name: 'payment_method') required this.paymentMethod,
      @JsonKey(name: 'payment_status') required this.paymentStatus,
      @JsonKey(name: 'qpay_invoice_id') this.qpayInvoiceId,
      @JsonKey(name: 'qpay_qr_text') this.qpayQrText,
      @JsonKey(name: 'qpay_urls') final Map<String, dynamic>? qpayUrls,
      @JsonKey(name: 'transaction_id') this.transactionId,
      @JsonKey(name: 'transaction_reference') this.transactionReference,
      @JsonKey(name: 'paid_at') this.paidAt,
      @JsonKey(name: 'failed_at') this.failedAt,
      @JsonKey(name: 'refunded_at') this.refundedAt,
      @JsonKey(name: 'cancelled_at') this.cancelledAt,
      @JsonKey(name: 'failure_reason') this.failureReason,
      @JsonKey(name: 'refund_reason') this.refundReason,
      @JsonKey(name: 'cancellation_reason') this.cancellationReason,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : _qpayUrls = qpayUrls,
        _metadata = metadata;

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'patient_id')
  final String patientId;
  @override
  @JsonKey(name: 'test_request_id')
  final String testRequestId;
  @override
  @JsonKey(name: 'amount_mnt')
  final int amountMnt;
  @override
  @JsonKey(name: 'payment_method')
  final PaymentMethod paymentMethod;
  @override
  @JsonKey(name: 'payment_status')
  final PaymentStatus paymentStatus;
// QPay specific fields
  @override
  @JsonKey(name: 'qpay_invoice_id')
  final String? qpayInvoiceId;
  @override
  @JsonKey(name: 'qpay_qr_text')
  final String? qpayQrText;
  final Map<String, dynamic>? _qpayUrls;
  @override
  @JsonKey(name: 'qpay_urls')
  Map<String, dynamic>? get qpayUrls {
    final value = _qpayUrls;
    if (value == null) return null;
    if (_qpayUrls is EqualUnmodifiableMapView) return _qpayUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Transaction tracking
  @override
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @override
  @JsonKey(name: 'transaction_reference')
  final String? transactionReference;
// Timestamps
  @override
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;
  @override
  @JsonKey(name: 'failed_at')
  final DateTime? failedAt;
  @override
  @JsonKey(name: 'refunded_at')
  final DateTime? refundedAt;
  @override
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
// Reasons
  @override
  @JsonKey(name: 'failure_reason')
  final String? failureReason;
  @override
  @JsonKey(name: 'refund_reason')
  final String? refundReason;
  @override
  @JsonKey(name: 'cancellation_reason')
  final String? cancellationReason;
// Metadata
  final Map<String, dynamic>? _metadata;
// Metadata
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Audit fields
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, patientId: $patientId, testRequestId: $testRequestId, amountMnt: $amountMnt, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, qpayInvoiceId: $qpayInvoiceId, qpayQrText: $qpayQrText, qpayUrls: $qpayUrls, transactionId: $transactionId, transactionReference: $transactionReference, paidAt: $paidAt, failedAt: $failedAt, refundedAt: $refundedAt, cancelledAt: $cancelledAt, failureReason: $failureReason, refundReason: $refundReason, cancellationReason: $cancellationReason, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.testRequestId, testRequestId) ||
                other.testRequestId == testRequestId) &&
            (identical(other.amountMnt, amountMnt) ||
                other.amountMnt == amountMnt) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.qpayInvoiceId, qpayInvoiceId) ||
                other.qpayInvoiceId == qpayInvoiceId) &&
            (identical(other.qpayQrText, qpayQrText) ||
                other.qpayQrText == qpayQrText) &&
            const DeepCollectionEquality().equals(other._qpayUrls, _qpayUrls) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.transactionReference, transactionReference) ||
                other.transactionReference == transactionReference) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.failedAt, failedAt) ||
                other.failedAt == failedAt) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.failureReason, failureReason) ||
                other.failureReason == failureReason) &&
            (identical(other.refundReason, refundReason) ||
                other.refundReason == refundReason) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
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
        testRequestId,
        amountMnt,
        paymentMethod,
        paymentStatus,
        qpayInvoiceId,
        qpayQrText,
        const DeepCollectionEquality().hash(_qpayUrls),
        transactionId,
        transactionReference,
        paidAt,
        failedAt,
        refundedAt,
        cancelledAt,
        failureReason,
        refundReason,
        cancellationReason,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel(
      {required final String id,
      @JsonKey(name: 'patient_id') required final String patientId,
      @JsonKey(name: 'test_request_id') required final String testRequestId,
      @JsonKey(name: 'amount_mnt') required final int amountMnt,
      @JsonKey(name: 'payment_method')
      required final PaymentMethod paymentMethod,
      @JsonKey(name: 'payment_status')
      required final PaymentStatus paymentStatus,
      @JsonKey(name: 'qpay_invoice_id') final String? qpayInvoiceId,
      @JsonKey(name: 'qpay_qr_text') final String? qpayQrText,
      @JsonKey(name: 'qpay_urls') final Map<String, dynamic>? qpayUrls,
      @JsonKey(name: 'transaction_id') final String? transactionId,
      @JsonKey(name: 'transaction_reference')
      final String? transactionReference,
      @JsonKey(name: 'paid_at') final DateTime? paidAt,
      @JsonKey(name: 'failed_at') final DateTime? failedAt,
      @JsonKey(name: 'refunded_at') final DateTime? refundedAt,
      @JsonKey(name: 'cancelled_at') final DateTime? cancelledAt,
      @JsonKey(name: 'failure_reason') final String? failureReason,
      @JsonKey(name: 'refund_reason') final String? refundReason,
      @JsonKey(name: 'cancellation_reason') final String? cancellationReason,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'patient_id')
  String get patientId;
  @override
  @JsonKey(name: 'test_request_id')
  String get testRequestId;
  @override
  @JsonKey(name: 'amount_mnt')
  int get amountMnt;
  @override
  @JsonKey(name: 'payment_method')
  PaymentMethod get paymentMethod;
  @override
  @JsonKey(name: 'payment_status')
  PaymentStatus get paymentStatus;
  @override // QPay specific fields
  @JsonKey(name: 'qpay_invoice_id')
  String? get qpayInvoiceId;
  @override
  @JsonKey(name: 'qpay_qr_text')
  String? get qpayQrText;
  @override
  @JsonKey(name: 'qpay_urls')
  Map<String, dynamic>? get qpayUrls;
  @override // Transaction tracking
  @JsonKey(name: 'transaction_id')
  String? get transactionId;
  @override
  @JsonKey(name: 'transaction_reference')
  String? get transactionReference;
  @override // Timestamps
  @JsonKey(name: 'paid_at')
  DateTime? get paidAt;
  @override
  @JsonKey(name: 'failed_at')
  DateTime? get failedAt;
  @override
  @JsonKey(name: 'refunded_at')
  DateTime? get refundedAt;
  @override
  @JsonKey(name: 'cancelled_at')
  DateTime? get cancelledAt;
  @override // Reasons
  @JsonKey(name: 'failure_reason')
  String? get failureReason;
  @override
  @JsonKey(name: 'refund_reason')
  String? get refundReason;
  @override
  @JsonKey(name: 'cancellation_reason')
  String? get cancellationReason;
  @override // Metadata
  Map<String, dynamic>? get metadata;
  @override // Audit fields
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QPayInvoice _$QPayInvoiceFromJson(Map<String, dynamic> json) {
  return _QPayInvoice.fromJson(json);
}

/// @nodoc
mixin _$QPayInvoice {
  @JsonKey(name: 'invoice_id')
  String get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_text')
  String get qrText => throw _privateConstructorUsedError;
  @JsonKey(name: 'qr_image')
  String get qrImage => throw _privateConstructorUsedError;
  List<QPayUrl> get urls => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QPayInvoiceCopyWith<QPayInvoice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QPayInvoiceCopyWith<$Res> {
  factory $QPayInvoiceCopyWith(
          QPayInvoice value, $Res Function(QPayInvoice) then) =
      _$QPayInvoiceCopyWithImpl<$Res, QPayInvoice>;
  @useResult
  $Res call(
      {@JsonKey(name: 'invoice_id') String invoiceId,
      @JsonKey(name: 'qr_text') String qrText,
      @JsonKey(name: 'qr_image') String qrImage,
      List<QPayUrl> urls});
}

/// @nodoc
class _$QPayInvoiceCopyWithImpl<$Res, $Val extends QPayInvoice>
    implements $QPayInvoiceCopyWith<$Res> {
  _$QPayInvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceId = null,
    Object? qrText = null,
    Object? qrImage = null,
    Object? urls = null,
  }) {
    return _then(_value.copyWith(
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      qrText: null == qrText
          ? _value.qrText
          : qrText // ignore: cast_nullable_to_non_nullable
              as String,
      qrImage: null == qrImage
          ? _value.qrImage
          : qrImage // ignore: cast_nullable_to_non_nullable
              as String,
      urls: null == urls
          ? _value.urls
          : urls // ignore: cast_nullable_to_non_nullable
              as List<QPayUrl>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QPayInvoiceImplCopyWith<$Res>
    implements $QPayInvoiceCopyWith<$Res> {
  factory _$$QPayInvoiceImplCopyWith(
          _$QPayInvoiceImpl value, $Res Function(_$QPayInvoiceImpl) then) =
      __$$QPayInvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'invoice_id') String invoiceId,
      @JsonKey(name: 'qr_text') String qrText,
      @JsonKey(name: 'qr_image') String qrImage,
      List<QPayUrl> urls});
}

/// @nodoc
class __$$QPayInvoiceImplCopyWithImpl<$Res>
    extends _$QPayInvoiceCopyWithImpl<$Res, _$QPayInvoiceImpl>
    implements _$$QPayInvoiceImplCopyWith<$Res> {
  __$$QPayInvoiceImplCopyWithImpl(
      _$QPayInvoiceImpl _value, $Res Function(_$QPayInvoiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceId = null,
    Object? qrText = null,
    Object? qrImage = null,
    Object? urls = null,
  }) {
    return _then(_$QPayInvoiceImpl(
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      qrText: null == qrText
          ? _value.qrText
          : qrText // ignore: cast_nullable_to_non_nullable
              as String,
      qrImage: null == qrImage
          ? _value.qrImage
          : qrImage // ignore: cast_nullable_to_non_nullable
              as String,
      urls: null == urls
          ? _value._urls
          : urls // ignore: cast_nullable_to_non_nullable
              as List<QPayUrl>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QPayInvoiceImpl implements _QPayInvoice {
  const _$QPayInvoiceImpl(
      {@JsonKey(name: 'invoice_id') required this.invoiceId,
      @JsonKey(name: 'qr_text') required this.qrText,
      @JsonKey(name: 'qr_image') required this.qrImage,
      required final List<QPayUrl> urls})
      : _urls = urls;

  factory _$QPayInvoiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$QPayInvoiceImplFromJson(json);

  @override
  @JsonKey(name: 'invoice_id')
  final String invoiceId;
  @override
  @JsonKey(name: 'qr_text')
  final String qrText;
  @override
  @JsonKey(name: 'qr_image')
  final String qrImage;
  final List<QPayUrl> _urls;
  @override
  List<QPayUrl> get urls {
    if (_urls is EqualUnmodifiableListView) return _urls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urls);
  }

  @override
  String toString() {
    return 'QPayInvoice(invoiceId: $invoiceId, qrText: $qrText, qrImage: $qrImage, urls: $urls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QPayInvoiceImpl &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.qrText, qrText) || other.qrText == qrText) &&
            (identical(other.qrImage, qrImage) || other.qrImage == qrImage) &&
            const DeepCollectionEquality().equals(other._urls, _urls));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, invoiceId, qrText, qrImage,
      const DeepCollectionEquality().hash(_urls));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QPayInvoiceImplCopyWith<_$QPayInvoiceImpl> get copyWith =>
      __$$QPayInvoiceImplCopyWithImpl<_$QPayInvoiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QPayInvoiceImplToJson(
      this,
    );
  }
}

abstract class _QPayInvoice implements QPayInvoice {
  const factory _QPayInvoice(
      {@JsonKey(name: 'invoice_id') required final String invoiceId,
      @JsonKey(name: 'qr_text') required final String qrText,
      @JsonKey(name: 'qr_image') required final String qrImage,
      required final List<QPayUrl> urls}) = _$QPayInvoiceImpl;

  factory _QPayInvoice.fromJson(Map<String, dynamic> json) =
      _$QPayInvoiceImpl.fromJson;

  @override
  @JsonKey(name: 'invoice_id')
  String get invoiceId;
  @override
  @JsonKey(name: 'qr_text')
  String get qrText;
  @override
  @JsonKey(name: 'qr_image')
  String get qrImage;
  @override
  List<QPayUrl> get urls;
  @override
  @JsonKey(ignore: true)
  _$$QPayInvoiceImplCopyWith<_$QPayInvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QPayUrl _$QPayUrlFromJson(Map<String, dynamic> json) {
  return _QPayUrl.fromJson(json);
}

/// @nodoc
mixin _$QPayUrl {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get logo => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QPayUrlCopyWith<QPayUrl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QPayUrlCopyWith<$Res> {
  factory $QPayUrlCopyWith(QPayUrl value, $Res Function(QPayUrl) then) =
      _$QPayUrlCopyWithImpl<$Res, QPayUrl>;
  @useResult
  $Res call({String name, String description, String logo, String link});
}

/// @nodoc
class _$QPayUrlCopyWithImpl<$Res, $Val extends QPayUrl>
    implements $QPayUrlCopyWith<$Res> {
  _$QPayUrlCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? logo = null,
    Object? link = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QPayUrlImplCopyWith<$Res> implements $QPayUrlCopyWith<$Res> {
  factory _$$QPayUrlImplCopyWith(
          _$QPayUrlImpl value, $Res Function(_$QPayUrlImpl) then) =
      __$$QPayUrlImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String description, String logo, String link});
}

/// @nodoc
class __$$QPayUrlImplCopyWithImpl<$Res>
    extends _$QPayUrlCopyWithImpl<$Res, _$QPayUrlImpl>
    implements _$$QPayUrlImplCopyWith<$Res> {
  __$$QPayUrlImplCopyWithImpl(
      _$QPayUrlImpl _value, $Res Function(_$QPayUrlImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? logo = null,
    Object? link = null,
  }) {
    return _then(_$QPayUrlImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      logo: null == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QPayUrlImpl implements _QPayUrl {
  const _$QPayUrlImpl(
      {required this.name,
      required this.description,
      required this.logo,
      required this.link});

  factory _$QPayUrlImpl.fromJson(Map<String, dynamic> json) =>
      _$$QPayUrlImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final String logo;
  @override
  final String link;

  @override
  String toString() {
    return 'QPayUrl(name: $name, description: $description, logo: $logo, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QPayUrlImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, logo, link);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QPayUrlImplCopyWith<_$QPayUrlImpl> get copyWith =>
      __$$QPayUrlImplCopyWithImpl<_$QPayUrlImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QPayUrlImplToJson(
      this,
    );
  }
}

abstract class _QPayUrl implements QPayUrl {
  const factory _QPayUrl(
      {required final String name,
      required final String description,
      required final String logo,
      required final String link}) = _$QPayUrlImpl;

  factory _QPayUrl.fromJson(Map<String, dynamic> json) = _$QPayUrlImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  String get logo;
  @override
  String get link;
  @override
  @JsonKey(ignore: true)
  _$$QPayUrlImplCopyWith<_$QPayUrlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QPayAuthToken _$QPayAuthTokenFromJson(Map<String, dynamic> json) {
  return _QPayAuthToken.fromJson(json);
}

/// @nodoc
mixin _$QPayAuthToken {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String get tokenType => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in')
  int get expiresIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_expires_in')
  int get refreshExpiresIn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QPayAuthTokenCopyWith<QPayAuthToken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QPayAuthTokenCopyWith<$Res> {
  factory $QPayAuthTokenCopyWith(
          QPayAuthToken value, $Res Function(QPayAuthToken) then) =
      _$QPayAuthTokenCopyWithImpl<$Res, QPayAuthToken>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'expires_in') int expiresIn,
      @JsonKey(name: 'refresh_expires_in') int refreshExpiresIn});
}

/// @nodoc
class _$QPayAuthTokenCopyWithImpl<$Res, $Val extends QPayAuthToken>
    implements $QPayAuthTokenCopyWith<$Res> {
  _$QPayAuthTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? tokenType = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? refreshExpiresIn = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      refreshExpiresIn: null == refreshExpiresIn
          ? _value.refreshExpiresIn
          : refreshExpiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QPayAuthTokenImplCopyWith<$Res>
    implements $QPayAuthTokenCopyWith<$Res> {
  factory _$$QPayAuthTokenImplCopyWith(
          _$QPayAuthTokenImpl value, $Res Function(_$QPayAuthTokenImpl) then) =
      __$$QPayAuthTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'expires_in') int expiresIn,
      @JsonKey(name: 'refresh_expires_in') int refreshExpiresIn});
}

/// @nodoc
class __$$QPayAuthTokenImplCopyWithImpl<$Res>
    extends _$QPayAuthTokenCopyWithImpl<$Res, _$QPayAuthTokenImpl>
    implements _$$QPayAuthTokenImplCopyWith<$Res> {
  __$$QPayAuthTokenImplCopyWithImpl(
      _$QPayAuthTokenImpl _value, $Res Function(_$QPayAuthTokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? tokenType = null,
    Object? refreshToken = null,
    Object? expiresIn = null,
    Object? refreshExpiresIn = null,
  }) {
    return _then(_$QPayAuthTokenImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      refreshExpiresIn: null == refreshExpiresIn
          ? _value.refreshExpiresIn
          : refreshExpiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QPayAuthTokenImpl implements _QPayAuthToken {
  const _$QPayAuthTokenImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'token_type') required this.tokenType,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      @JsonKey(name: 'expires_in') required this.expiresIn,
      @JsonKey(name: 'refresh_expires_in') required this.refreshExpiresIn});

  factory _$QPayAuthTokenImpl.fromJson(Map<String, dynamic> json) =>
      _$$QPayAuthTokenImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'token_type')
  final String tokenType;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'expires_in')
  final int expiresIn;
  @override
  @JsonKey(name: 'refresh_expires_in')
  final int refreshExpiresIn;

  @override
  String toString() {
    return 'QPayAuthToken(accessToken: $accessToken, tokenType: $tokenType, refreshToken: $refreshToken, expiresIn: $expiresIn, refreshExpiresIn: $refreshExpiresIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QPayAuthTokenImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.refreshExpiresIn, refreshExpiresIn) ||
                other.refreshExpiresIn == refreshExpiresIn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, tokenType,
      refreshToken, expiresIn, refreshExpiresIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QPayAuthTokenImplCopyWith<_$QPayAuthTokenImpl> get copyWith =>
      __$$QPayAuthTokenImplCopyWithImpl<_$QPayAuthTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QPayAuthTokenImplToJson(
      this,
    );
  }
}

abstract class _QPayAuthToken implements QPayAuthToken {
  const factory _QPayAuthToken(
      {@JsonKey(name: 'access_token') required final String accessToken,
      @JsonKey(name: 'token_type') required final String tokenType,
      @JsonKey(name: 'refresh_token') required final String refreshToken,
      @JsonKey(name: 'expires_in') required final int expiresIn,
      @JsonKey(name: 'refresh_expires_in')
      required final int refreshExpiresIn}) = _$QPayAuthTokenImpl;

  factory _QPayAuthToken.fromJson(Map<String, dynamic> json) =
      _$QPayAuthTokenImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'token_type')
  String get tokenType;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'expires_in')
  int get expiresIn;
  @override
  @JsonKey(name: 'refresh_expires_in')
  int get refreshExpiresIn;
  @override
  @JsonKey(ignore: true)
  _$$QPayAuthTokenImplCopyWith<_$QPayAuthTokenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QPayPaymentCheck _$QPayPaymentCheckFromJson(Map<String, dynamic> json) {
  return _QPayPaymentCheck.fromJson(json);
}

/// @nodoc
mixin _$QPayPaymentCheck {
  @JsonKey(name: 'invoice_id')
  String get invoiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_id')
  String? get paymentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_date')
  DateTime? get paymentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'amount')
  int? get amount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QPayPaymentCheckCopyWith<QPayPaymentCheck> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QPayPaymentCheckCopyWith<$Res> {
  factory $QPayPaymentCheckCopyWith(
          QPayPaymentCheck value, $Res Function(QPayPaymentCheck) then) =
      _$QPayPaymentCheckCopyWithImpl<$Res, QPayPaymentCheck>;
  @useResult
  $Res call(
      {@JsonKey(name: 'invoice_id') String invoiceId,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_date') DateTime? paymentDate,
      @JsonKey(name: 'amount') int? amount});
}

/// @nodoc
class _$QPayPaymentCheckCopyWithImpl<$Res, $Val extends QPayPaymentCheck>
    implements $QPayPaymentCheckCopyWith<$Res> {
  _$QPayPaymentCheckCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceId = null,
    Object? paymentId = freezed,
    Object? paymentStatus = null,
    Object? paymentDate = freezed,
    Object? amount = freezed,
  }) {
    return _then(_value.copyWith(
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QPayPaymentCheckImplCopyWith<$Res>
    implements $QPayPaymentCheckCopyWith<$Res> {
  factory _$$QPayPaymentCheckImplCopyWith(_$QPayPaymentCheckImpl value,
          $Res Function(_$QPayPaymentCheckImpl) then) =
      __$$QPayPaymentCheckImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'invoice_id') String invoiceId,
      @JsonKey(name: 'payment_id') String? paymentId,
      @JsonKey(name: 'payment_status') String paymentStatus,
      @JsonKey(name: 'payment_date') DateTime? paymentDate,
      @JsonKey(name: 'amount') int? amount});
}

/// @nodoc
class __$$QPayPaymentCheckImplCopyWithImpl<$Res>
    extends _$QPayPaymentCheckCopyWithImpl<$Res, _$QPayPaymentCheckImpl>
    implements _$$QPayPaymentCheckImplCopyWith<$Res> {
  __$$QPayPaymentCheckImplCopyWithImpl(_$QPayPaymentCheckImpl _value,
      $Res Function(_$QPayPaymentCheckImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoiceId = null,
    Object? paymentId = freezed,
    Object? paymentStatus = null,
    Object? paymentDate = freezed,
    Object? amount = freezed,
  }) {
    return _then(_$QPayPaymentCheckImpl(
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentId: freezed == paymentId
          ? _value.paymentId
          : paymentId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      paymentDate: freezed == paymentDate
          ? _value.paymentDate
          : paymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      amount: freezed == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QPayPaymentCheckImpl implements _QPayPaymentCheck {
  const _$QPayPaymentCheckImpl(
      {@JsonKey(name: 'invoice_id') required this.invoiceId,
      @JsonKey(name: 'payment_id') this.paymentId,
      @JsonKey(name: 'payment_status') required this.paymentStatus,
      @JsonKey(name: 'payment_date') this.paymentDate,
      @JsonKey(name: 'amount') this.amount});

  factory _$QPayPaymentCheckImpl.fromJson(Map<String, dynamic> json) =>
      _$$QPayPaymentCheckImplFromJson(json);

  @override
  @JsonKey(name: 'invoice_id')
  final String invoiceId;
  @override
  @JsonKey(name: 'payment_id')
  final String? paymentId;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  @override
  @JsonKey(name: 'payment_date')
  final DateTime? paymentDate;
  @override
  @JsonKey(name: 'amount')
  final int? amount;

  @override
  String toString() {
    return 'QPayPaymentCheck(invoiceId: $invoiceId, paymentId: $paymentId, paymentStatus: $paymentStatus, paymentDate: $paymentDate, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QPayPaymentCheckImpl &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.paymentId, paymentId) ||
                other.paymentId == paymentId) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentDate, paymentDate) ||
                other.paymentDate == paymentDate) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, invoiceId, paymentId, paymentStatus, paymentDate, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QPayPaymentCheckImplCopyWith<_$QPayPaymentCheckImpl> get copyWith =>
      __$$QPayPaymentCheckImplCopyWithImpl<_$QPayPaymentCheckImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QPayPaymentCheckImplToJson(
      this,
    );
  }
}

abstract class _QPayPaymentCheck implements QPayPaymentCheck {
  const factory _QPayPaymentCheck(
      {@JsonKey(name: 'invoice_id') required final String invoiceId,
      @JsonKey(name: 'payment_id') final String? paymentId,
      @JsonKey(name: 'payment_status') required final String paymentStatus,
      @JsonKey(name: 'payment_date') final DateTime? paymentDate,
      @JsonKey(name: 'amount') final int? amount}) = _$QPayPaymentCheckImpl;

  factory _QPayPaymentCheck.fromJson(Map<String, dynamic> json) =
      _$QPayPaymentCheckImpl.fromJson;

  @override
  @JsonKey(name: 'invoice_id')
  String get invoiceId;
  @override
  @JsonKey(name: 'payment_id')
  String? get paymentId;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(name: 'payment_date')
  DateTime? get paymentDate;
  @override
  @JsonKey(name: 'amount')
  int? get amount;
  @override
  @JsonKey(ignore: true)
  _$$QPayPaymentCheckImplCopyWith<_$QPayPaymentCheckImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
