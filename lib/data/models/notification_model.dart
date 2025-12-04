// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('request_created')
  requestCreated,
  @JsonValue('request_accepted')
  requestAccepted,
  @JsonValue('request_updated')
  requestUpdated,
  @JsonValue('status_changed')
  statusChanged,
  @JsonValue('system_alert')
  systemAlert,
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required NotificationType type,
    required String title,
    required String message,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'related_request_id') String? relatedRequestId,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
