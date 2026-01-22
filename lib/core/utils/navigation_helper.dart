import 'package:flutter/material.dart';
import 'package:bugamed/data/models/notification_model.dart';
import 'package:bugamed/ui/shared/notification_detail_screen.dart';
import 'package:bugamed/ui/patient/requests_screen.dart';

/// Global navigator key for navigation from anywhere in the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationHelper {
  /// Navigate to notification detail screen
  static void navigateToNotificationDetail(NotificationModel notification) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(
          notification: notification,
        ),
      ),
    );
  }

  /// Navigate to requests screen
  static void navigateToRequests() {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientRequestsScreen(),
      ),
    );
  }

  /// Handle notification navigation based on type
  static void handleNotificationNavigation(NotificationModel notification) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // Always navigate to notification detail screen
    // It has a button to view the related request if needed
    navigateToNotificationDetail(notification);
  }

  /// Navigate to specific request detail (if we create one in the future)
  static void navigateToRequestDetail(String requestId) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    // For now, just navigate to requests screen
    // TODO: Create RequestDetailScreen and navigate to it
    navigateToRequests();
  }
}
