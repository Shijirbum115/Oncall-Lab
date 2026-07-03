import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/core/utils/avatar_helper.dart';
import 'package:bugamed/ui/patient/models/doctor_profile_ui.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DoctorCardTile extends StatelessWidget {
  const DoctorCardTile({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  final DoctorProfileUI doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDefaultAvatar = AvatarHelper.isDefaultAvatar(doctor.avatarUrl);
    final hasAvatar = doctor.avatarUrl != null && doctor.avatarUrl!.isNotEmpty;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.sm),
      borderRadius: AppRadius.md,
      elevation: AppCardElevation.resting,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Color(doctor.color),
                backgroundImage: hasAvatar
                    ? (isDefaultAvatar
                        ? AssetImage(doctor.avatarUrl!) as ImageProvider
                        : NetworkImage(doctor.avatarUrl!))
                    : null,
                child: !hasAvatar
                    ? Text(
                        doctor.name.substring(0, 1),
                        style: AppTypography.bodyLg.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      doctor.name,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialization,
                      style: AppTypography.bodySm,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: AppColors.warning, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: AppTypography.bodySm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '(${l10n.reviewsCount(doctor.totalReviews)})',
                      style: AppTypography.label,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                doctor.price != null ? l10n.priceInMNT(doctor.price!) : '',
                style: AppTypography.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
