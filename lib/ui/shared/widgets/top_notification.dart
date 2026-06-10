import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';

class TopNotification extends StatelessWidget {
  final String message;
  final NotificationType type;
  final VoidCallback onDismiss;

  const TopNotification({
    super.key,
    required this.message,
    required this.type,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final color = type == NotificationType.error
        ? AppColors.error
        : type == NotificationType.success
            ? AppColors.success
            : AppColors.info;

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              type == NotificationType.error
                  ? Icons.error_outline
                  : type == NotificationType.success
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum NotificationType { success, error, info }
