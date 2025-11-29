import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/data/models/laboratory_service_model.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/test_request_store.dart';
import 'package:oncall_lab/ui/patient/location/location_picker_screen.dart';
import 'package:oncall_lab/ui/design_system/widgets/app_text_field.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/shared/widgets/app_card.dart';

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

    final l10n = AppLocalizations.of(context)!;
    setState(() => isSubmitting = true);

    try {
      final userId = authStore.currentUser!.id;

      // Create lab service request using the store
      final request = await testRequestStore.createLabServiceRequest(
        patientId: userId,
        laboratoryId: widget.laboratory['id'],
        laboratoryServiceId: widget.laboratoryService.id,
        serviceId: widget.laboratoryService.serviceId,
        scheduledDate: selectedDate.toIso8601String().split('T')[0],
        scheduledTimeSlot: selectedTimeSlot,
        patientAddress: _addressController.text.trim(),
        priceMnt: widget.laboratoryService.priceMnt,
        patientNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (mounted) {
        if (request != null) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.requestSubmitted),
              backgroundColor: AppColors.success,
            ),
          );

          // Navigate back to main page
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          // Show error from store
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${l10n.error}: ${testRequestStore.errorMessage ?? l10n.unknownError}',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
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
            // Service Info Card
            AppCard(
              showShadow: false,
              borderRadius: 18,
              borderColor: AppColors.primary.withValues(alpha: 0.15),
              backgroundColor: AppColors.primary.withValues(alpha: 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
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
                showShadow: false,
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
              showShadow: false,
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
              showShadow: false,
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
                  'Please select your location on the map',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grey.withValues(alpha: 0.8),
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
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        l10n.confirmBooking,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
