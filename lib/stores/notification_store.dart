import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:oncall_lab/data/models/notification_model.dart';
import 'package:oncall_lab/data/repositories/notification_repository.dart';
import 'package:oncall_lab/core/services/push_notification_service.dart';

part 'notification_store.g.dart';

class NotificationStore = _NotificationStore with _$NotificationStore;

abstract class _NotificationStore with Store {
  _NotificationStore(this._repository, this._pushService);

  final NotificationRepository _repository;
  final PushNotificationService _pushService;

  StreamSubscription? _notificationSubscription;

  @observable
  ObservableList<NotificationModel> notifications = ObservableList();

  @observable
  int unreadCount = 0;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @computed
  bool get hasUnread => unreadCount > 0;

  @computed
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  /// Initialize notifications and real-time subscription
  @action
  Future<void> initialize(String userId) async {
    await loadNotifications(userId);
    await loadUnreadCount(userId);
    _setupRealtimeSubscription(userId);
  }

  /// Load notifications from backend
  @action
  Future<void> loadNotifications(String userId) async {
    isLoading = true;
    errorMessage = null;

    try {
      final result = await _repository.getNotifications(userId: userId);
      notifications = ObservableList.of(result);
    } catch (e) {
      errorMessage = 'Failed to load notifications: $e';
    } finally {
      isLoading = false;
    }
  }

  /// Load unread count
  @action
  Future<void> loadUnreadCount(String userId) async {
    try {
      unreadCount = await _repository.getUnreadCount(userId);
    } catch (e) {
      errorMessage = 'Failed to load unread count: $e';
    }
  }

  /// Mark notification as read
  @action
  Future<void> markAsRead(String notificationId, String userId) async {
    try {
      await _repository.markAsRead(notificationId);

      // Update local state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1 && !notifications[index].isRead) {
        notifications[index] = notifications[index].copyWith(isRead: true);
        if (unreadCount > 0) unreadCount--;
      }
    } catch (e) {
      errorMessage = 'Failed to mark as read: $e';
    }
  }

  /// Mark all notifications as read
  @action
  Future<void> markAllAsRead(String userId) async {
    try {
      await _repository.markAllAsRead(userId);

      // Update local state
      notifications = ObservableList.of(
        notifications.map((n) => n.copyWith(isRead: true)).toList(),
      );
      unreadCount = 0;
    } catch (e) {
      errorMessage = 'Failed to mark all as read: $e';
    }
  }

  /// Update FCM token
  @action
  Future<void> updateFcmToken(String userId) async {
    try {
      final token = await _pushService.getToken();
      if (token != null) {
        await _repository.updateFcmToken(userId: userId, fcmToken: token);
      }
    } catch (e) {
      errorMessage = 'Failed to update FCM token: $e';
    }
  }

  /// Clear FCM token on logout
  @action
  Future<void> clearFcmToken(String userId) async {
    try {
      await _repository.clearFcmToken(userId);
      await _pushService.deleteToken();
    } catch (e) {
      errorMessage = 'Failed to clear FCM token: $e';
    }
  }

  /// Setup real-time subscription for new notifications
  void _setupRealtimeSubscription(String userId) {
    _notificationSubscription?.cancel();
    _notificationSubscription = _repository
        .subscribeToNotifications(userId)
        .listen((notification) {
      // Add new notification to list if not already there
      if (!notifications.any((n) => n.id == notification.id)) {
        notifications.insert(0, notification);
        if (!notification.isRead) {
          unreadCount++;
        }
      }
    });
  }

  /// Dispose
  void dispose() {
    _notificationSubscription?.cancel();
  }
}
