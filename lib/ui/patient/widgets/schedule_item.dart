import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/ui/patient/models/schedule_ui.dart';

class ScheduleItem extends StatelessWidget {
  const ScheduleItem({super.key, required this.schedule});

  final ScheduleUI schedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.15),
            blurRadius: 12,
          )
        ],
      ),
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    schedule.specialization,
                    style: const TextStyle(color: AppColors.grey),
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
          const Divider(),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  schedule.status,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    side: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.4)),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reschedule'),
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
        Icon(icon, color: AppColors.grey),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.black)),
      ],
    );
  }
}
