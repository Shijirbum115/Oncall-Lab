import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class LaboratoryDetailScreen extends StatelessWidget {
  const LaboratoryDetailScreen({super.key, required this.laboratory});

  final Map<String, dynamic> laboratory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final operatingHours = laboratory['operating_hours'] as Map<String, dynamic>?;
    final latitude = laboratory['latitude'];
    final longitude = laboratory['longitude'];

    return Scaffold(
      appBar: AppBar(
        title: Text(laboratory['name'] ?? l10n.laboratoryFallback),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.screenAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoTile(
                icon: Iconsax.location,
                title: l10n.address,
                value: laboratory['address'] ?? l10n.notSpecified,
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoTile(
                icon: Iconsax.call,
                title: l10n.phoneContact,
                value: laboratory['phone_number'] ?? l10n.notSpecified,
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoTile(
                icon: Iconsax.sms,
                title: l10n.email,
                value: laboratory['email'] ?? l10n.notSpecified,
              ),
              const SizedBox(height: AppSpacing.sm),
              if (latitude != null && longitude != null)
                _InfoTile(
                  icon: Iconsax.map,
                  title: l10n.coordinates,
                  value: '$latitude, $longitude',
                ),
              if (operatingHours != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(l10n.operatingHours, style: AppTypography.h3),
                const SizedBox(height: AppSpacing.sm),
                ...operatingHours.entries.map(
                  (entry) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: const Icon(
                      Iconsax.clock,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      entry.key,
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      entry.value.toString(),
                      style: AppTypography.bodySm,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              _InfoTile(
                icon: Iconsax.information,
                title: l10n.status,
                value: (laboratory['is_active'] == true)
                    ? l10n.acceptingRequests
                    : l10n.temporarilyUnavailable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: AppCardElevation.resting,
      borderRadius: AppRadius.md,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: AppTypography.bodyLg.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
