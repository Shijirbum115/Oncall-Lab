// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PaymentStore on _PaymentStore, Store {
  late final _$currentPaymentAtom =
      Atom(name: '_PaymentStore.currentPayment', context: context);

  @override
  PaymentModel? get currentPayment {
    _$currentPaymentAtom.reportRead();
    return super.currentPayment;
  }

  @override
  set currentPayment(PaymentModel? value) {
    _$currentPaymentAtom.reportWrite(value, super.currentPayment, () {
      super.currentPayment = value;
    });
  }

  late final _$currentInvoiceAtom =
      Atom(name: '_PaymentStore.currentInvoice', context: context);

  @override
  QPayInvoice? get currentInvoice {
    _$currentInvoiceAtom.reportRead();
    return super.currentInvoice;
  }

  @override
  set currentInvoice(QPayInvoice? value) {
    _$currentInvoiceAtom.reportWrite(value, super.currentInvoice, () {
      super.currentInvoice = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_PaymentStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_PaymentStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$userPaymentsAtom =
      Atom(name: '_PaymentStore.userPayments', context: context);

  @override
  ObservableList<PaymentModel> get userPayments {
    _$userPaymentsAtom.reportRead();
    return super.userPayments;
  }

  @override
  set userPayments(ObservableList<PaymentModel> value) {
    _$userPaymentsAtom.reportWrite(value, super.userPayments, () {
      super.userPayments = value;
    });
  }

  late final _$createQPayPaymentAsyncAction =
      AsyncAction('_PaymentStore.createQPayPayment', context: context);

  @override
  Future<PaymentModel?> createQPayPayment(
      {required String userId,
      required int amountMnt,
      required String description,
      String? testRequestId}) {
    return _$createQPayPaymentAsyncAction.run(() => super.createQPayPayment(
        userId: userId,
        amountMnt: amountMnt,
        description: description,
        testRequestId: testRequestId));
  }

  late final _$checkPaymentStatusAsyncAction =
      AsyncAction('_PaymentStore.checkPaymentStatus', context: context);

  @override
  Future<bool> checkPaymentStatus(String paymentId) {
    return _$checkPaymentStatusAsyncAction
        .run(() => super.checkPaymentStatus(paymentId));
  }

  late final _$loadUserPaymentsAsyncAction =
      AsyncAction('_PaymentStore.loadUserPayments', context: context);

  @override
  Future<void> loadUserPayments(String userId) {
    return _$loadUserPaymentsAsyncAction
        .run(() => super.loadUserPayments(userId));
  }

  late final _$loadPendingPaymentsAsyncAction =
      AsyncAction('_PaymentStore.loadPendingPayments', context: context);

  @override
  Future<void> loadPendingPayments(String userId) {
    return _$loadPendingPaymentsAsyncAction
        .run(() => super.loadPendingPayments(userId));
  }

  late final _$cancelPaymentAsyncAction =
      AsyncAction('_PaymentStore.cancelPayment', context: context);

  @override
  Future<bool> cancelPayment(String paymentId) {
    return _$cancelPaymentAsyncAction.run(() => super.cancelPayment(paymentId));
  }

  late final _$getPaymentByTestRequestAsyncAction =
      AsyncAction('_PaymentStore.getPaymentByTestRequest', context: context);

  @override
  Future<PaymentModel?> getPaymentByTestRequest(String testRequestId) {
    return _$getPaymentByTestRequestAsyncAction
        .run(() => super.getPaymentByTestRequest(testRequestId));
  }

  late final _$_PaymentStoreActionController =
      ActionController(name: '_PaymentStore', context: context);

  @override
  void clearCurrentPayment() {
    final _$actionInfo = _$_PaymentStoreActionController.startAction(
        name: '_PaymentStore.clearCurrentPayment');
    try {
      return super.clearCurrentPayment();
    } finally {
      _$_PaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$_PaymentStoreActionController.startAction(
        name: '_PaymentStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_PaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPayment: ${currentPayment},
currentInvoice: ${currentInvoice},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
userPayments: ${userPayments}
    ''';
  }
}
