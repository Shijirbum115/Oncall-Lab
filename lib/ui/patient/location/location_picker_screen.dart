import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/shared/widgets/custom_text_field.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class LocationPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLocation,
    this.initialAddress,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final MapController _mapController;
  LatLng? _selectedLocation;
  bool _isLoadingLocation = false;
  bool _isLoadingAddress = false;

  // Form controllers
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _doorController = TextEditingController();
  final TextEditingController _entranceController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _additionalInfoController = TextEditingController();
  final TextEditingController _labelController = TextEditingController();

  // Default center: Ulaanbaatar, Mongolia
  static const LatLng _defaultCenter = LatLng(47.9184676, 106.9177016);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _addressController.text = widget.initialAddress ?? '';
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _apartmentController.dispose();
    _floorController.dispose();
    _doorController.dispose();
    _entranceController.dispose();
    _buildingController.dispose();
    _additionalInfoController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          _showError(AppLocalizations.of(context)!.locationPermissionsDenied);
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        _showError(AppLocalizations.of(context)!.locationPermissionsPermanentlyDenied);
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final location = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = location;
        _isLoadingLocation = false;
      });

      _mapController.move(location, 15);
      await _getAddressFromLatLng(location);
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      if (mounted) {
        _showError(AppLocalizations.of(context)!.failedToGetLocation);
      }
    }
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    setState(() => _isLoadingAddress = true);

    try {
      final placemarks = await geo.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.street,
          place.subLocality,
          place.locality,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        setState(() {
          _addressController.text = address;
          _isLoadingAddress = false;
        });
      } else {
        setState(() => _isLoadingAddress = false);
      }
    } catch (e) {
      setState(() => _isLoadingAddress = false);
      if (kDebugMode) debugPrint('Error getting address: $e');
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng location) {
    setState(() => _selectedLocation = location);
    _getAddressFromLatLng(location);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _saveLocation() {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedLocation == null) {
      _showError(l10n.pleaseSelectLocationOnMap);
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      _showError(l10n.pleaseEnterAnAddress);
      return;
    }

    Navigator.pop(context, {
      'latitude': _selectedLocation!.latitude,
      'longitude': _selectedLocation!.longitude,
      'address_line': _addressController.text.trim(),
      'apartment_number': _apartmentController.text.trim(),
      'floor': _floorController.text.trim(),
      'door_number': _doorController.text.trim(),
      'entrance': _entranceController.text.trim(),
      'building_name': _buildingController.text.trim(),
      'additional_info': _additionalInfoController.text.trim(),
      'label': _labelController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(l10n.selectLocation),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveLocation,
            child: Text(
              l10n.save,
              style: AppTypography.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Section
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation ?? _defaultCenter,
                    initialZoom: 13.0,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.bugamed.app',
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              size: 50,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Current Location Button
                Positioned(
                  bottom: AppSpacing.md,
                  right: AppSpacing.md,
                  child: FloatingActionButton(
                    heroTag: 'current_location',
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    backgroundColor: AppColors.surface,
                    child: _isLoadingLocation
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.my_location,
                            color: AppColors.primary,
                          ),
                  ),
                ),
              ],
            ),
          ),

          // Address Form Section
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: AppPadding.screenAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoadingAddress)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                    Text(
                      l10n.addressDetails,
                      style: AppTypography.h3,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    CustomTextField(
                      controller: _addressController,
                      label: l10n.streetAddressRequired,
                      hint: l10n.streetAddressHint,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    CustomTextField(
                      controller: _labelController,
                      label: l10n.labelOptional,
                      hint: l10n.labelHint,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _buildingController,
                            label: l10n.buildingName,
                            hint: l10n.buildingNameHint,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: CustomTextField(
                            controller: _entranceController,
                            label: l10n.entrance,
                            hint: l10n.entranceHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _floorController,
                            label: l10n.floor,
                            hint: 'e.g., 5',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: CustomTextField(
                            controller: _apartmentController,
                            label: l10n.apartmentNumberLabel,
                            hint: l10n.apartmentNumberHint,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: CustomTextField(
                            controller: _doorController,
                            label: l10n.doorNumber,
                            hint: l10n.doorNumberHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    CustomTextField(
                      controller: _additionalInfoController,
                      label: l10n.additionalInfo,
                      hint: l10n.specialInstructionsOrLandmarks,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppPadding.screen),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                        child: Text(
                          l10n.save,
                          style: AppTypography.bodyLg.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
