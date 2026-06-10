import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/utils/auth_context.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/core/utils/notification_helper.dart';
import 'package:bugamed/ui/payment/payment_method_screen.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Iconsax.lock, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.signInToContinue)),
          ],
        ),
        content: Text(l10n.signInPromptBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.signIn),
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
        NotificationHelper.showError(
          context,
          AppLocalizations.of(context)!.sessionExpired,
        );
      }
      return;
    }

    setState(() => isProcessing = true);

    // Navigate to payment method selection screen
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PaymentMethodScreen(
          userId: _userId!,
          amountMnt: widget.amountMnt,
          serviceName: widget.serviceName,
          laboratoryName: widget.laboratoryName,
          bookingData: widget.bookingData,
          testRequestId: _testRequestId,
        ),
      ),
    );

    if (mounted) {
      setState(() => isProcessing = false);
    }
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
          l10n.payment,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Mascot with payment theme
                    Image.asset(
                      'assets/images/mascot/deer_verified_doctor.jpeg',
                      height: 180,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 32),

                    // Service Details Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.orderSummary,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Service name
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Iconsax.health,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.serviceName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    if (widget.laboratoryName != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.laboratoryName!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),

                          // Total Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.totalAmount,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                l10n.priceInMNT(widget.amountMnt),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Payment Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.wallet_check,
                            color: AppColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Одоогоор дансаар шилжүүлгийн төлбөрийн горим ажиллаж байна. Доорх алхмаар шилжүүлгээ хийнэ үү.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.4,
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.wallet_3, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                l10n.payNow,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
