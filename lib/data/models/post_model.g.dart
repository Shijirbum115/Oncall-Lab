// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      title: json['title'] as String,
      titleMn: json['title_mn'] as String?,
      content: json['content'] as String,
      contentMn: json['content_mn'] as String?,
      excerpt: json['excerpt'] as String?,
      excerptMn: json['excerpt_mn'] as String?,
      categoryId: json['category_id'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      featuredImageUrl: json['featured_image_url'] as String?,
      mediaUrls: (json['media_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      postType: $enumDecode(_$PostTypeEnumMap, json['post_type']),
      isPublished: json['is_published'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      scheduledPublishAt: json['scheduled_publish_at'] == null
          ? null
          : DateTime.parse(json['scheduled_publish_at'] as String),
      targetAudience: json['target_audience'] as String?,
      targetRegions: (json['target_regions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      shareCount: (json['share_count'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String?,
      metaDescription: json['meta_description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      category: json['post_categories'] == null
          ? null
          : PostCategoryModel.fromJson(
              json['post_categories'] as Map<String, dynamic>),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_id': instance.authorId,
      'title': instance.title,
      'title_mn': instance.titleMn,
      'content': instance.content,
      'content_mn': instance.contentMn,
      'excerpt': instance.excerpt,
      'excerpt_mn': instance.excerptMn,
      'category_id': instance.categoryId,
      'tags': instance.tags,
      'featured_image_url': instance.featuredImageUrl,
      'media_urls': instance.mediaUrls,
      'post_type': _$PostTypeEnumMap[instance.postType]!,
      'is_published': instance.isPublished,
      'is_featured': instance.isFeatured,
      'published_at': instance.publishedAt?.toIso8601String(),
      'scheduled_publish_at': instance.scheduledPublishAt?.toIso8601String(),
      'target_audience': instance.targetAudience,
      'target_regions': instance.targetRegions,
      'view_count': instance.viewCount,
      'like_count': instance.likeCount,
      'share_count': instance.shareCount,
      'slug': instance.slug,
      'meta_description': instance.metaDescription,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'post_categories': instance.category,
      'profile': instance.profile,
    };

const _$PostTypeEnumMap = {
  PostType.article: 'article',
  PostType.announcement: 'announcement',
  PostType.healthTip: 'health_tip',
  PostType.news: 'news',
  PostType.promotion: 'promotion',
  PostType.emergencyAlert: 'emergency_alert',
};
