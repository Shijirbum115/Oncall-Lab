// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      testRequestId: json['test_request_id'] as String,
      amountMnt: (json['amount_mnt'] as num).toInt(),
      paymentMethod:
          $enumDecode(_$PaymentMethodEnumMap, json['payment_method']),
      paymentStatus:
          $enumDecode(_$PaymentStatusEnumMap, json['payment_status']),
      qpayInvoiceId: json['qpay_invoice_id'] as String?,
      qpayQrText: json['qpay_qr_text'] as String?,
      qpayUrls: json['qpay_urls'] as Map<String, dynamic>?,
      transactionId: json['transaction_id'] as String?,
      transactionReference: json['transaction_reference'] as String?,
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      failedAt: json['failed_at'] == null
          ? null
          : DateTime.parse(json['failed_at'] as String),
      refundedAt: json['refunded_at'] == null
          ? null
          : DateTime.parse(json['refunded_at'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      failureReason: json['failure_reason'] as String?,
      refundReason: json['refund_reason'] as String?,
      cancellationReason: json['cancellation_reason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patient_id': instance.patientId,
      'test_request_id': instance.testRequestId,
      'amount_mnt': instance.amountMnt,
      'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'payment_status': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'qpay_invoice_id': instance.qpayInvoiceId,
      'qpay_qr_text': instance.qpayQrText,
      'qpay_urls': instance.qpayUrls,
      'transaction_id': instance.transactionId,
      'transaction_reference': instance.transactionReference,
      'paid_at': instance.paidAt?.toIso8601String(),
      'failed_at': instance.failedAt?.toIso8601String(),
      'refunded_at': instance.refundedAt?.toIso8601String(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'failure_reason': instance.failureReason,
      'refund_reason': instance.refundReason,
      'cancellation_reason': instance.cancellationReason,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.qpay: 'qpay',
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.bankTransfer: 'bank_transfer',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.processing: 'processing',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.cancelled: 'cancelled',
};
