import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/notification_model.dart';

class NotificationRepository {
  /// Get all notifications for current user
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int limit = 50,
  }) async {
    final data = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((json) => NotificationModel.fromJson(json))
        .toList();
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    final result = await supabase
        .rpc('get_unread_notification_count', params: {'p_user_id': userId});
    return result as int? ?? 0;
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    await supabase
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  /// Mark all notifications as read for user
  Future<void> markAllAsRead(String userId) async {
    await supabase
        .rpc('mark_all_notifications_read', params: {'p_user_id': userId});
  }

  /// Update FCM token for user
  Future<void> updateFcmToken({
    required String userId,
    required String fcmToken,
  }) async {
    await supabase.rpc('update_fcm_token', params: {
      'p_user_id': userId,
      'p_fcm_token': fcmToken,
    });
  }

  /// Clear FCM token (on logout)
  Future<void> clearFcmToken(String userId) async {
    await supabase
        .from('profiles')
        .update({'fcm_token': null, 'fcm_token_updated_at': null})
        .eq('id', userId);
  }

  /// Subscribe to real-time notifications
  Stream<NotificationModel> subscribeToNotifications(String userId) {
    return supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => NotificationModel.fromJson(json)))
        .expand((notifications) => notifications);
  }
}
