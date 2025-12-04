// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NotificationStore on _NotificationStore, Store {
  Computed<bool>? _$hasUnreadComputed;

  @override
  bool get hasUnread =>
      (_$hasUnreadComputed ??= Computed<bool>(() => super.hasUnread,
              name: '_NotificationStore.hasUnread'))
          .value;
  Computed<List<NotificationModel>>? _$unreadNotificationsComputed;

  @override
  List<NotificationModel> get unreadNotifications =>
      (_$unreadNotificationsComputed ??= Computed<List<NotificationModel>>(
              () => super.unreadNotifications,
              name: '_NotificationStore.unreadNotifications'))
          .value;

  late final _$notificationsAtom =
      Atom(name: '_NotificationStore.notifications', context: context);

  @override
  ObservableList<NotificationModel> get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(ObservableList<NotificationModel> value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  late final _$unreadCountAtom =
      Atom(name: '_NotificationStore.unreadCount', context: context);

  @override
  int get unreadCount {
    _$unreadCountAtom.reportRead();
    return super.unreadCount;
  }

  @override
  set unreadCount(int value) {
    _$unreadCountAtom.reportWrite(value, super.unreadCount, () {
      super.unreadCount = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_NotificationStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_NotificationStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$initializeAsyncAction =
      AsyncAction('_NotificationStore.initialize', context: context);

  @override
  Future<void> initialize(String userId) {
    return _$initializeAsyncAction.run(() => super.initialize(userId));
  }

  late final _$loadNotificationsAsyncAction =
      AsyncAction('_NotificationStore.loadNotifications', context: context);

  @override
  Future<void> loadNotifications(String userId) {
    return _$loadNotificationsAsyncAction
        .run(() => super.loadNotifications(userId));
  }

  late final _$loadUnreadCountAsyncAction =
      AsyncAction('_NotificationStore.loadUnreadCount', context: context);

  @override
  Future<void> loadUnreadCount(String userId) {
    return _$loadUnreadCountAsyncAction
        .run(() => super.loadUnreadCount(userId));
  }

  late final _$markAsReadAsyncAction =
      AsyncAction('_NotificationStore.markAsRead', context: context);

  @override
  Future<void> markAsRead(String notificationId, String userId) {
    return _$markAsReadAsyncAction
        .run(() => super.markAsRead(notificationId, userId));
  }

  late final _$markAllAsReadAsyncAction =
      AsyncAction('_NotificationStore.markAllAsRead', context: context);

  @override
  Future<void> markAllAsRead(String userId) {
    return _$markAllAsReadAsyncAction.run(() => super.markAllAsRead(userId));
  }

  late final _$updateFcmTokenAsyncAction =
      AsyncAction('_NotificationStore.updateFcmToken', context: context);

  @override
  Future<void> updateFcmToken(String userId) {
    return _$updateFcmTokenAsyncAction.run(() => super.updateFcmToken(userId));
  }

  late final _$clearFcmTokenAsyncAction =
      AsyncAction('_NotificationStore.clearFcmToken', context: context);

  @override
  Future<void> clearFcmToken(String userId) {
    return _$clearFcmTokenAsyncAction.run(() => super.clearFcmToken(userId));
  }

  @override
  String toString() {
    return '''
notifications: ${notifications},
unreadCount: ${unreadCount},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
hasUnread: ${hasUnread},
unreadNotifications: ${unreadNotifications}
    ''';
  }
}
