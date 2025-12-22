// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment status enum
enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('refunded')
  refunded,
}

extension PaymentStatusX on PaymentStatus {
  String get dbValue {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.cancelled:
        return 'cancelled';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Хүлээгдэж байна';
      case PaymentStatus.paid:
        return 'Төлсөн';
      case PaymentStatus.failed:
        return 'Амжилтгүй';
      case PaymentStatus.cancelled:
        return 'Цуцлагдсан';
      case PaymentStatus.refunded:
        return 'Буцаасан';
    }
  }
}

/// Payment method enum
enum PaymentMethod {
  @JsonValue('qpay')
  qpay,
  @JsonValue('cash')
  cash,
  @JsonValue('card')
  card,
}

extension PaymentMethodX on PaymentMethod {
  String get dbValue {
    switch (this) {
      case PaymentMethod.qpay:
        return 'qpay';
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card';
    }
  }

  String get displayName {
    switch (this) {
      case PaymentMethod.qpay:
        return 'QPay';
      case PaymentMethod.cash:
        return 'Бэлэн мөнгө';
      case PaymentMethod.card:
        return 'Карт';
    }
  }
}

/// Payment model for storing payment information in Supabase
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'test_request_id') String? testRequestId,
    @JsonKey(name: 'amount_mnt') required int amountMnt,
    @JsonKey(name: 'payment_method') required PaymentMethod paymentMethod,
    required PaymentStatus status,
    @JsonKey(name: 'qpay_invoice_id') String? qpayInvoiceId,
    @JsonKey(name: 'qpay_payment_id') String? qpayPaymentId,
    @JsonKey(name: 'qpay_qr_text') String? qpayQrText,
    @JsonKey(name: 'qpay_qr_image') String? qpayQrImage,
    @JsonKey(name: 'qpay_urls') List<String>? qpayUrls,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}

/// QPAY Invoice model from QPAY API response
@freezed
class QPayInvoice with _$QPayInvoice {
  const factory QPayInvoice({
    @JsonKey(name: 'invoice_id') required String invoiceId,
    @JsonKey(name: 'qr_text') required String qrText,
    @JsonKey(name: 'qr_image') required String qrImage,
    required List<QPayUrl> urls,
  }) = _QPayInvoice;

  factory QPayInvoice.fromJson(Map<String, dynamic> json) =>
      _$QPayInvoiceFromJson(json);
}

/// QPAY URL model for payment links
@freezed
class QPayUrl with _$QPayUrl {
  const factory QPayUrl({
    required String name,
    required String description,
    required String logo,
    required String link,
  }) = _QPayUrl;

  factory QPayUrl.fromJson(Map<String, dynamic> json) =>
      _$QPayUrlFromJson(json);
}

/// QPAY Auth Token model
@freezed
class QPayAuthToken with _$QPayAuthToken {
  const factory QPayAuthToken({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') required int expiresIn,
    @JsonKey(name: 'refresh_expires_in') required int refreshExpiresIn,
  }) = _QPayAuthToken;

  factory QPayAuthToken.fromJson(Map<String, dynamic> json) =>
      _$QPayAuthTokenFromJson(json);
}

/// QPAY Payment check result
@freezed
class QPayPaymentCheck with _$QPayPaymentCheck {
  const factory QPayPaymentCheck({
    @JsonKey(name: 'invoice_id') required String invoiceId,
    @JsonKey(name: 'payment_id') String? paymentId,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'payment_date') DateTime? paymentDate,
    @JsonKey(name: 'amount') int? amount,
  }) = _QPayPaymentCheck;

  factory QPayPaymentCheck.fromJson(Map<String, dynamic> json) =>
      _$QPayPaymentCheckFromJson(json);
}
