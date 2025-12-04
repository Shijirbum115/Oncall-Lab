// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      relatedRequestId: json['related_request_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'is_read': instance.isRead,
      'related_request_id': instance.relatedRequestId,
      'metadata': instance.metadata,
      'created_at': instance.createdAt,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.requestCreated: 'request_created',
  NotificationType.requestAccepted: 'request_accepted',
  NotificationType.requestUpdated: 'request_updated',
  NotificationType.statusChanged: 'status_changed',
  NotificationType.systemAlert: 'system_alert',
};
