import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/ui/patient/widgets/visit_option_card.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: VisitOptionCard(
              icon: Icons.add,
              iconWeight: FontWeight.w700,
              iconSize: 28,
              title: l10n.clinicVisit,
              subtitle: l10n.makeAnAppointment,
              backgroundColor: AppColors.primary,
              titleColor: Colors.white,
              subtitleColor: Colors.white.withValues(alpha: 0.8),
              iconBackgroundColor: Colors.white,
              iconColor: AppColors.primary,
              elevated: true,
              showWavyPattern: true,
              onTap: onClinicTap,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: VisitOptionCard(
              icon: Iconsax.home_2,
              iconFilled: true,
              title: l10n.homeVisit,
              subtitle: l10n.callTheDoctorHome,
              backgroundColor: Colors.white,
              titleColor: AppColors.black,
              subtitleColor: AppColors.black,
              iconBackgroundColor: AppColors.primary.withValues(alpha: 0.12),
              iconColor: AppColors.primary,
              elevated: false,
              onTap: onHomeTap,
            ),
          ),
        ],
      ),
    );
  }
}
