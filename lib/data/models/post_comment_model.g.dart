// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostCommentModelImpl _$$PostCommentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PostCommentModelImpl(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      parentCommentId: json['parent_comment_id'] as String?,
      commentText: json['comment_text'] as String,
      isApproved: json['is_approved'] as bool? ?? false,
      isVisible: json['is_visible'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => PostCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PostCommentModelImplToJson(
        _$PostCommentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'parent_comment_id': instance.parentCommentId,
      'comment_text': instance.commentText,
      'is_approved': instance.isApproved,
      'is_visible': instance.isVisible,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'profile': instance.profile,
      'replies': instance.replies,
    };
