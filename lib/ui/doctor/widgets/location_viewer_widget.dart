import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/data/models/patient_address_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class LocationViewerWidget extends StatefulWidget {
  final PatientAddressModel address;
  final bool showFullScreen;

  const LocationViewerWidget({
    super.key,
    required this.address,
    this.showFullScreen = false,
  });

  @override
  State<LocationViewerWidget> createState() => _LocationViewerWidgetState();
}

class _LocationViewerWidgetState extends State<LocationViewerWidget> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> _openInMaps() async {
    final lat = widget.address.latitude;
    final lng = widget.address.longitude;

    // Try Google Maps first, then fall back to OpenStreetMap
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    final osmUrl = Uri.parse(
      'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=16/$lat/$lng',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(osmUrl)) {
        await launchUrl(osmUrl, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          _showError(AppLocalizations.of(context)!.couldNotOpenMap);
        }
      }
    } catch (e) {
      if (mounted) {
        _showError(AppLocalizations.of(context)!.errorOpeningMap);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _showFullscreenMap() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => LocationViewerWidget(
          address: widget.address,
          showFullScreen: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showFullScreen) {
      return _buildFullScreenView();
    }
    return _buildCompactView();
  }

  Widget _buildFullScreenView() {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.patientLocation),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: _openInMaps,
            tooltip: l10n.openInMaps,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildMap(),
          ),
          Expanded(
            flex: 2,
            child: _buildAddressDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactView() {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Preview
          GestureDetector(
            onTap: _showFullscreenMap,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    _buildMap(),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.zoom_out_map,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.viewFullMap,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Address Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.address.fullAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _openInMaps,
                    icon: const Icon(Icons.directions, size: 18),
                    label: Text(l10n.openInMaps),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    final location = LatLng(widget.address.latitude, widget.address.longitude);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: location,
        initialZoom: 15.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.bugamed.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: location,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.location_pin,
                size: 50,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressDetails() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addressDetails,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildDetailRow(l10n.address, widget.address.addressLine),

            if (widget.address.label != null)
              _buildDetailRow(l10n.labelOptional.replaceAll(' (optional)', ''), widget.address.label!),

            if (widget.address.buildingName != null)
              _buildDetailRow(l10n.buildingName, widget.address.buildingName!),

            if (widget.address.entrance != null)
              _buildDetailRow(l10n.entrance, widget.address.entrance!),

            if (widget.address.floor != null)
              _buildDetailRow(l10n.floor, widget.address.floor!),

            if (widget.address.apartmentNumber != null)
              _buildDetailRow(l10n.apartment, widget.address.apartmentNumber!),

            if (widget.address.doorNumber != null)
              _buildDetailRow(l10n.doorNumber, widget.address.doorNumber!),

            if (widget.address.additionalInfo != null)
              _buildDetailRow(
                l10n.additionalInfo,
                widget.address.additionalInfo!,
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openInMaps,
                icon: const Icon(Icons.navigation, size: 20),
                label: Text(l10n.getDirections),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey.withValues(alpha: 0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
