import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/core/utils/avatar_helper.dart';
import 'package:bugamed/data/models/service_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/service_store.dart';
import 'package:bugamed/ui/patient/location/location_picker_screen.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/payment/payment_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DirectServiceBookingScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const DirectServiceBookingScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  State<DirectServiceBookingScreen> createState() =>
      _DirectServiceBookingScreenState();
}

class _DirectServiceBookingScreenState
    extends State<DirectServiceBookingScreen> {
  List<Map<String, dynamic>> availableDoctors = [];
  ServiceModel? serviceDetails;
  Map<String, dynamic>? selectedDoctor;
  bool isLoadingDoctors = true;
  bool isLoadingService = true;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTimeSlot = '09:00-12:00';
  bool isSubmitting = false;
  bool anyDoctor = false; // Toggle for "any available doctor"
  String? savedAddress;
  bool useSavedAddress = false;
  bool showManualAddressField = false;

  // Location data from picker
  Map<String, dynamic>? selectedLocation;

  String? get _selectedDoctorId =>
      selectedDoctor == null ? null : _extractDoctorId(selectedDoctor!);

  String? _extractDoctorId(Map<String, dynamic> doctor) {
    return (doctor['doctor_id'] as String?) ??
        (doctor['id'] as String?) ??
        (doctor['profile_id'] as String?);
  }

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
    _loadData();
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
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
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

  Future<void> _loadData() async {
    setState(() {
      isLoadingDoctors = true;
      isLoadingService = true;
      errorMessage = null;
    });

    try {
      final doctors =
          await serviceStore.getDoctorsForService(widget.serviceId);
      final service =
          await serviceStore.fetchServiceById(widget.serviceId);

      setState(() {
        availableDoctors = doctors;
        serviceDetails = service;
        isLoadingDoctors = false;
        isLoadingService = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoadingDoctors = false;
        isLoadingService = false;
      });
    }
  }

  Future<void> _submitBooking() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;

    if (!anyDoctor && selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectDoctorOrAnyAvailable),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Validate location is selected
    if (selectedLocation == null && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectLocationOnMap),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Get the doctor_service_id if a doctor is selected
      String? doctorServiceId;
      String? doctorId;
      int priceMnt = 0;

      if (selectedDoctor != null) {
        final selectedId = _extractDoctorId(selectedDoctor!);
        if (selectedId == null) {
          throw Exception('Selected doctor id missing');
        }
        final doctorService = await serviceStore.fetchDoctorService(
          doctorId: selectedId,
          serviceId: widget.serviceId,
        );

        doctorServiceId = doctorService.id;
        doctorId = selectedId;
        priceMnt = doctorService.priceMnt;
      } else {
        // Use the minimum price from available doctors
        priceMnt = availableDoctors.isEmpty
            ? 0
            : availableDoctors
                .map((d) => d['price_mnt'] as int)
                .reduce((a, b) => a < b ? a : b);
      }

      // Prepare booking data
      final bookingData = {
        'serviceId': widget.serviceId,
        'doctorServiceId': doctorServiceId,
        'doctorId': doctorId,
        'scheduledDate': selectedDate.toIso8601String().split('T')[0],
        'scheduledTimeSlot': selectedTimeSlot,
        'patientAddress': _addressController.text.trim(),
        'patientLatitude': selectedLocation?['latitude'],
        'patientLongitude': selectedLocation?['longitude'],
        'doctorCommissionMnt': (priceMnt * 0.7).round(), // 70% commission for doctor
        'patientNotes': _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      };

      if (!mounted) return;

      // Navigate to payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            amountMnt: priceMnt,
            serviceName: widget.serviceName,
            laboratoryName: null,
            bookingData: bookingData,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.bookService),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: isLoadingService
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : errorMessage != null
              ? _buildError()
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      _buildServiceInfo(),
                      const SizedBox(height: AppSpacing.lg),
                      if (serviceDetails!.preparationInstructions != null)
                        _buildPreparationInstructions(),
                      _buildDoctorSelection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildDateSelection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildTimeSlotSelection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildAddressField(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildNotesField(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildSubmitButton(),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError() {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: AppPadding.screenAll,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.errorLoadingService,
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.inkSubtle),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: _loadData,
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo() {
    return AppCard(
      elevation: AppCardElevation.none,
      borderRadius: AppRadius.sm,
      backgroundColor: AppColors.primary.withValues(alpha: 0.05),
      borderColor: AppColors.primary.withValues(alpha: 0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceDetails!.name,
            style: AppTypography.h3,
          ),
          const SizedBox(height: AppSpacing.xs),
          if (serviceDetails!.description != null)
            Text(
              serviceDetails!.description!,
              style: AppTypography.body.copyWith(
                color: AppColors.inkSubtle,
                height: 1.5,
              ),
            ),
          if (serviceDetails!.estimatedDurationMinutes != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.inkSubtle),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.durationMinutesShort(serviceDetails!.estimatedDurationMinutes!),
                  style: AppTypography.bodySm,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreparationInstructions() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppCard(
          elevation: AppCardElevation.none,
          borderRadius: AppRadius.sm,
          backgroundColor: AppColors.warning.withValues(alpha: 0.1),
          borderColor: AppColors.warning.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
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
                serviceDetails!.preparationInstructions!,
                style: AppTypography.body.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildDoctorSelection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectDoctor,
          style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Any Available Doctor Toggle
        InkWell(
          onTap: () {
            setState(() {
              anyDoctor = !anyDoctor;
              if (anyDoctor) {
                selectedDoctor = null;
              }
            });
          },
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: anyDoctor
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: anyDoctor
                    ? AppColors.primary
                    : AppColors.inkSubtle.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  anyDoctor ? Icons.check_circle : Icons.circle_outlined,
                  color: anyDoctor ? AppColors.primary : AppColors.inkSubtle,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.anyAvailableDoctor,
                        style: AppTypography.bodyLg.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.firstAvailableDoctorWillAccept,
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!anyDoctor) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.orChooseSpecificDoctor,
            style: AppTypography.body.copyWith(
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Doctors List
          if (isLoadingDoctors)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: AppColors.primary),
            ))
          else if (availableDoctors.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.inkSubtle.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Text(
                  l10n.noDoctorsAvailableForService,
                  style: AppTypography.body.copyWith(color: AppColors.inkMuted),
                ),
              ),
            )
          else
        ...availableDoctors.map((doctor) => _DoctorCard(
              doctor: doctor,
              isSelected: _selectedDoctorId == _extractDoctorId(doctor),
              onTap: () {
                setState(() {
                  selectedDoctor = doctor;
                  anyDoctor = false;
                });
              },
            )),
        ],
      ],
    );
  }

  Widget _buildDateSelection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectDate,
          style: AppTypography.bodyLg.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
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
          borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.inkSubtle.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
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
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      ],
    );
  }

  Widget _buildAddressField() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.yourAddress,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),

        // Location Picker Button
        AppCard(
          elevation: AppCardElevation.none,
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
                      : l10n.selectLocationOnMap,
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

        // Show hint if no location selected
        if (selectedLocation == null && _addressController.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              l10n.tapToOpenMapSelectAddress,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey.withValues(alpha: 0.8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotesField() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  Widget _buildSubmitButton() {
    final l10n = AppLocalizations.of(context)!;

    return SizedBox(
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final bool isSelected;
  final VoidCallback onTap;

  const _DoctorCard({
    required this.doctor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.grey.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              _buildDoctorAvatar(doctor),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${doctor['full_name']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor['profession'] ?? 'Specialist',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${doctor['rating']} (${doctor['total_reviews']})',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${doctor['price_mnt']} MNT',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selection Indicator
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? AppColors.primary : AppColors.grey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(Map<String, dynamic> doctor) {
    final avatarUrl = doctor['avatar_url'] as String?;
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    final isDefaultAvatar = AvatarHelper.isDefaultAvatar(avatarUrl);

    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
      backgroundImage: hasAvatar
          ? (isDefaultAvatar
              ? AssetImage(avatarUrl) as ImageProvider
              : NetworkImage(avatarUrl))
          : null,
      child: !hasAvatar
          ? Text(
              doctor['full_name'][0].toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            )
          : null,
    );
  }
}
