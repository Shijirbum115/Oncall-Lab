import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/core/di/service_locator.dart';
import 'package:bugamed/stores/test_request_store.dart';
import 'package:bugamed/stores/auth_store.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final String serviceName;
  final String? laboratoryName;
  final int amountMnt;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingData,
    required this.serviceName,
    this.laboratoryName,
    required this.amountMnt,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final testRequestStore = locator<TestRequestStore>();
  final authStore = locator<AuthStore>();
  bool isCreatingRequest = true;
  bool requestCreated = false;
  String? requestId;

  @override
  void initState() {
    super.initState();
    _createRequest();
  }

  Future<void> _createRequest() async {
    try {
      final userId = authStore.currentUser!.id;
      final data = widget.bookingData;

      // Check if this is a lab service or direct service
      if (data.containsKey('laboratoryId')) {
        // Lab service request
        final request = await testRequestStore.createLabServiceRequest(
          patientId: userId,
          laboratoryId: data['laboratoryId'],
          laboratoryServiceId: data['laboratoryServiceId'],
          serviceId: data['serviceId'],
          scheduledDate: data['scheduledDate'],
          scheduledTimeSlot: data['scheduledTimeSlot'],
          patientAddress: data['patientAddress'],
          priceMnt: widget.amountMnt,
          patientLatitude: data['patientLatitude'],
          patientLongitude: data['patientLongitude'],
          patientNotes: data['patientNotes'],
        );

        if (request != null) {
          setState(() {
            requestCreated = true;
            requestId = request.id;
          });
        }
      } else {
        // Direct service request
        final request = await testRequestStore.createDirectServiceRequest(
          patientId: userId,
          serviceId: data['serviceId'],
          doctorServiceId: data['doctorServiceId'],
          doctorId: data['doctorId'],
          scheduledDate: data['scheduledDate'],
          scheduledTimeSlot: data['scheduledTimeSlot'],
          patientAddress: data['patientAddress'],
          priceMnt: widget.amountMnt,
          patientLatitude: data['patientLatitude'],
          patientLongitude: data['patientLongitude'],
          patientNotes: data['patientNotes'],
        );

        if (request != null) {
          setState(() {
            requestCreated = true;
            requestId = request.id;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error creating request: $e');
    } finally {
      setState(() => isCreatingRequest = false);
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
        automaticallyImplyLeading: false,
        title: Text(
          l10n.bookingConfirmation,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isCreatingRequest
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MascotStateWidget(
                    emotion: MascotEmotion.loading,
                    title: l10n.creatingYourBooking,
                    subtitle: l10n.pleaseWait,
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Success Mascot
                    Center(
                      child: Image.asset(
                        'assets/images/mascot/deer_verified_doctor.jpeg',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Booking ID Card
                    if (requestId != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l10n.bookingID,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              requestId!.substring(0, 8).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Booking Details
                    Text(
                      l10n.bookingDetails,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Service
                    _buildDetailRow(
                      icon: Iconsax.health,
                      label: l10n.service,
                      value: widget.serviceName,
                    ),

                    if (widget.laboratoryName != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        icon: Iconsax.hospital,
                        label: l10n.laboratory,
                        value: widget.laboratoryName!,
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Date
                    _buildDetailRow(
                      icon: Iconsax.calendar,
                      label: l10n.date,
                      value: DateFormat('MMM dd, yyyy').format(
                        DateTime.parse(widget.bookingData['scheduledDate']),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Time
                    _buildDetailRow(
                      icon: Iconsax.clock,
                      label: l10n.time,
                      value: widget.bookingData['scheduledTimeSlot'],
                    ),

                    const SizedBox(height: 12),

                    // Address
                    _buildDetailRow(
                      icon: Iconsax.location,
                      label: l10n.address,
                      value: widget.bookingData['patientAddress'],
                    ),

                    const SizedBox(height: 12),

                    // Amount
                    _buildDetailRow(
                      icon: Iconsax.wallet,
                      label: l10n.amount,
                      value: l10n.priceInMNT(widget.amountMnt),
                      valueColor: AppColors.success,
                    ),

                    const SizedBox(height: 32),

                    // Status Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.info_circle,
                            color: AppColors.info,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.doctorWillAcceptSoon,
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

                    const SizedBox(height: 32),

                    // Back to Home Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
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
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
