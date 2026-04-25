import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/patient/booking_confirmation_screen.dart';
import 'package:animate_do/animate_do.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final int amountMnt;
  final String serviceName;
  final String? laboratoryName;
  final Map<String, dynamic> bookingData;
  final bool isPendingBankTransfer;

  const PaymentSuccessScreen({
    super.key,
    required this.amountMnt,
    required this.serviceName,
    this.laboratoryName,
    required this.bookingData,
    this.isPendingBankTransfer = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  48,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

              // Success Animation
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 80,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Mascot Happy
              FadeIn(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 600),
                child: Image.asset(
                  'assets/images/mascot/deer_happy.jpeg',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 32),

              // Success Title
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  isPendingBankTransfer 
                    ? 'Төлбөрийн мэдээлэл илгээгдлээ' 
                    : l10n.paymentSuccessful,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  isPendingBankTransfer
                    ? 'Таны төлбөр баталгаажсаны дараа захиалга идэвхжинэ.'
                    : l10n.bookingConfirmed,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Payment Details Card
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.amountPaid,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          Text(
                            l10n.priceInMNT(amountMnt),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.service,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              serviceName,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (laboratoryName != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.laboratory,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                            Text(
                              laboratoryName!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    // View Booking Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingConfirmationScreen(
                                bookingData: bookingData,
                                serviceName: serviceName,
                                laboratoryName: laboratoryName,
                                amountMnt: amountMnt,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.viewBookingDetails,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Back to Home Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.backToHome,
                          style: const TextStyle(
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
            ),
          ),
        ),
      ),
    );
  }
}
