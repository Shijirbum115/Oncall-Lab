import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/patient/models/schedule_ui.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({super.key, required this.schedule});

  final ScheduleUI schedule;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.md,
      elevation: AppCardElevation.resting,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.doctorName,
                    style: AppTypography.h3,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    schedule.specialization,
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor:
                    Color(schedule.badgeColor).withValues(alpha: 0.3),
                backgroundImage: NetworkImage(schedule.avatarUrl),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _IconText(
                icon: Icons.calendar_month,
                label: DateFormat('d/MM/y').format(schedule.dateTime),
              ),
              const SizedBox(width: 20),
              _IconText(
                icon: Icons.access_time_filled,
                label: DateFormat.jm().format(schedule.dateTime),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  schedule.status,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: 'Reschedule',
                  variant: AppButtonVariant.primary,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.inkMuted),
        const SizedBox(width: 6),
        Text(label, style: AppTypography.bodySm),
      ],
    );
  }
}
