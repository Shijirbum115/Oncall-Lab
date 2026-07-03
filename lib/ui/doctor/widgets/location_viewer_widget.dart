import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
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
      MaterialPageRoute(
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.patientLocation),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_3),
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
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Preview
          GestureDetector(
            onTap: _showFullscreenMap,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.sm),
              ),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    _buildMap(),
                    Positioned(
                      bottom: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          boxShadow: AppShadows.resting,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Iconsax.maximize_4,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.viewFullMap,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
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
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Iconsax.location,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        widget.address.fullAddress,
                        style: AppTypography.body,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: l10n.openInMaps,
                  variant: AppButtonVariant.secondary,
                  icon: Iconsax.routing,
                  onPressed: _openInMaps,
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
                Iconsax.location5,
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
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.resting,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addressDetails,
              style: AppTypography.h3,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildDetailRow(l10n.address, widget.address.addressLine),

            if (widget.address.label != null)
              _buildDetailRow(
                  l10n.labelOptional.replaceAll(' (optional)', ''),
                  widget.address.label!),

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

            const SizedBox(height: AppSpacing.md),

            AppButton(
              label: l10n.getDirections,
              variant: AppButtonVariant.primary,
              icon: Iconsax.routing_2,
              onPressed: _openInMaps,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySm,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body,
            ),
          ),
        ],
      ),
    );
  }
}
