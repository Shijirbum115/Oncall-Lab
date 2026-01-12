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

_$QPayInvoiceImpl _$$QPayInvoiceImplFromJson(Map<String, dynamic> json) =>
    _$QPayInvoiceImpl(
      invoiceId: json['invoice_id'] as String,
      qrText: json['qr_text'] as String,
      qrImage: json['qr_image'] as String,
      urls: (json['urls'] as List<dynamic>)
          .map((e) => QPayUrl.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QPayInvoiceImplToJson(_$QPayInvoiceImpl instance) =>
    <String, dynamic>{
      'invoice_id': instance.invoiceId,
      'qr_text': instance.qrText,
      'qr_image': instance.qrImage,
      'urls': instance.urls,
    };

_$QPayUrlImpl _$$QPayUrlImplFromJson(Map<String, dynamic> json) =>
    _$QPayUrlImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      logo: json['logo'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$$QPayUrlImplToJson(_$QPayUrlImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'logo': instance.logo,
      'link': instance.link,
    };

_$QPayAuthTokenImpl _$$QPayAuthTokenImplFromJson(Map<String, dynamic> json) =>
    _$QPayAuthTokenImpl(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      refreshExpiresIn: (json['refresh_expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$$QPayAuthTokenImplToJson(_$QPayAuthTokenImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
      'refresh_expires_in': instance.refreshExpiresIn,
    };

_$QPayPaymentCheckImpl _$$QPayPaymentCheckImplFromJson(
        Map<String, dynamic> json) =>
    _$QPayPaymentCheckImpl(
      invoiceId: json['invoice_id'] as String,
      paymentId: json['payment_id'] as String?,
      paymentStatus: json['payment_status'] as String,
      paymentDate: json['payment_date'] == null
          ? null
          : DateTime.parse(json['payment_date'] as String),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QPayPaymentCheckImplToJson(
        _$QPayPaymentCheckImpl instance) =>
    <String, dynamic>{
      'invoice_id': instance.invoiceId,
      'payment_id': instance.paymentId,
      'payment_status': instance.paymentStatus,
      'payment_date': instance.paymentDate?.toIso8601String(),
      'amount': instance.amount,
    };
