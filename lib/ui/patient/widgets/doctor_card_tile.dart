import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/utils/avatar_helper.dart';
import 'package:oncall_lab/ui/patient/models/doctor_profile_ui.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doctor.specialization,
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 11,
                        ),
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
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 15),
                      const SizedBox(width: 4),
                      Text(
                        doctor.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '(${l10n.reviewsCount(doctor.totalReviews)})',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  doctor.price != null ? l10n.priceInMNT(doctor.price!) : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
