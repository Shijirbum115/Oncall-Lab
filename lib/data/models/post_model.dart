// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bugamed/data/models/post_category_model.dart';
import 'package:bugamed/data/models/profile_model.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

enum PostType {
  @JsonValue('article')
  article,
  @JsonValue('announcement')
  announcement,
  @JsonValue('health_tip')
  healthTip,
  @JsonValue('news')
  news,
  @JsonValue('promotion')
  promotion,
  @JsonValue('emergency_alert')
  emergencyAlert,
}

extension PostTypeX on PostType {
  String get dbValue {
    switch (this) {
      case PostType.article:
        return 'article';
      case PostType.announcement:
        return 'announcement';
      case PostType.healthTip:
        return 'health_tip';
      case PostType.news:
        return 'news';
      case PostType.promotion:
        return 'promotion';
      case PostType.emergencyAlert:
        return 'emergency_alert';
    }
  }

  String get displayName {
    switch (this) {
      case PostType.article:
        return 'Article';
      case PostType.announcement:
        return 'Announcement';
      case PostType.healthTip:
        return 'Health Tip';
      case PostType.news:
        return 'News';
      case PostType.promotion:
        return 'Promotion';
      case PostType.emergencyAlert:
        return 'Emergency Alert';
    }
  }

  String get displayNameMn {
    switch (this) {
      case PostType.article:
        return 'Нийтлэл';
      case PostType.announcement:
        return 'Мэдэгдэл';
      case PostType.healthTip:
        return 'Эрүүл мэндийн зөвлөмж';
      case PostType.news:
        return 'Мэдээ';
      case PostType.promotion:
        return 'Урамшуулал';
      case PostType.emergencyAlert:
        return 'Яаралтай мэдэгдэл';
    }
  }
}

@freezed
class PostModel with _$PostModel {
  const PostModel._(); // Private constructor for custom methods

  const factory PostModel({
    required String id,
    @JsonKey(name: 'author_id') required String authorId,
    required String title,
    @JsonKey(name: 'title_mn') String? titleMn,
    required String content,
    @JsonKey(name: 'content_mn') String? contentMn,
    String? excerpt,
    @JsonKey(name: 'excerpt_mn') String? excerptMn,
    @JsonKey(name: 'category_id') String? categoryId,
    List<String>? tags,
    @JsonKey(name: 'featured_image_url') String? featuredImageUrl,
    @JsonKey(name: 'media_urls') List<String>? mediaUrls,
    @JsonKey(name: 'post_type') required PostType postType,
    @JsonKey(name: 'is_published') @Default(false) bool isPublished,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'scheduled_publish_at') DateTime? scheduledPublishAt,
    @JsonKey(name: 'target_audience') String? targetAudience,
    @JsonKey(name: 'target_regions') List<String>? targetRegions,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'share_count') @Default(0) int shareCount,
    String? slug,
    @JsonKey(name: 'meta_description') String? metaDescription,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships (when fetched with joins)
    @JsonKey(name: 'post_categories') PostCategoryModel? category,
    ProfileModel? profile, // Author profile
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  // Get localized title
  String getLocalizedTitle({bool preferMongolian = true}) {
    if (preferMongolian && titleMn != null && titleMn!.isNotEmpty) {
      return titleMn!;
    }
    return title;
  }

  // Get localized content
  String getLocalizedContent({bool preferMongolian = true}) {
    if (preferMongolian && contentMn != null && contentMn!.isNotEmpty) {
      return contentMn!;
    }
    return content;
  }

  // Get localized excerpt
  String? getLocalizedExcerpt({bool preferMongolian = true}) {
    if (preferMongolian && excerptMn != null && excerptMn!.isNotEmpty) {
      return excerptMn;
    }
    return excerpt;
  }

  // Check if post is scheduled
  bool get isScheduled =>
      !isPublished &&
      scheduledPublishAt != null &&
      scheduledPublishAt!.isAfter(DateTime.now());

  // Check if post is draft
  bool get isDraft => !isPublished && scheduledPublishAt == null;

  // Check if post has media
  bool get hasMedia =>
      (mediaUrls != null && mediaUrls!.isNotEmpty) ||
      featuredImageUrl != null;

  // Get reading time estimate (assuming 200 words per minute)
  int get estimatedReadingMinutes {
    final wordCount = content.split(RegExp(r'\s+')).length;
    final minutes = (wordCount / 200).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  // Check if post is new (within 3 days)
  bool get isNew {
    if (publishedAt == null) return false;
    final difference = DateTime.now().difference(publishedAt!);
    return difference.inDays <= 3;
  }

  // Check if post is hot (high engagement)
  bool get isHot {
    return likeCount > 50 || viewCount > 500;
  }

  // Get display date
  String get displayDate {
    final date = publishedAt ?? createdAt;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} минутын өмнө';
      }
      return '${difference.inHours} цагийн өмнө';
    } else if (difference.inDays == 1) {
      return 'Өчигдөр';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} өдрийн өмнө';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }

  // Get badge text for post type
  String get typeBadge => postType.displayNameMn;

  // Get badge color for post type
  String get typeBadgeColor {
    switch (postType) {
      case PostType.article:
        return '#2196F3';
      case PostType.announcement:
        return '#FF9800';
      case PostType.healthTip:
        return '#4CAF50';
      case PostType.news:
        return '#9C27B0';
      case PostType.promotion:
        return '#F44336';
      case PostType.emergencyAlert:
        return '#E91E63';
    }
  }
}
