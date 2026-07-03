import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/data/models/laboratory_service_model.dart';
import 'package:bugamed/data/models/service_model_extensions.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/patient/location/location_picker_screen.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
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
      MaterialPageRoute(
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

    if (result != null) {
      setState(() {
        selectedLocation = result;
        useSavedAddress = false;
        showManualAddressField = false;

        // Build full address string
        final parts = <String>[result['address_line']];
        if (result['building_name']?.isNotEmpty == true) {
          parts.add(result['building_name']);
        }
        if (result['entrance']?.isNotEmpty == true) {
          parts.add('Entrance: ${result['entrance']}');
        }
        if (result['floor']?.isNotEmpty == true) {
          parts.add('Floor: ${result['floor']}');
        }
        if (result['apartment_number']?.isNotEmpty == true) {
          parts.add('Apt: ${result['apartment_number']}');
        }
        if (result['door_number']?.isNotEmpty == true) {
          parts.add('Door: ${result['door_number']}');
        }

        _addressController.text = parts.join(', ');
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate location is selected
    if (selectedLocation == null && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your location on the map'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

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
          MaterialPageRoute(
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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.bookService),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Service Info Card
            AppCard(
              elevation: AppCardElevation.none,
              borderRadius: AppRadius.md,
              borderColor: AppColors.primary.withValues(alpha: 0.15),
              backgroundColor: AppColors.primary.withValues(alpha: 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.getLocalizedName(context),
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.laboratory['name'],
                    style: AppTypography.body.copyWith(
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Text(
                          l10n.priceInMNT(widget.laboratoryService.priceMnt),
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (widget.laboratoryService.estimatedDurationHours !=
                          null)
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: AppColors.inkSubtle),
                            const SizedBox(width: 4),
                            Text(
                              l10n.resultsReadyHours(
                                widget.laboratoryService
                                    .estimatedDurationHours!,
                              ),
                              style: AppTypography.bodySm,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Preparation Instructions
            if (service.preparationInstructions != null) ...[
              AppCard(
                elevation: AppCardElevation.none,
                borderRadius: AppRadius.md,
                borderColor: AppColors.warning.withValues(alpha: 0.2),
                backgroundColor: AppColors.warning.withValues(alpha: 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          l10n.preparationRequired,
                          style: AppTypography.bodyLg.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      service.preparationInstructions!,
                      style: AppTypography.body.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Date Selection
            Text(
              l10n.selectDate,
              style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppCard(
              elevation: AppCardElevation.none,
              borderRadius: AppRadius.sm,
              borderColor: AppColors.inkSubtle.withValues(alpha: 0.25),
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
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    style: AppTypography.bodyLg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Time Slot Selection
            Text(
              l10n.selectTimeSlot,
              style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: timeSlots.map((slot) {
                final isSelected = selectedTimeSlot == slot;
                return InkWell(
                  onTap: () => setState(() => selectedTimeSlot = slot),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.inkSubtle.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.inkSubtle.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      slot,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.surface : AppColors.ink,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Address
            Text(
              l10n.collectionAddress,
              style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Location Picker Button
            AppCard(
              elevation: AppCardElevation.none,
              borderRadius: AppRadius.sm,
              borderColor: selectedLocation != null
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.inkSubtle.withValues(alpha: 0.25),
              backgroundColor: selectedLocation != null
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : AppColors.surface,
              onTap: _openLocationPicker,
              child: Row(
                children: [
                  Icon(
                    Iconsax.location,
                    color: selectedLocation != null
                        ? AppColors.primary
                        : AppColors.inkSubtle,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      selectedLocation != null
                          ? _addressController.text
                          : l10n.addressHint,
                      style: AppTypography.body.copyWith(
                        color: selectedLocation != null
                            ? AppColors.ink
                            : AppColors.inkSubtle,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
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
                  'Please select your location on the map',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkSubtle.withValues(alpha: 0.8),
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.lg),

            // Notes
            Text(
              l10n.additionalNotesOptional,
              style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTextField(
              controller: _notesController,
              maxLines: 3,
              hint: l10n.specialInstructionsHint,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Submit Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.surface),
                        ),
                      )
                    : Text(
                        l10n.confirmBooking,
                        style: AppTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.surface,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
