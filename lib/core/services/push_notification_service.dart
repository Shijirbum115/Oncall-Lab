import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bugamed/core/utils/navigation_helper.dart';
import 'package:bugamed/core/di/service_locator.dart';
import 'package:bugamed/stores/notification_store.dart';

/// Simple push notification service for Firebase Cloud Messaging
class PushNotificationService {
  FirebaseMessaging? _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize push notifications
  Future<void> initialize() async {
    try {
      // Check if Firebase is initialized
      try {
        Firebase.app();
        _messaging = FirebaseMessaging.instance;
      } catch (e) {
        debugPrint('⚠️ Firebase not initialized, push notifications disabled');
        return;
      }

      // Request permission
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ Notification permission granted');

        // Initialize local notifications for foreground
        await _initializeLocalNotifications();

        // Get FCM token
        _fcmToken = await _messaging!.getToken();
        debugPrint('📱 FCM Token: $_fcmToken');

        // Listen for token refresh
        _messaging!.onTokenRefresh.listen((token) {
          _fcmToken = token;
          debugPrint('🔄 FCM Token refreshed: $token');
        });

        // Handle foreground notifications
        FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

        // Handle notification taps
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

        // Check if app was opened from notification
        final initialMessage = await _messaging!.getInitialMessage();
        if (initialMessage != null) {
          _handleNotificationTap(initialMessage);
        }
      } else {
        debugPrint('⚠️ Notification permission denied');
      }
    } catch (e) {
      debugPrint('❌ Error initializing push notifications: $e');
    }
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle foreground notifications
  void _handleForegroundNotification(RemoteMessage message) {
    debugPrint('📬 Foreground notification: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // Show local notification
    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bugamed_channel',
          'BUGAMED Notifications',
          channelDescription: 'Notifications for test requests and updates',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data['notification_id'],
    );
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 Notification tapped: ${message.data}');
    _navigateToNotification(message.data);
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('👆 Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      _navigateToNotification({'notification_id': response.payload});
    }
  }

  /// Navigate to notification detail screen
  Future<void> _navigateToNotification(Map<String, dynamic> data) async {
    try {
      final notificationId = data['notification_id'];
      if (notificationId == null) {
        debugPrint('⚠️ No notification_id in data');
        return;
      }

      // Get the notification from the store
      final notificationStore = locator<NotificationStore>();
      final notification = notificationStore.notifications.firstWhere(
        (n) => n.id == notificationId,
        orElse: () => throw Exception('Notification not found'),
      );

      // Navigate to notification detail screen with mascot
      NavigationHelper.handleNotificationNavigation(notification);
    } catch (e) {
      debugPrint('❌ Error navigating to notification: $e');
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    if (_messaging == null) return null;
    if (_fcmToken != null) return _fcmToken;
    _fcmToken = await _messaging!.getToken();
    return _fcmToken;
  }

  /// Delete FCM token (on logout)
  Future<void> deleteToken() async {
    if (_messaging == null) return;
    await _messaging!.deleteToken();
    _fcmToken = null;
    debugPrint('🗑️ FCM token deleted');
  }
}

/// Handle background messages (top-level function required by Firebase)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background notification: ${message.notification?.title}');
}
