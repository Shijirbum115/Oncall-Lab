import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/patient/widgets/qpay_payment_widget.dart';
import 'package:bugamed/ui/payment/payment_success_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String userId;
  final int amountMnt;
  final String serviceName;
  final String? laboratoryName;
  final Map<String, dynamic> bookingData;
  final String? testRequestId;

  const PaymentMethodScreen({
    super.key,
    required this.userId,
    required this.amountMnt,
    required this.serviceName,
    this.laboratoryName,
    required this.bookingData,
    this.testRequestId,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedMethod;
  bool isProcessing = false;

  void _onQPaySelected() async {
    setState(() {
      selectedMethod = 'qpay';
      isProcessing = true;
    });

    // Show QPay payment widget in bottom sheet
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: QPayPaymentWidget(
          userId: widget.userId,
          amountMnt: widget.amountMnt,
          description: widget.serviceName,
          testRequestId: widget.testRequestId,
          onPaymentSuccess: () {
            // Close payment widget
            Navigator.pop(context);
            
            // Navigate to success screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(
                  amountMnt: widget.amountMnt,
                  serviceName: widget.serviceName,
                  laboratoryName: widget.laboratoryName,
                  bookingData: widget.bookingData,
                ),
              ),
            );
          },
        ),
      ),
    );

    setState(() => isProcessing = false);
  }

  void _onBankTransferSelected() {
    setState(() => selectedMethod = 'bank');
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label хуулагдлаа'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: isProcessing ? null : () => Navigator.pop(context),
        ),
        title: Text(
          'Төлбөрийн арга сонгох',
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Summary
              Container(
                width: double.infinity,
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
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Нийт төлөх дүн',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.priceInMNT(widget.amountMnt),
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
              ),

              const SizedBox(height: 32),

              Text(
                'Төлбөрийн арга сонгоно уу',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 16),

              // QPay Option
              GestureDetector(
                onTap: isProcessing ? null : _onQPaySelected,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selectedMethod == 'qpay'
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedMethod == 'qpay'
                          ? AppColors.primary
                          : AppColors.grey.withValues(alpha: 0.3),
                      width: selectedMethod == 'qpay' ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.scan_barcode,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'QPay',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'QR код уншуулж төлөх',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.grey.withValues(alpha: 0.5),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Bank Transfer Option
              GestureDetector(
                onTap: isProcessing ? null : _onBankTransferSelected,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: selectedMethod == 'bank'
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedMethod == 'bank'
                          ? AppColors.primary
                          : AppColors.grey.withValues(alpha: 0.3),
                      width: selectedMethod == 'bank' ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Iconsax.bank,
                          color: AppColors.success,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Дансаар шилжүүлэх',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Банкны дансруу шууд шилжүүлэг',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.grey.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        selectedMethod == 'bank'
                            ? Icons.keyboard_arrow_up
                            : Icons.arrow_forward_ios,
                        color: AppColors.grey.withValues(alpha: 0.5),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              // Bank Transfer Details (shown when selected)
              if (selectedMethod == 'bank') ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Iconsax.info_circle,
                            color: AppColors.success,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Дансны мэдээлэл',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bank Name
                      _buildInfoRow(
                        'Банк:',
                        'Хаан Банк',
                        copyable: false,
                      ),
                      const SizedBox(height: 12),

                      // Account Number
                      _buildInfoRow(
                        'Дансны дугаар:',
                        '5123456789',
                        copyable: true,
                      ),
                      const SizedBox(height: 12),

                      // Account Name
                      _buildInfoRow(
                        'Данс эзэмшигч:',
                        'OnCall Lab ХХК',
                        copyable: false,
                      ),
                      const SizedBox(height: 12),

                      // Reference
                      _buildInfoRow(
                        'Гүйлгээний утга:',
                        'USER_${widget.userId.substring(0, 8)}_${widget.amountMnt}',
                        copyable: true,
                      ),

                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.warning_2,
                              color: AppColors.warning,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Гүйлгээний утга заавал оруулна уу. Энэ нь таны төлбөрийг баталгаажуулахад шаардлагатай.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to success screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentSuccessScreen(
                                  amountMnt: widget.amountMnt,
                                  serviceName: widget.serviceName,
                                  laboratoryName: widget.laboratoryName,
                                  bookingData: widget.bookingData,
                                  isPendingBankTransfer: true,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Шилжүүлсэн',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool copyable = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _copyToClipboard(value, label),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Iconsax.copy,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
