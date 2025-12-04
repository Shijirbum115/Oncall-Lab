import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/ui/shared/widgets/custom_text_field.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

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
          _showError('Location permissions are denied');
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        _showError('Location permissions are permanently denied');
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
      _showError('Failed to get current location: $e');
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
      debugPrint('Error getting address: $e');
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
    if (_selectedLocation == null) {
      _showError('Please select a location on the map');
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      _showError('Please enter an address');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveLocation,
            child: Text(
              l10n.save,
              style: const TextStyle(
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
                      userAgentPackageName: 'com.oncall_lab.app',
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
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: 'current_location',
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    backgroundColor: Colors.white,
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
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isLoadingAddress)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                    const Text(
                      'Address Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _addressController,
                      label: 'Street Address *',
                      hint: 'e.g., Baga toiruu 17, Sukhbaatar district',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      controller: _labelController,
                      label: 'Label (optional)',
                      hint: 'e.g., Home, Work, Parent\'s House',
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _buildingController,
                            label: 'Building Name',
                            hint: 'e.g., Skytel Tower',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _entranceController,
                            label: 'Entrance',
                            hint: 'e.g., A, B, 1',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _floorController,
                            label: 'Floor',
                            hint: 'e.g., 5',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _apartmentController,
                            label: 'Apartment #',
                            hint: 'e.g., 512',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _doorController,
                            label: 'Door #',
                            hint: 'e.g., A',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    CustomTextField(
                      controller: _additionalInfoController,
                      label: 'Additional Information',
                      hint: 'Any special instructions or landmarks',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.save,
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
          ),
        ],
      ),
    );
  }
}
