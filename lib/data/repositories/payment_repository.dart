import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/payment_model.dart';

/// Repository for payment-related database operations
class PaymentRepository {
  /// Create a new payment record
  Future<PaymentModel> createPayment({
    required String userId,
    required int amountMnt,
    required PaymentMethod paymentMethod,
    String? testRequestId,
    String? description,
    String? qpayInvoiceId,
    String? qpayQrText,
    String? qpayQrImage,
    List<String>? qpayUrls,
  }) async {
    final data = await supabase.from('payments').insert({
      'user_id': userId,
      'test_request_id': testRequestId,
      'amount_mnt': amountMnt,
      'payment_method': paymentMethod.dbValue,
      'status': PaymentStatus.pending.dbValue,
      'description': description,
      'qpay_invoice_id': qpayInvoiceId,
      'qpay_qr_text': qpayQrText,
      'qpay_qr_image': qpayQrImage,
      'qpay_urls': qpayUrls,
    }).select().single();

    return PaymentModel.fromJson(data);
  }

  /// Update payment status
  Future<PaymentModel> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus status,
    String? qpayPaymentId,
  }) async {
    final updateData = {
      'status': status.dbValue,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (qpayPaymentId != null) {
      updateData['qpay_payment_id'] = qpayPaymentId;
    }

    if (status == PaymentStatus.paid) {
      updateData['paid_at'] = DateTime.now().toIso8601String();
    }

    final data = await supabase
        .from('payments')
        .update(updateData)
        .eq('id', paymentId)
        .select()
        .single();

    return PaymentModel.fromJson(data);
  }

  /// Get payment by ID
  Future<PaymentModel?> getPaymentById(String paymentId) async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('id', paymentId)
        .maybeSingle();

    if (data == null) return null;
    return PaymentModel.fromJson(data);
  }

  /// Get payment by QPAY invoice ID
  Future<PaymentModel?> getPaymentByQPayInvoiceId(String invoiceId) async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('qpay_invoice_id', invoiceId)
        .maybeSingle();

    if (data == null) return null;
    return PaymentModel.fromJson(data);
  }

  /// Get payment by test request ID
  Future<PaymentModel?> getPaymentByTestRequestId(String testRequestId) async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('test_request_id', testRequestId)
        .maybeSingle();

    if (data == null) return null;
    return PaymentModel.fromJson(data);
  }

  /// Get all payments for a user
  Future<List<PaymentModel>> getUserPayments(String userId) async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => PaymentModel.fromJson(json))
        .toList();
  }

  /// Get pending payments for a user
  Future<List<PaymentModel>> getPendingPayments(String userId) async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('user_id', userId)
        .eq('status', PaymentStatus.pending.dbValue)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => PaymentModel.fromJson(json))
        .toList();
  }

  /// Cancel a payment
  Future<PaymentModel> cancelPayment(String paymentId) async {
    return updatePaymentStatus(
      paymentId: paymentId,
      status: PaymentStatus.cancelled,
    );
  }

  /// Mark payment as failed
  Future<PaymentModel> markPaymentFailed(String paymentId) async {
    return updatePaymentStatus(
      paymentId: paymentId,
      status: PaymentStatus.failed,
    );
  }

  /// Delete a payment (admin only - use with caution)
  Future<void> deletePayment(String paymentId) async {
    await supabase.from('payments').delete().eq('id', paymentId);
  }
}
