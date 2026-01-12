import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oncall_lab/ui/shared/widgets/top_notification.dart';

class NotificationHelper {
  static void show(
    BuildContext context,
    String message, {
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 0,
        right: 0,
        child: TopNotification(
          message: message,
          type: type,
          onDismiss: () {}, // Will be handled by timer/animation in a real app, simplified here
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Simple auto-dismiss
    Timer(duration, () {
      overlayEntry.remove();
    });
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message, type: NotificationType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message, type: NotificationType.error);
  }
}
