import 'package:mobx/mobx.dart';
import 'package:bugamed/data/models/payment_model.dart';
import 'package:bugamed/data/repositories/payment_repository.dart';

part 'payment_store.g.dart';

class PaymentStore = _PaymentStore with _$PaymentStore;

abstract class _PaymentStore with Store {
  final PaymentRepository _paymentRepository;

  _PaymentStore(this._paymentRepository);

  @observable
  PaymentModel? currentPayment;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<PaymentModel> userPayments = ObservableList<PaymentModel>();

  @action
  Future<bool> refreshPaymentStatus(String paymentId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final payment = await _paymentRepository.getPaymentById(paymentId);
      if (payment == null) {
        errorMessage = 'Payment not found';
        return false;
      }
      currentPayment = payment;
      return payment.paymentStatus == PaymentStatus.completed;
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
      final success = await _paymentRepository.cancelPayment(
        paymentId: paymentId,
        cancellationReason: 'User cancelled',
      );

      if (success) {
        currentPayment = await _paymentRepository.getPaymentById(paymentId);
      }

      return success;
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
    errorMessage = null;
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
