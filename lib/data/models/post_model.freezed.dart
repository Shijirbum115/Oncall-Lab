// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'author_id')
  String get authorId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'title_mn')
  String? get titleMn => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_mn')
  String? get contentMn => throw _privateConstructorUsedError;
  String? get excerpt => throw _privateConstructorUsedError;
  @JsonKey(name: 'excerpt_mn')
  String? get excerptMn => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  String? get categoryId => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  @JsonKey(name: 'featured_image_url')
  String? get featuredImageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'media_urls')
  List<String>? get mediaUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'post_type')
  PostType get postType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_published')
  bool get isPublished => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured')
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_publish_at')
  DateTime? get scheduledPublishAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_audience')
  String? get targetAudience => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_regions')
  List<String>? get targetRegions => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int get viewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'like_count')
  int get likeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'share_count')
  int get shareCount => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'meta_description')
  String? get metaDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt =>
      throw _privateConstructorUsedError; // Nested relationships (when fetched with joins)
  @JsonKey(name: 'post_categories')
  PostCategoryModel? get category => throw _privateConstructorUsedError;
  ProfileModel? get profile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'author_id') String authorId,
      String title,
      @JsonKey(name: 'title_mn') String? titleMn,
      String content,
      @JsonKey(name: 'content_mn') String? contentMn,
      String? excerpt,
      @JsonKey(name: 'excerpt_mn') String? excerptMn,
      @JsonKey(name: 'category_id') String? categoryId,
      List<String>? tags,
      @JsonKey(name: 'featured_image_url') String? featuredImageUrl,
      @JsonKey(name: 'media_urls') List<String>? mediaUrls,
      @JsonKey(name: 'post_type') PostType postType,
      @JsonKey(name: 'is_published') bool isPublished,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'published_at') DateTime? publishedAt,
      @JsonKey(name: 'scheduled_publish_at') DateTime? scheduledPublishAt,
      @JsonKey(name: 'target_audience') String? targetAudience,
      @JsonKey(name: 'target_regions') List<String>? targetRegions,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'like_count') int likeCount,
      @JsonKey(name: 'share_count') int shareCount,
      String? slug,
      @JsonKey(name: 'meta_description') String? metaDescription,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'post_categories') PostCategoryModel? category,
      ProfileModel? profile});

  $PostCategoryModelCopyWith<$Res>? get category;
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? title = null,
    Object? titleMn = freezed,
    Object? content = null,
    Object? contentMn = freezed,
    Object? excerpt = freezed,
    Object? excerptMn = freezed,
    Object? categoryId = freezed,
    Object? tags = freezed,
    Object? featuredImageUrl = freezed,
    Object? mediaUrls = freezed,
    Object? postType = null,
    Object? isPublished = null,
    Object? isFeatured = null,
    Object? publishedAt = freezed,
    Object? scheduledPublishAt = freezed,
    Object? targetAudience = freezed,
    Object? targetRegions = freezed,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? shareCount = null,
    Object? slug = freezed,
    Object? metaDescription = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = freezed,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      titleMn: freezed == titleMn
          ? _value.titleMn
          : titleMn // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentMn: freezed == contentMn
          ? _value.contentMn
          : contentMn // ignore: cast_nullable_to_non_nullable
              as String?,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      excerptMn: freezed == excerptMn
          ? _value.excerptMn
          : excerptMn // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      featuredImageUrl: freezed == featuredImageUrl
          ? _value.featuredImageUrl
          : featuredImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrls: freezed == mediaUrls
          ? _value.mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledPublishAt: freezed == scheduledPublishAt
          ? _value.scheduledPublishAt
          : scheduledPublishAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetAudience: freezed == targetAudience
          ? _value.targetAudience
          : targetAudience // ignore: cast_nullable_to_non_nullable
              as String?,
      targetRegions: freezed == targetRegions
          ? _value.targetRegions
          : targetRegions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      metaDescription: freezed == metaDescription
          ? _value.metaDescription
          : metaDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as PostCategoryModel?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PostCategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $PostCategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileModelCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileModelCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'author_id') String authorId,
      String title,
      @JsonKey(name: 'title_mn') String? titleMn,
      String content,
      @JsonKey(name: 'content_mn') String? contentMn,
      String? excerpt,
      @JsonKey(name: 'excerpt_mn') String? excerptMn,
      @JsonKey(name: 'category_id') String? categoryId,
      List<String>? tags,
      @JsonKey(name: 'featured_image_url') String? featuredImageUrl,
      @JsonKey(name: 'media_urls') List<String>? mediaUrls,
      @JsonKey(name: 'post_type') PostType postType,
      @JsonKey(name: 'is_published') bool isPublished,
      @JsonKey(name: 'is_featured') bool isFeatured,
      @JsonKey(name: 'published_at') DateTime? publishedAt,
      @JsonKey(name: 'scheduled_publish_at') DateTime? scheduledPublishAt,
      @JsonKey(name: 'target_audience') String? targetAudience,
      @JsonKey(name: 'target_regions') List<String>? targetRegions,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'like_count') int likeCount,
      @JsonKey(name: 'share_count') int shareCount,
      String? slug,
      @JsonKey(name: 'meta_description') String? metaDescription,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'post_categories') PostCategoryModel? category,
      ProfileModel? profile});

  @override
  $PostCategoryModelCopyWith<$Res>? get category;
  @override
  $ProfileModelCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? authorId = null,
    Object? title = null,
    Object? titleMn = freezed,
    Object? content = null,
    Object? contentMn = freezed,
    Object? excerpt = freezed,
    Object? excerptMn = freezed,
    Object? categoryId = freezed,
    Object? tags = freezed,
    Object? featuredImageUrl = freezed,
    Object? mediaUrls = freezed,
    Object? postType = null,
    Object? isPublished = null,
    Object? isFeatured = null,
    Object? publishedAt = freezed,
    Object? scheduledPublishAt = freezed,
    Object? targetAudience = freezed,
    Object? targetRegions = freezed,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? shareCount = null,
    Object? slug = freezed,
    Object? metaDescription = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? category = freezed,
    Object? profile = freezed,
  }) {
    return _then(_$PostModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      titleMn: freezed == titleMn
          ? _value.titleMn
          : titleMn // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      contentMn: freezed == contentMn
          ? _value.contentMn
          : contentMn // ignore: cast_nullable_to_non_nullable
              as String?,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      excerptMn: freezed == excerptMn
          ? _value.excerptMn
          : excerptMn // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      featuredImageUrl: freezed == featuredImageUrl
          ? _value.featuredImageUrl
          : featuredImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrls: freezed == mediaUrls
          ? _value._mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      isPublished: null == isPublished
          ? _value.isPublished
          : isPublished // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledPublishAt: freezed == scheduledPublishAt
          ? _value.scheduledPublishAt
          : scheduledPublishAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetAudience: freezed == targetAudience
          ? _value.targetAudience
          : targetAudience // ignore: cast_nullable_to_non_nullable
              as String?,
      targetRegions: freezed == targetRegions
          ? _value._targetRegions
          : targetRegions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      metaDescription: freezed == metaDescription
          ? _value.metaDescription
          : metaDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as PostCategoryModel?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as ProfileModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl extends _PostModel {
  const _$PostModelImpl(
      {required this.id,
      @JsonKey(name: 'author_id') required this.authorId,
      required this.title,
      @JsonKey(name: 'title_mn') this.titleMn,
      required this.content,
      @JsonKey(name: 'content_mn') this.contentMn,
      this.excerpt,
      @JsonKey(name: 'excerpt_mn') this.excerptMn,
      @JsonKey(name: 'category_id') this.categoryId,
      final List<String>? tags,
      @JsonKey(name: 'featured_image_url') this.featuredImageUrl,
      @JsonKey(name: 'media_urls') final List<String>? mediaUrls,
      @JsonKey(name: 'post_type') required this.postType,
      @JsonKey(name: 'is_published') this.isPublished = false,
      @JsonKey(name: 'is_featured') this.isFeatured = false,
      @JsonKey(name: 'published_at') this.publishedAt,
      @JsonKey(name: 'scheduled_publish_at') this.scheduledPublishAt,
      @JsonKey(name: 'target_audience') this.targetAudience,
      @JsonKey(name: 'target_regions') final List<String>? targetRegions,
      @JsonKey(name: 'view_count') this.viewCount = 0,
      @JsonKey(name: 'like_count') this.likeCount = 0,
      @JsonKey(name: 'share_count') this.shareCount = 0,
      this.slug,
      @JsonKey(name: 'meta_description') this.metaDescription,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'post_categories') this.category,
      this.profile})
      : _tags = tags,
        _mediaUrls = mediaUrls,
        _targetRegions = targetRegions,
        super._();

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'author_id')
  final String authorId;
  @override
  final String title;
  @override
  @JsonKey(name: 'title_mn')
  final String? titleMn;
  @override
  final String content;
  @override
  @JsonKey(name: 'content_mn')
  final String? contentMn;
  @override
  final String? excerpt;
  @override
  @JsonKey(name: 'excerpt_mn')
  final String? excerptMn;
  @override
  @JsonKey(name: 'category_id')
  final String? categoryId;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'featured_image_url')
  final String? featuredImageUrl;
  final List<String>? _mediaUrls;
  @override
  @JsonKey(name: 'media_urls')
  List<String>? get mediaUrls {
    final value = _mediaUrls;
    if (value == null) return null;
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'post_type')
  final PostType postType;
  @override
  @JsonKey(name: 'is_published')
  final bool isPublished;
  @override
  @JsonKey(name: 'is_featured')
  final bool isFeatured;
  @override
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;
  @override
  @JsonKey(name: 'scheduled_publish_at')
  final DateTime? scheduledPublishAt;
  @override
  @JsonKey(name: 'target_audience')
  final String? targetAudience;
  final List<String>? _targetRegions;
  @override
  @JsonKey(name: 'target_regions')
  List<String>? get targetRegions {
    final value = _targetRegions;
    if (value == null) return null;
    if (_targetRegions is EqualUnmodifiableListView) return _targetRegions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'view_count')
  final int viewCount;
  @override
  @JsonKey(name: 'like_count')
  final int likeCount;
  @override
  @JsonKey(name: 'share_count')
  final int shareCount;
  @override
  final String? slug;
  @override
  @JsonKey(name: 'meta_description')
  final String? metaDescription;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// Nested relationships (when fetched with joins)
  @override
  @JsonKey(name: 'post_categories')
  final PostCategoryModel? category;
  @override
  final ProfileModel? profile;

  @override
  String toString() {
    return 'PostModel(id: $id, authorId: $authorId, title: $title, titleMn: $titleMn, content: $content, contentMn: $contentMn, excerpt: $excerpt, excerptMn: $excerptMn, categoryId: $categoryId, tags: $tags, featuredImageUrl: $featuredImageUrl, mediaUrls: $mediaUrls, postType: $postType, isPublished: $isPublished, isFeatured: $isFeatured, publishedAt: $publishedAt, scheduledPublishAt: $scheduledPublishAt, targetAudience: $targetAudience, targetRegions: $targetRegions, viewCount: $viewCount, likeCount: $likeCount, shareCount: $shareCount, slug: $slug, metaDescription: $metaDescription, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.titleMn, titleMn) || other.titleMn == titleMn) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.contentMn, contentMn) ||
                other.contentMn == contentMn) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.excerptMn, excerptMn) ||
                other.excerptMn == excerptMn) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.featuredImageUrl, featuredImageUrl) ||
                other.featuredImageUrl == featuredImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._mediaUrls, _mediaUrls) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.scheduledPublishAt, scheduledPublishAt) ||
                other.scheduledPublishAt == scheduledPublishAt) &&
            (identical(other.targetAudience, targetAudience) ||
                other.targetAudience == targetAudience) &&
            const DeepCollectionEquality()
                .equals(other._targetRegions, _targetRegions) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        authorId,
        title,
        titleMn,
        content,
        contentMn,
        excerpt,
        excerptMn,
        categoryId,
        const DeepCollectionEquality().hash(_tags),
        featuredImageUrl,
        const DeepCollectionEquality().hash(_mediaUrls),
        postType,
        isPublished,
        isFeatured,
        publishedAt,
        scheduledPublishAt,
        targetAudience,
        const DeepCollectionEquality().hash(_targetRegions),
        viewCount,
        likeCount,
        shareCount,
        slug,
        metaDescription,
        createdAt,
        updatedAt,
        category,
        profile
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel extends PostModel {
  const factory _PostModel(
      {required final String id,
      @JsonKey(name: 'author_id') required final String authorId,
      required final String title,
      @JsonKey(name: 'title_mn') final String? titleMn,
      required final String content,
      @JsonKey(name: 'content_mn') final String? contentMn,
      final String? excerpt,
      @JsonKey(name: 'excerpt_mn') final String? excerptMn,
      @JsonKey(name: 'category_id') final String? categoryId,
      final List<String>? tags,
      @JsonKey(name: 'featured_image_url') final String? featuredImageUrl,
      @JsonKey(name: 'media_urls') final List<String>? mediaUrls,
      @JsonKey(name: 'post_type') required final PostType postType,
      @JsonKey(name: 'is_published') final bool isPublished,
      @JsonKey(name: 'is_featured') final bool isFeatured,
      @JsonKey(name: 'published_at') final DateTime? publishedAt,
      @JsonKey(name: 'scheduled_publish_at') final DateTime? scheduledPublishAt,
      @JsonKey(name: 'target_audience') final String? targetAudience,
      @JsonKey(name: 'target_regions') final List<String>? targetRegions,
      @JsonKey(name: 'view_count') final int viewCount,
      @JsonKey(name: 'like_count') final int likeCount,
      @JsonKey(name: 'share_count') final int shareCount,
      final String? slug,
      @JsonKey(name: 'meta_description') final String? metaDescription,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'post_categories') final PostCategoryModel? category,
      final ProfileModel? profile}) = _$PostModelImpl;
  const _PostModel._() : super._();

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'author_id')
  String get authorId;
  @override
  String get title;
  @override
  @JsonKey(name: 'title_mn')
  String? get titleMn;
  @override
  String get content;
  @override
  @JsonKey(name: 'content_mn')
  String? get contentMn;
  @override
  String? get excerpt;
  @override
  @JsonKey(name: 'excerpt_mn')
  String? get excerptMn;
  @override
  @JsonKey(name: 'category_id')
  String? get categoryId;
  @override
  List<String>? get tags;
  @override
  @JsonKey(name: 'featured_image_url')
  String? get featuredImageUrl;
  @override
  @JsonKey(name: 'media_urls')
  List<String>? get mediaUrls;
  @override
  @JsonKey(name: 'post_type')
  PostType get postType;
  @override
  @JsonKey(name: 'is_published')
  bool get isPublished;
  @override
  @JsonKey(name: 'is_featured')
  bool get isFeatured;
  @override
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt;
  @override
  @JsonKey(name: 'scheduled_publish_at')
  DateTime? get scheduledPublishAt;
  @override
  @JsonKey(name: 'target_audience')
  String? get targetAudience;
  @override
  @JsonKey(name: 'target_regions')
  List<String>? get targetRegions;
  @override
  @JsonKey(name: 'view_count')
  int get viewCount;
  @override
  @JsonKey(name: 'like_count')
  int get likeCount;
  @override
  @JsonKey(name: 'share_count')
  int get shareCount;
  @override
  String? get slug;
  @override
  @JsonKey(name: 'meta_description')
  String? get metaDescription;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override // Nested relationships (when fetched with joins)
  @JsonKey(name: 'post_categories')
  PostCategoryModel? get category;
  @override
  ProfileModel? get profile;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
