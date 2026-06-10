import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/data/models/laboratory_service_model.dart';
import 'package:bugamed/data/models/service_model_extensions.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/patient/location/location_picker_screen.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/auth/widgets/step_progress_bar.dart';
import 'package:bugamed/core/utils/notification_helper.dart';
import 'package:bugamed/ui/payment/payment_screen.dart';

class LabServiceBookingScreen extends StatefulWidget {
  final Map<String, dynamic> laboratory;
  final LaboratoryServiceModel laboratoryService;

  const LabServiceBookingScreen({
    super.key,
    required this.laboratory,
    required this.laboratoryService,
  });

  @override
  State<LabServiceBookingScreen> createState() =>
      _LabServiceBookingScreenState();
}

class _LabServiceBookingScreenState extends State<LabServiceBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTimeSlot = '09:00-12:00';
  bool isSubmitting = false;
  String? savedAddress;
  bool useSavedAddress = false;
  bool showManualAddressField = false;

  // Location data from picker
  Map<String, dynamic>? selectedLocation;

  final List<String> timeSlots = [
    '09:00-12:00',
    '12:00-15:00',
    '15:00-18:00',
    '18:00-21:00',
  ];

  @override
  void initState() {
    super.initState();
    final addr = authStore.currentProfile?.permanentAddress;
    if (addr != null && addr.isNotEmpty) {
      savedAddress = addr;
      useSavedAddress = true;
      showManualAddressField = false;
      _addressController.text = addr;
    } else {
      useSavedAddress = false;
      showManualAddressField = true;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      CupertinoPageRoute(
        builder: (_) => LocationPickerScreen(
          initialLocation: selectedLocation != null
              ? LatLng(
                  selectedLocation!['latitude'],
                  selectedLocation!['longitude'],
                )
              : null,
          initialAddress: selectedLocation?['address_line'],
        ),
      ),
    );

    if (result != null && mounted) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        selectedLocation = result;
        useSavedAddress = false;
        showManualAddressField = false;

        // Build full address string (labels follow the app locale)
        final parts = <String>[result['address_line']];
        if (result['building_name']?.isNotEmpty == true) {
          parts.add(result['building_name']);
        }
        if (result['entrance']?.isNotEmpty == true) {
          parts.add(l10n.entranceLabel(result['entrance']));
        }
        if (result['floor']?.isNotEmpty == true) {
          parts.add(l10n.floorLabel(result['floor']));
        }
        if (result['apartment_number']?.isNotEmpty == true) {
          parts.add(l10n.apartmentLabel(result['apartment_number']));
        }
        if (result['door_number']?.isNotEmpty == true) {
          parts.add(l10n.doorLabel(result['door_number']));
        }

        _addressController.text = parts.join(', ');
      });
    }
  }

  /// FreshPack-style last-mile check: the address is the most expensive
  /// thing to get wrong in a home-visit service, so confirm it explicitly.
  Future<bool> _confirmAddress() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                l10n.addressConfirmQuestion,
                style: AppTypography.sectionHeader,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F1F3),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.location,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.collectionAddress,
                            style: AppTypography.labelSmall),
                        const SizedBox(height: 3),
                        Text(
                          _addressController.text,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')} · $selectedTimeSlot',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: l10n.no,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.of(ctx).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: l10n.yes,
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return confirmed == true;
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    // Validate location is selected
    if (selectedLocation == null && _addressController.text.trim().isEmpty) {
      NotificationHelper.showError(context, l10n.pleaseSelectLocationOnMap);
      return;
    }

    if (!await _confirmAddress()) return;
    if (!mounted) return;

    setState(() => isSubmitting = true);

    try {
      // Prepare booking data
      final bookingData = {
        'laboratoryId': widget.laboratory['id'],
        'laboratoryServiceId': widget.laboratoryService.id,
        'serviceId': widget.laboratoryService.serviceId,
        'scheduledDate': selectedDate.toIso8601String().split('T')[0],
        'scheduledTimeSlot': selectedTimeSlot,
        'patientAddress': _addressController.text.trim(),
        'patientLatitude': selectedLocation?['latitude'],
        'patientLongitude': selectedLocation?['longitude'],
        'patientNotes': _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      };

      if (mounted) {
        // Navigate to payment screen
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PaymentScreen(
              amountMnt: widget.laboratoryService.priceMnt,
              serviceName: widget.laboratoryService.service!.getLocalizedName(context),
              laboratoryName: widget.laboratory['name'],
              bookingData: bookingData,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final service = widget.laboratoryService.service!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.bookService),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Where am I in the journey?
            StepProgressBar(
              totalSteps: 3,
              currentStep: 1,
              icons: const [Iconsax.health, Iconsax.location, Iconsax.card],
              labels: [l10n.service, l10n.address, l10n.payment],
            ),
            const SizedBox(height: 24),

            // Service Info Card
            AppCard(
              shadow: AppShadows.none,
              borderRadius: 18,
              borderColor: AppColors.primary.withValues(alpha: 0.15),
              backgroundColor: AppColors.primary.withValues(alpha: 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.getLocalizedName(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.laboratory['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.priceInMNT(widget.laboratoryService.priceMnt),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (widget.laboratoryService.estimatedDurationHours !=
                          null)
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Text(
                              l10n.resultsReadyHours(
                                widget.laboratoryService
                                    .estimatedDurationHours!,
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Preparation Instructions
            if (service.preparationInstructions != null) ...[
              AppCard(
                shadow: AppShadows.none,
                borderRadius: 18,
                borderColor: AppColors.warning.withValues(alpha: 0.2),
                backgroundColor: AppColors.warning.withValues(alpha: 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.preparationRequired,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.preparationInstructions!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Date Selection
            Text(
              l10n.selectDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              shadow: AppShadows.none,
              borderRadius: 14,
              borderColor: AppColors.grey.withValues(alpha: 0.25),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now().add(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );

                if (date != null) {
                  setState(() => selectedDate = date);
                }
              },
              child: Row(
                children: [
                  const Icon(Iconsax.calendar, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Time Slot Selection
            Text(
              l10n.selectTimeSlot,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: timeSlots.map((slot) {
                final isSelected = selectedTimeSlot == slot;
                return InkWell(
                  onTap: () => setState(() => selectedTimeSlot = slot),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      slot,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Address
            Text(
              l10n.collectionAddress,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Location Picker Button
            AppCard(
              shadow: AppShadows.none,
              borderRadius: 14,
              borderColor: selectedLocation != null
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.grey.withValues(alpha: 0.25),
              backgroundColor: selectedLocation != null
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.white,
              onTap: _openLocationPicker,
              child: Row(
                children: [
                  Icon(
                    Iconsax.location,
                    color: selectedLocation != null
                        ? AppColors.primary
                        : AppColors.grey,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedLocation != null
                          ? _addressController.text
                          : l10n.addressHint,
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedLocation != null
                            ? AppColors.black
                            : AppColors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit_location_alt,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),

            // Show error if no location selected
            if (selectedLocation == null && _addressController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  l10n.pleaseSelectLocationOnMap,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Notes
            Text(
              l10n.additionalNotesOptional,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _notesController,
              maxLines: 3,
              hint: l10n.specialInstructionsHint,
            ),

            const SizedBox(height: 32),

            // Submit Button
            AppButton(
              label: l10n.confirmBooking,
              loading: isSubmitting,
              onPressed: isSubmitting ? null : _submitBooking,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
