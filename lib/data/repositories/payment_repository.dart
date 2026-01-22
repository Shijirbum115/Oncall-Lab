import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/payment_model.dart';

/// Repository for payment-related database operations
class PaymentRepository {
  /// Create a new payment record
  Future<PaymentModel> createPayment({
    required String patientId,
    required String testRequestId,
    required int amountMnt,
    required PaymentMethod paymentMethod,
    String? qpayInvoiceId,
    String? qpayQrText,
    Map<String, dynamic>? qpayUrls,
    Map<String, dynamic>? metadata,
  }) async {
    final data = await supabase.from('payments').insert({
      'patient_id': patientId,
      'test_request_id': testRequestId,
      'amount_mnt': amountMnt,
      'payment_method': paymentMethod.dbValue,
      'payment_status': PaymentStatus.pending.dbValue,
      'qpay_invoice_id': qpayInvoiceId,
      'qpay_qr_text': qpayQrText,
      'qpay_urls': qpayUrls,
      'metadata': metadata,
    }).select().single();

    return PaymentModel.fromJson(data);
  }

  /// Update payment status
  Future<PaymentModel> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus status,
    String? transactionId,
    String? transactionReference,
  }) async {
    final updateData = {
      'payment_status': status.dbValue,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (transactionId != null) {
      updateData['transaction_id'] = transactionId;
    }

    if (transactionReference != null) {
      updateData['transaction_reference'] = transactionReference;
    }

    if (status == PaymentStatus.completed) {
      updateData['paid_at'] = DateTime.now().toIso8601String();
    } else if (status == PaymentStatus.failed) {
      updateData['failed_at'] = DateTime.now().toIso8601String();
    } else if (status == PaymentStatus.cancelled) {
      updateData['cancelled_at'] = DateTime.now().toIso8601String();
    } else if (status == PaymentStatus.refunded) {
      updateData['refunded_at'] = DateTime.now().toIso8601String();
    }

    final data = await supabase
        .from('payments')
        .update(updateData)
        .eq('id', paymentId)
        .select()
        .single();

    return PaymentModel.fromJson(data);
  }

  /// Complete a payment (using database function)
  Future<bool> completePayment({
    required String paymentId,
    String? transactionId,
    String? transactionReference,
  }) async {
    final result = await supabase.rpc('complete_payment', params: {
      'p_payment_id': paymentId,
      'p_transaction_id': transactionId,
      'p_transaction_reference': transactionReference,
    });

    return result as bool;
  }

  /// Fail a payment (using database function)
  Future<bool> failPayment({
    required String paymentId,
    String? failureReason,
  }) async {
    final result = await supabase.rpc('fail_payment', params: {
      'p_payment_id': paymentId,
      'p_failure_reason': failureReason,
    });

    return result as bool;
  }

  /// Cancel a payment (using database function)
  Future<bool> cancelPayment({
    required String paymentId,
    String? cancellationReason,
  }) async {
    final result = await supabase.rpc('cancel_payment', params: {
      'p_payment_id': paymentId,
      'p_cancellation_reason': cancellationReason,
    });

    return result as bool;
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

  /// Get all payments for a user (using database function)
  Future<List<PaymentModel>> getUserPayments(String patientId,
      {int limit = 50, int offset = 0}) async {
    final data = await supabase.rpc('get_user_payment_history', params: {
      'p_patient_id': patientId,
      'p_limit': limit,
      'p_offset': offset,
    });

    return (data as List).map((json) => PaymentModel.fromJson(json)).toList();
  }

  /// Get pending payments for a user
  Future<List<PaymentModel>> getPendingPayments(String patientId) async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('patient_id', patientId)
        .eq('payment_status', PaymentStatus.pending.dbValue)
        .order('created_at', ascending: false);

    return (data as List).map((json) => PaymentModel.fromJson(json)).toList();
  }

  /// Delete a payment (admin only - use with caution)
  Future<void> deletePayment(String paymentId) async {
    await supabase.from('payments').delete().eq('id', paymentId);
  }
}
