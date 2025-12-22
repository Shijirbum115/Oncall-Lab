import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/core/di/service_locator.dart';
import 'package:oncall_lab/data/models/payment_model.dart';
import 'package:oncall_lab/stores/payment_store.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Widget to display QPAY payment options
///
/// This widget shows:
/// - QR code for scanning with mobile banking apps
/// - Direct payment links for various banks
/// - Payment status checking
class QPayPaymentWidget extends StatefulWidget {
  final String userId;
  final int amountMnt;
  final String description;
  final String? testRequestId;
  final VoidCallback? onPaymentSuccess;

  const QPayPaymentWidget({
    super.key,
    required this.userId,
    required this.amountMnt,
    required this.description,
    this.testRequestId,
    this.onPaymentSuccess,
  });

  @override
  State<QPayPaymentWidget> createState() => _QPayPaymentWidgetState();
}

class _QPayPaymentWidgetState extends State<QPayPaymentWidget> {
  final PaymentStore _paymentStore = locator<PaymentStore>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    await _paymentStore.createQPayPayment(
      userId: widget.userId,
      amountMnt: widget.amountMnt,
      description: widget.description,
      testRequestId: widget.testRequestId,
    );
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (_paymentStore.currentPayment != null) {
      final isPaid = await _paymentStore.checkPaymentStatus(
        _paymentStore.currentPayment!.id,
      );

      if (isPaid && widget.onPaymentSuccess != null) {
        widget.onPaymentSuccess!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (_paymentStore.isLoading && !_isInitialized) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_paymentStore.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Алдаа гарлаа',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _paymentStore.errorMessage!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _initializePayment,
                  child: const Text('Дахин оролдох'),
                ),
              ],
            ),
          );
        }

        final payment = _paymentStore.currentPayment;
        final invoice = _paymentStore.currentInvoice;

        if (payment == null || invoice == null) {
          return const Center(
            child: Text('Төлбөрийн мэдээлэл олдсонгүй'),
          );
        }

        if (payment.status == PaymentStatus.paid) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Төлбөр амжилттай төлөгдлөө!',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${payment.amountMnt.toStringAsFixed(0)}₮',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount display
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Төлөх дүн',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.amountMnt.toStringAsFixed(0)}₮',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // QR Code
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'QR кодоор төлөх',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: QrImageView(
                          data: invoice.qrText,
                          version: QrVersions.auto,
                          size: 200,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Банкны апп-аараа уншуулна уу',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Payment URLs (bank apps)
              Text(
                'Эсвэл банкны апп-аар төлөх',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              ...invoice.urls.map((url) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: url.logo.isNotEmpty
                      ? Image.network(
                          url.logo,
                          width: 32,
                          height: 32,
                          errorBuilder: (_, __, ___) => const Icon(Icons.account_balance),
                        )
                      : const Icon(Icons.account_balance),
                  title: Text(url.name),
                  subtitle: Text(url.description),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Launch URL - requires url_launcher package
                    // You can implement this using url_launcher
                  },
                ),
              )),

              const SizedBox(height: 24),

              // Check payment status button
              ElevatedButton.icon(
                onPressed: _paymentStore.isLoading ? null : _checkPaymentStatus,
                icon: _paymentStore.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                label: const Text('Төлбөрийн төлөв шалгах'),
              ),

              const SizedBox(height: 12),

              // Cancel button
              TextButton(
                onPressed: () async {
                  await _paymentStore.cancelPayment(payment.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Цуцлах'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _paymentStore.clearCurrentPayment();
    super.dispose();
  }
}
