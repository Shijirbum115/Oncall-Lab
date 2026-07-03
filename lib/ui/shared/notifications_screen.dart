import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:bugamed/data/models/notification_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/notification_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/ui/shared/notification_detail_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notificationStore = GetIt.I<NotificationStore>();
  final _authStore = GetIt.I<AuthStore>();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final userId = _authStore.currentProfile?.id;
    if (userId != null) {
      _notificationStore.loadNotifications(userId);
      _notificationStore.loadUnreadCount(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          l10n.notifications,
          style: AppTypography.h3.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Observer(
            builder: (_) => _notificationStore.hasUnread
                ? TextButton(
                    onPressed: () {
                      final userId = _authStore.currentProfile?.id;
                      if (userId != null) {
                        _notificationStore.markAllAsRead(userId);
                      }
                    },
                    child: Text(
                      l10n.markAllAsRead,
                      style: AppTypography.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (_notificationStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_notificationStore.notifications.isEmpty) {
            return Center(
              child: MascotStateWidget(
                emotion: MascotEmotion.sleeping,
                title: l10n.noNotificationsYet,
                subtitle: l10n.notificationsUpdatesHere,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadNotifications(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _notificationStore.notifications.length,
              itemBuilder: (context, index) {
                final notification = _notificationStore.notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: () => _handleNotificationTap(notification),
                  l10n: l10n,
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    final userId = _authStore.currentProfile?.id;
    if (userId != null && !notification.isRead) {
      _notificationStore.markAsRead(notification.id, userId);
    }

    // Navigate to notification detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailScreen(
          notification: notification,
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: notification.isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconColor(notification.type).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIcon(notification.type),
                  color: _getIconColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.bodyLg.copyWith(
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTypography.body.copyWith(
                        color: AppColors.inkMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _formatDate(notification.createdAt),
                      style: AppTypography.caption.copyWith(
                        color: AppColors.inkSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.requestCreated:
        return Icons.add_circle_outline;
      case NotificationType.requestAccepted:
        return Icons.check_circle_outline;
      case NotificationType.requestUpdated:
        return Icons.update;
      case NotificationType.statusChanged:
        return Icons.swap_horiz;
      case NotificationType.systemAlert:
        return Icons.info_outline;
    }
  }

  Color _getIconColor(NotificationType type) {
    switch (type) {
      case NotificationType.requestCreated:
        return AppColors.info;
      case NotificationType.requestAccepted:
        return AppColors.success;
      case NotificationType.requestUpdated:
        return AppColors.warning;
      case NotificationType.statusChanged:
        return AppColors.primary;
      case NotificationType.systemAlert:
        return AppColors.error;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return l10n.justNow;
      } else if (difference.inHours < 1) {
        return l10n.minutesAgo(difference.inMinutes);
      } else if (difference.inDays < 1) {
        return l10n.hoursAgo(difference.inHours);
      } else if (difference.inDays < 7) {
        return l10n.daysAgo(difference.inDays);
      } else {
        return DateFormat('MMM d, yyyy').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}
