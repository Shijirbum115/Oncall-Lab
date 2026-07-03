import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/data/repositories/qpay_repository.dart';
import 'package:bugamed/ui/payment/payment_success_screen.dart';

class QpayInvoiceScreen extends StatefulWidget {
  final String testRequestId;
  final int amountMnt;
  final String serviceName;
  final String? laboratoryName;
  final Map<String, dynamic> bookingData;

  const QpayInvoiceScreen({
    super.key,
    required this.testRequestId,
    required this.amountMnt,
    required this.serviceName,
    this.laboratoryName,
    required this.bookingData,
  });

  @override
  State<QpayInvoiceScreen> createState() => _QpayInvoiceScreenState();
}

class _QpayInvoiceScreenState extends State<QpayInvoiceScreen> {
  final QpayRepository _repo = QpayRepository();

  QpayInvoice? _invoice;
  String? _loadError;
  bool _isChecking = false;
  StreamSubscription<QpayPaymentStatus>? _statusSubscription;

  @override
  void initState() {
    super.initState();
    _createInvoice();
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _createInvoice() async {
    try {
      final invoice = await _repo.createInvoice(
        testRequestId: widget.testRequestId,
      );
      if (!mounted) return;
      setState(() => _invoice = invoice);
      _subscribeToStatus(invoice.localId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadError = e.toString());
    }
  }

  void _subscribeToStatus(String localId) {
    _statusSubscription = _repo
        .watchInvoiceStatus(localId: localId)
        .listen((status) {
      if (!mounted) return;
      if (status == QpayPaymentStatus.paid) {
        _navigateToSuccess();
      }
    });
  }

  void _navigateToSuccess() {
    _statusSubscription?.cancel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          amountMnt: widget.amountMnt,
          serviceName: widget.serviceName,
          laboratoryName: widget.laboratoryName,
          bookingData: widget.bookingData,
        ),
      ),
    );
  }

  Future<void> _checkPaymentStatus() async {
    final invoice = _invoice;
    if (invoice == null || _isChecking) return;
    setState(() => _isChecking = true);
    try {
      final status = await _repo.checkPayment(localId: invoice.localId);
      if (!mounted) return;
      if (status == QpayPaymentStatus.paid) {
        _navigateToSuccess();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Төлбөр хараахан баталгаажаагүй байна.'),
          backgroundColor: AppColors.warning,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Шалгахад алдаа: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  Future<void> _openDeeplink(String link) async {
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Банкны апп нээгдсэнгүй. Апп суулгасан эсэхээ шалгана уу.'),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'QPay-ээр төлөх',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_loadError != null) {
      return _buildErrorState(_loadError!);
    }
    final invoice = _invoice;
    if (invoice == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildInvoiceView(invoice);
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.warning_2, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text(
            'Нэхэмжлэл үүсгэхэд алдаа гарлаа',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 13, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _loadError = null;
                _invoice = null;
              });
              _createInvoice();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Дахин оролдох'),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceView(QpayInvoice invoice) {
    if (invoice.deeplinks.isEmpty) {
      return _buildErrorState(
        'QPay банкны аппын жагсаалт ачаалж чадсангүй. Дахин оролдоно уу.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAmountCard(),
          const SizedBox(height: 24),
          const Text(
            'Төлбөрийн апп сонгоно уу',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Доорх банк эсвэл wallet апп дээр дарж QPay төлбөрөө үргэлжлүүлнэ үү.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _buildDeeplinkGrid(invoice.deeplinks),
          const SizedBox(height: 24),
          _buildCheckButton(),
          const SizedBox(height: 16),
          _buildInfoBanner(),
        ],
      ),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Төлөх дүн',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            '${_formatAmount(widget.amountMnt)}₮',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.serviceName,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDeeplinkGrid(List<QpayBankDeeplink> deeplinks) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: deeplinks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.15,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final bank = deeplinks[index];
        return InkWell(
          onTap: () => _openDeeplink(bank.link),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.grey.withValues(alpha: 0.25)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (bank.logo.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      bank.logo,
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => const Icon(
                        Iconsax.bank,
                        size: 34,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                else
                  const Icon(Iconsax.bank, size: 34, color: AppColors.primary),
                const SizedBox(height: 10),
                Text(
                  bank.description.isNotEmpty ? bank.description : bank.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isChecking ? null : _checkPaymentStatus,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isChecking
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.refresh, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Төлбөр шалгах',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.2),
        ),
      ),
      child: const Row(
        children: [
          Icon(Iconsax.info_circle, color: AppColors.success, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Төлбөр амжилттай хийгдмэгц энэ дэлгэц өөрөө автоматаар шинэчлэгдэнэ.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
