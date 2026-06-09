import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';

/// Status pill badge. Colors and labels resolve from [AppColors] helpers so
/// every status indicator across the app stays consistent.
class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.getStatusColor(status);
    final text = AppColors.getStatusText(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
