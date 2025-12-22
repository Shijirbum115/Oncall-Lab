import 'package:mobx/mobx.dart';
import 'package:oncall_lab/core/services/qpay_service.dart';
import 'package:oncall_lab/data/models/payment_model.dart';
import 'package:oncall_lab/data/repositories/payment_repository.dart';

part 'payment_store.g.dart';

class PaymentStore = _PaymentStore with _$PaymentStore;

abstract class _PaymentStore with Store {
  final QPayService _qpayService;
  final PaymentRepository _paymentRepository;

  _PaymentStore(this._qpayService, this._paymentRepository);

  @observable
  PaymentModel? currentPayment;

  @observable
  QPayInvoice? currentInvoice;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<PaymentModel> userPayments = ObservableList<PaymentModel>();

  @action
  Future<PaymentModel?> createQPayPayment({
    required String userId,
    required int amountMnt,
    required String description,
    String? testRequestId,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      // Create QPAY invoice
      final invoice = await _qpayService.createInvoice(
        amountMnt: amountMnt,
        description: description,
      );

      currentInvoice = invoice;

      // Create payment record in database
      final payment = await _paymentRepository.createPayment(
        userId: userId,
        amountMnt: amountMnt,
        paymentMethod: PaymentMethod.qpay,
        testRequestId: testRequestId,
        description: description,
        qpayInvoiceId: invoice.invoiceId,
        qpayQrText: invoice.qrText,
        qpayQrImage: invoice.qrImage,
        qpayUrls: invoice.urls.map((url) => url.link).toList(),
      );

      currentPayment = payment;
      return payment;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> checkPaymentStatus(String paymentId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final payment = await _paymentRepository.getPaymentById(paymentId);
      if (payment == null) {
        errorMessage = 'Payment not found';
        return false;
      }

      if (payment.qpayInvoiceId == null) {
        errorMessage = 'No QPAY invoice ID found';
        return false;
      }

      // Check payment status with QPAY
      final paymentCheck = await _qpayService.checkPayment(
        payment.qpayInvoiceId!,
      );

      // Update payment status based on QPAY response
      if (paymentCheck.paymentStatus == 'PAID') {
        final updatedPayment = await _paymentRepository.updatePaymentStatus(
          paymentId: paymentId,
          status: PaymentStatus.paid,
          qpayPaymentId: paymentCheck.paymentId,
        );
        currentPayment = updatedPayment;
        return true;
      }

      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadUserPayments(String userId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final payments = await _paymentRepository.getUserPayments(userId);
      userPayments = ObservableList.of(payments);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadPendingPayments(String userId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final payments = await _paymentRepository.getPendingPayments(userId);
      userPayments = ObservableList.of(payments);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> cancelPayment(String paymentId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final payment = await _paymentRepository.getPaymentById(paymentId);
      if (payment == null) {
        errorMessage = 'Payment not found';
        return false;
      }

      // Cancel QPAY invoice if exists
      if (payment.qpayInvoiceId != null) {
        await _qpayService.cancelInvoice(payment.qpayInvoiceId!);
      }

      // Update payment status in database
      final updatedPayment = await _paymentRepository.cancelPayment(paymentId);
      currentPayment = updatedPayment;

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<PaymentModel?> getPaymentByTestRequest(String testRequestId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final payment = await _paymentRepository.getPaymentByTestRequestId(
        testRequestId,
      );
      if (payment != null) {
        currentPayment = payment;
      }
      return payment;
    } catch (e) {
      errorMessage = e.toString();
      return null;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearCurrentPayment() {
    currentPayment = null;
    currentInvoice = null;
    errorMessage = null;
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
