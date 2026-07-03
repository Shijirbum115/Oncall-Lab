import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/data/repositories/test_request_repository.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/payment/payment_success_screen.dart';
import 'package:bugamed/ui/payment/qpay_invoice_screen.dart';

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
  String selectedMethod = 'bank';
  bool isProcessing = false;
  bool _isPreparingQpay = false;

  Future<String?> _ensureTestRequestId() async {
    if (widget.testRequestId != null) return widget.testRequestId;

    final data = widget.bookingData;
    final repo = TestRequestRepository();
    try {
      if (data['laboratoryId'] != null) {
        final created = await repo.createLabServiceRequest(
          patientId: widget.userId,
          laboratoryId: data['laboratoryId'] as String,
          laboratoryServiceId: data['laboratoryServiceId'] as String,
          serviceId: data['serviceId'] as String,
          scheduledDate: data['scheduledDate'] as String,
          scheduledTimeSlot: data['scheduledTimeSlot'] as String,
          patientAddress: data['patientAddress'] as String? ?? '',
          priceMnt: widget.amountMnt,
          patientLatitude: (data['patientLatitude'] as num?)?.toDouble(),
          patientLongitude: (data['patientLongitude'] as num?)?.toDouble(),
          patientNotes: data['patientNotes'] as String?,
        );
        return created.id;
      }
      final created = await repo.createDirectServiceRequest(
        patientId: widget.userId,
        serviceId: data['serviceId'] as String,
        scheduledDate: data['scheduledDate'] as String,
        scheduledTimeSlot: data['scheduledTimeSlot'] as String,
        patientAddress: data['patientAddress'] as String? ?? '',
        priceMnt: widget.amountMnt,
        doctorId: data['doctorId'] as String?,
        doctorServiceId: data['doctorServiceId'] as String?,
        patientLatitude: (data['patientLatitude'] as num?)?.toDouble(),
        patientLongitude: (data['patientLongitude'] as num?)?.toDouble(),
        patientNotes: data['patientNotes'] as String?,
      );
      return created.id;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Захиалга үүсгэхэд алдаа гарлаа: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    }
  }

  Future<void> _startQpayFlow() async {
    if (_isPreparingQpay) return;
    setState(() => _isPreparingQpay = true);
    try {
      final requestId = await _ensureTestRequestId();
      if (requestId == null || !mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QpayInvoiceScreen(
            testRequestId: requestId,
            amountMnt: widget.amountMnt,
            serviceName: widget.serviceName,
            laboratoryName: widget.laboratoryName,
            bookingData: widget.bookingData,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isPreparingQpay = false);
    }
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: isProcessing ? null : () => Navigator.pop(context),
        ),
        title: const Text('Төлбөрийн арга сонгох'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.screenAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Нийт төлөх дүн',
                      style: AppTypography.body
                          .copyWith(color: AppColors.inkMuted),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.priceInMNT(widget.amountMnt),
                      style: AppTypography.display.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.serviceName,
                      style: AppTypography.body
                          .copyWith(color: AppColors.inkMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'Төлбөрийн арга сонгоно уу',
                style: AppTypography.bodyLg
                    .copyWith(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: AppSpacing.md),

              // QPay Option
              AppCard(
                onTap: _isPreparingQpay ? null : _startQpayFlow,
                borderColor: AppColors.primary.withValues(alpha: 0.3),
                borderRadius: AppRadius.md,
                elevation: AppCardElevation.resting,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Iconsax.scan_barcode,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'QPay (QR код)',
                            style: AppTypography.h3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Бүх банкны апп ба wallet-аар уншуулна',
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                    _isPreparingQpay
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.primary,
                            size: 18,
                          ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Bank Transfer Option
              AppCard(
                onTap: null,
                backgroundColor: selectedMethod == 'bank'
                    ? AppColors.primarySoft
                    : AppColors.surface,
                borderColor: selectedMethod == 'bank'
                    ? AppColors.primary
                    : AppColors.border,
                borderWidth: selectedMethod == 'bank' ? 2 : 1,
                borderRadius: AppRadius.md,
                elevation: AppCardElevation.resting,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: const Icon(
                        Iconsax.bank,
                        color: AppColors.success,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Дансаар шилжүүлэх',
                            style: AppTypography.h3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Банкны дансруу шууд шилжүүлэг',
                            style: AppTypography.bodySm,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      selectedMethod == 'bank'
                          ? Icons.keyboard_arrow_up
                          : Icons.arrow_forward_ios,
                      color: AppColors.inkSubtle,
                      size: 18,
                    ),
                  ],
                ),
              ),

              // Bank Transfer Details (shown when selected)
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                backgroundColor: AppColors.success.withValues(alpha: 0.05),
                borderColor: AppColors.success.withValues(alpha: 0.2),
                borderRadius: AppRadius.md,
                elevation: AppCardElevation.none,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Iconsax.info_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Дансны мэдээлэл',
                          style: AppTypography.bodyLg
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildInfoRow('Банк:', 'Хаан Банк', copyable: false),
                    const SizedBox(height: AppSpacing.sm),
                    _buildInfoRow('Дансны дугаар:', '5123456789',
                        copyable: true),
                    const SizedBox(height: AppSpacing.sm),
                    _buildInfoRow('Данс эзэмшигч:', 'OnCall Lab ХХК',
                        copyable: false),
                    const SizedBox(height: AppSpacing.sm),
                    _buildInfoRow(
                      'Гүйлгээний утга:',
                      'USER_${widget.userId.substring(0, 8)}_${widget.amountMnt}',
                      copyable: true,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.warning_2,
                            color: AppColors.warning,
                            size: 18,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Text(
                              'Гүйлгээний утга заавал оруулна уу. Энэ нь таны төлбөрийг баталгаажуулахад шаардлагатай.',
                              style: AppTypography.bodySm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Шилжүүлсэн',
                      onPressed: () {
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
                    ),
                  ],
                ),
              ),
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
            style: AppTypography.body.copyWith(color: AppColors.inkMuted),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.body
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (copyable) ...[
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: () => _copyToClipboard(value, label),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
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
