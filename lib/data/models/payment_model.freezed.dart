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
