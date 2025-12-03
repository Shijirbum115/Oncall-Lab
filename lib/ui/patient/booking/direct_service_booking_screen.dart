import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/utils/avatar_helper.dart';
import 'package:oncall_lab/data/models/service_model.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/service_store.dart';
import 'package:oncall_lab/stores/test_request_store.dart';
import 'package:oncall_lab/ui/patient/location/location_picker_screen.dart';
import 'package:oncall_lab/ui/design_system/widgets/app_text_field.dart';
import 'package:oncall_lab/ui/shared/widgets/app_card.dart';

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
    if (!_formKey.currentState!.validate()) return;

    if (!anyDoctor && selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a doctor or choose "Any Available Doctor"'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

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
      final userId = authStore.currentUser!.id;

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

      // Create direct service request using the store
      final request = await testRequestStore.createDirectServiceRequest(
        patientId: userId,
        serviceId: widget.serviceId,
        scheduledDate: selectedDate.toIso8601String().split('T')[0],
        scheduledTimeSlot: selectedTimeSlot,
        patientAddress: _addressController.text.trim(),
        priceMnt: priceMnt,
        doctorId: doctorId, // null if anyDoctor is true
        doctorServiceId: doctorServiceId,
        patientNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      if (mounted) {
        if (request != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request submitted successfully!'),
              backgroundColor: AppColors.success,
            ),
          );

          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          // Show error from store
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${testRequestStore.errorMessage ?? "Unknown error"}'),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Book Service'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoadingService
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : errorMessage != null
              ? _buildError()
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildServiceInfo(),
                      const SizedBox(height: 24),
                      if (serviceDetails!.preparationInstructions != null)
                        _buildPreparationInstructions(),
                      _buildDoctorSelection(),
                      const SizedBox(height: 24),
                      _buildDateSelection(),
                      const SizedBox(height: 24),
                      _buildTimeSlotSelection(),
                      const SizedBox(height: 24),
                      _buildAddressField(),
                      const SizedBox(height: 24),
                      _buildNotesField(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Error loading service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            serviceDetails!.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          if (serviceDetails!.description != null)
            Text(
              serviceDetails!.description!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.grey,
                height: 1.5,
              ),
            ),
          if (serviceDetails!.estimatedDurationMinutes != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.grey),
                const SizedBox(width: 4),
                Text(
                  '~${serviceDetails!.estimatedDurationMinutes} minutes',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreparationInstructions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Preparation Required',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                serviceDetails!.preparationInstructions!,
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
    );
  }

  Widget _buildDoctorSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Doctor',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),

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
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: anyDoctor
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: anyDoctor
                    ? AppColors.primary
                    : AppColors.grey.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  anyDoctor ? Icons.check_circle : Icons.circle_outlined,
                  color: anyDoctor ? AppColors.primary : AppColors.grey,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Any Available Doctor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'First available doctor will accept your request',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        if (!anyDoctor) ...[
          const SizedBox(height: 16),
          const Text(
            'Or choose a specific doctor:',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

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
                color: AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No doctors available for this service',
                  style: TextStyle(color: AppColors.grey),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
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
          borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.grey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
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
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time Slot',
          style: TextStyle(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      ],
    );
  }

  Widget _buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Address',
          style: TextStyle(
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
                      : 'Select your location on the map',
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
              'Tap to open map and select your address',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Notes (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _notesController,
          maxLines: 3,
          hint: 'Any special instructions...',
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
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
            : const Text(
                'Confirm Booking',
                style: TextStyle(
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
