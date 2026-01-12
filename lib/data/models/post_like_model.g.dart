// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_like_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostLikeModelImpl _$$PostLikeModelImplFromJson(Map<String, dynamic> json) =>
    _$PostLikeModelImpl(
      id: json['id'] as String,
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PostLikeModelImplToJson(_$PostLikeModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post_id': instance.postId,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'profile': instance.profile,
    };
