import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/patient/widgets/visit_option_card.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class VisitOptionsSection extends StatelessWidget {
  const VisitOptionsSection({
    super.key,
    required this.onClinicTap,
    required this.onHomeTap,
  });

  final VoidCallback onClinicTap;
  final VoidCallback onHomeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: AppPadding.screenH,
      child: Row(
        children: [
          Expanded(
            child: VisitOptionCard(
              icon: Iconsax.hospital,
              title: l10n.clinicVisit,
              subtitle: l10n.makeAnAppointment,
              backgroundColor: AppColors.primary,
              titleColor: Colors.white,
              subtitleColor: Colors.white.withValues(alpha: 0.8),
              iconBackgroundColor: Colors.white.withValues(alpha: 0.18),
              iconColor: Colors.white,
              elevated: true,
              onTap: onClinicTap,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: VisitOptionCard(
              icon: Iconsax.home_2,
              title: l10n.homeVisit,
              subtitle: l10n.callTheDoctorHome,
              backgroundColor: AppColors.white,
              titleColor: AppColors.black,
              subtitleColor: AppColors.textSecondary,
              iconBackgroundColor: AppColors.primary.withValues(alpha: 0.12),
              iconColor: AppColors.primary,
              borderColor: AppColors.grey.withValues(alpha: 0.3),
              elevated: true,
              onTap: onHomeTap,
            ),
          ),
        ],
      ),
    );
  }
}
