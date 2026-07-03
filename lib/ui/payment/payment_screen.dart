import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/core/utils/auth_context.dart';
import 'package:bugamed/data/repositories/test_request_repository.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/payment/qpay_invoice_screen.dart';

class PaymentScreen extends StatefulWidget {
  final int amountMnt;
  final String serviceName;
  final String? laboratoryName;
  final Map<String, dynamic> bookingData;

  const PaymentScreen({
    super.key,
    required this.amountMnt,
    required this.serviceName,
    this.laboratoryName,
    required this.bookingData,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TestRequestRepository _testRequestRepository = TestRequestRepository();

  bool isProcessing = false;
  String? _userId;
  String? _testRequestId;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _userId = authStore.currentUser?.id;
    }
  }

  Future<void> _showLoginRequiredDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Force user to click the button
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Iconsax.lock, color: AppColors.primary, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text('Нэвтрэх шаардлагатай', style: AppTypography.h3),
          ],
        ),
        content: Text(
          'Төлбөр төлөхийн тулд эхлээд системд нэвтэрнэ үү.',
          style: AppTypography.bodyLg,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.surface,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            ),
            child: const Text('Нэвтрэх'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      // Navigate to login with auth context
      final authenticated = await AuthContext.requireAuth(
        context,
        reason: 'make a payment',
      );

      // If authenticated, update userId and continue with payment
      if (authenticated && mounted) {
        setState(() {
          _userId = authStore.currentUser?.id;
        });
      }
    }
  }

  Future<void> _processPayment() async {
    if (!authStore.isAuthenticated) {
      await _showLoginRequiredDialog();

      if (!mounted) return;

      if (!authStore.isAuthenticated) {
        return; // User cancelled login
      }

      _userId = authStore.currentUser?.id;
    }

    // Verify we have userId
    if (_userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Хэрэглэгчийн мэдээлэл олдсонгүй. Дахин нэвтэрнэ үү.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => isProcessing = true);

    try {
      final requestId = await _ensureTestRequestId();
      if (requestId == null || !mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QpayInvoiceScreen(
            testRequestId: requestId,
            amountMnt: widget.amountMnt,
            serviceName: widget.serviceName,
            laboratoryName: widget.laboratoryName,
            bookingData: widget.bookingData,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Төлбөр эхлүүлэхэд алдаа гарлаа: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  Future<String?> _ensureTestRequestId() async {
    if (_testRequestId != null) return _testRequestId;

    final data = widget.bookingData;

    try {
      if (data['laboratoryId'] != null) {
        final created = await _testRequestRepository.createLabServiceRequest(
          patientId: _userId!,
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
        _testRequestId = created.id;
        return _testRequestId;
      }

      final created = await _testRequestRepository.createDirectServiceRequest(
        patientId: _userId!,
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

      _testRequestId = created.id;
      return _testRequestId;
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
        title: Text(l10n.payment),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppPadding.screenAll,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.lg),

                    // Mascot with payment theme
                    Image.asset(
                      'assets/images/mascot/deer_verified_doctor.jpeg',
                      height: 180,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Service Details Card
                    AppCard(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.06),
                      borderColor: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: AppRadius.md,
                      elevation: AppCardElevation.none,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.orderSummary,
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Service name
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.xs),
                                ),
                                child: const Icon(
                                  Iconsax.health,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.serviceName,
                                      style: AppTypography.bodyLg.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (widget.laboratoryName != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.laboratoryName!,
                                        style: AppTypography.bodySm,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.lg),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: AppSpacing.lg),

                          // Total Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.totalAmount,
                                style: AppTypography.bodyLg.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                l10n.priceInMNT(widget.amountMnt),
                                style: AppTypography.h2.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Payment Info
                    AppCard(
                      backgroundColor: AppColors.success.withValues(alpha: 0.06),
                      borderColor: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: AppRadius.sm,
                      elevation: AppCardElevation.none,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.wallet_check,
                            color: AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              '"Төлбөр төлөх" дээр дармагц QPay банкны апп-уудын жагсаалт гарч ирнэ. Аппаа сонгоод шууд төлбөрөө хийнэ үү.',
                              style: AppTypography.body.copyWith(
                                color: AppColors.inkMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Payment Button
            Container(
              padding: AppPadding.screenAll,
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.resting,
              ),
              child: SafeArea(
                child: AppButton(
                  label: l10n.payNow,
                  icon: Iconsax.wallet_3,
                  loading: isProcessing,
                  onPressed: isProcessing ? null : _processPayment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
