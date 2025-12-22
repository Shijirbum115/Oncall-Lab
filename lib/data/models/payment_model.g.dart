// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      testRequestId: json['test_request_id'] as String?,
      amountMnt: (json['amount_mnt'] as num).toInt(),
      paymentMethod:
          $enumDecode(_$PaymentMethodEnumMap, json['payment_method']),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      qpayInvoiceId: json['qpay_invoice_id'] as String?,
      qpayPaymentId: json['qpay_payment_id'] as String?,
      qpayQrText: json['qpay_qr_text'] as String?,
      qpayQrImage: json['qpay_qr_image'] as String?,
      qpayUrls: (json['qpay_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'test_request_id': instance.testRequestId,
      'amount_mnt': instance.amountMnt,
      'payment_method': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'qpay_invoice_id': instance.qpayInvoiceId,
      'qpay_payment_id': instance.qpayPaymentId,
      'qpay_qr_text': instance.qpayQrText,
      'qpay_qr_image': instance.qpayQrImage,
      'qpay_urls': instance.qpayUrls,
      'description': instance.description,
      'paid_at': instance.paidAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.qpay: 'qpay',
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.cancelled: 'cancelled',
  PaymentStatus.refunded: 'refunded',
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
