// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

/// Payment status enum (matches database enum)
enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
  @JsonValue('cancelled')
  cancelled,
}

extension PaymentStatusX on PaymentStatus {
  String get dbValue {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.processing:
        return 'processing';
      case PaymentStatus.completed:
        return 'completed';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
      case PaymentStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Хүлээгдэж байна';
      case PaymentStatus.processing:
        return 'Боловсруулж байна';
      case PaymentStatus.completed:
        return 'Төлсөн';
      case PaymentStatus.failed:
        return 'Амжилтгүй';
      case PaymentStatus.refunded:
        return 'Буцаасан';
      case PaymentStatus.cancelled:
        return 'Цуцлагдсан';
    }
  }
}

/// Payment method enum (matches database enum)
enum PaymentMethod {
  @JsonValue('qpay')
  qpay,
  @JsonValue('cash')
  cash,
  @JsonValue('card')
  card,
  @JsonValue('bank_transfer')
  bankTransfer,
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
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
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
      case PaymentMethod.bankTransfer:
        return 'Банкны шилжүүлэг';
    }
  }
}

/// Payment model for storing payment information in Supabase
@freezed
class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'test_request_id') required String testRequestId,
    @JsonKey(name: 'amount_mnt') required int amountMnt,
    @JsonKey(name: 'payment_method') required PaymentMethod paymentMethod,
    @JsonKey(name: 'payment_status') required PaymentStatus paymentStatus,

    // QPay specific fields
    @JsonKey(name: 'qpay_invoice_id') String? qpayInvoiceId,
    @JsonKey(name: 'qpay_qr_text') String? qpayQrText,
    @JsonKey(name: 'qpay_urls') Map<String, dynamic>? qpayUrls,

    // Transaction tracking
    @JsonKey(name: 'transaction_id') String? transactionId,
    @JsonKey(name: 'transaction_reference') String? transactionReference,

    // Timestamps
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'failed_at') DateTime? failedAt,
    @JsonKey(name: 'refunded_at') DateTime? refundedAt,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,

    // Reasons
    @JsonKey(name: 'failure_reason') String? failureReason,
    @JsonKey(name: 'refund_reason') String? refundReason,
    @JsonKey(name: 'cancellation_reason') String? cancellationReason,

    // Metadata
    Map<String, dynamic>? metadata,

    // Audit fields
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}
