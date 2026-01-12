import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/post_model.dart';

class PostRepository {
  /// Get published posts with pagination
  Future<List<PostModel>> getPublishedPosts({
    String? categoryId,
    String? postType,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn,
            icon_name,
            color_hex
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('is_published', true)
        .lte('published_at', DateTime.now().toIso8601String())
        .order('is_featured', ascending: false)
        .order('published_at', ascending: false)
        .range(offset, offset + limit - 1);

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    if (postType != null) {
      query = query.eq('post_type', postType);
    }

    final data = await query;

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Get published posts using database function (optimized)
  Future<List<Map<String, dynamic>>> getPublishedPostsOptimized({
    String? categoryId,
    String? postType,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await supabase.rpc('get_published_posts', params: {
      'p_category_id': categoryId,
      'p_post_type': postType,
      'p_limit': limit,
      'p_offset': offset,
    });

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get featured posts for home screen
  Future<List<PostModel>> getFeaturedPosts({int limit = 5}) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn,
            icon_name,
            color_hex
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('is_published', true)
        .eq('is_featured', true)
        .lte('published_at', DateTime.now().toIso8601String())
        .order('published_at', ascending: false)
        .limit(limit);

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Get a single post by ID
  Future<PostModel> getPostById(String postId) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn,
            icon_name,
            color_hex
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url,
            role
          )
        ''')
        .eq('id', postId)
        .single();

    return PostModel.fromJson(data);
  }

  /// Get post by slug
  Future<PostModel?> getPostBySlug(String slug) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('slug', slug)
        .eq('is_published', true)
        .maybeSingle();

    if (data == null) return null;
    return PostModel.fromJson(data);
  }

  /// Get posts by author
  Future<List<PostModel>> getPostsByAuthor({
    required String authorId,
    bool onlyPublished = true,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          )
        ''')
        .eq('author_id', authorId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    if (onlyPublished) {
      query = query.eq('is_published', true);
    }

    final data = await query;

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Search posts
  Future<List<PostModel>> searchPosts({
    required String searchTerm,
    String? categoryId,
    int limit = 20,
  }) async {
    var query = supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('is_published', true)
        .or('title.ilike.%$searchTerm%,title_mn.ilike.%$searchTerm%,content.ilike.%$searchTerm%,content_mn.ilike.%$searchTerm%')
        .order('published_at', ascending: false)
        .limit(limit);

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }

    final data = await query;

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Get posts by tag
  Future<List<PostModel>> getPostsByTag({
    required String tag,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('is_published', true)
        .contains('tags', [tag])
        .order('published_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Create a new post (Admin/Verified Doctor only)
  Future<PostModel> createPost({
    required String authorId,
    required String title,
    String? titleMn,
    required String content,
    String? contentMn,
    String? excerpt,
    String? excerptMn,
    String? categoryId,
    List<String>? tags,
    String? featuredImageUrl,
    List<String>? mediaUrls,
    required String postType,
    bool isPublished = false,
    bool isFeatured = false,
    DateTime? publishedAt,
    DateTime? scheduledPublishAt,
    String? targetAudience,
    List<String>? targetRegions,
    String? slug,
    String? metaDescription,
  }) async {
    final data = await supabase
        .from('posts')
        .insert({
          'author_id': authorId,
          'title': title,
          'title_mn': titleMn,
          'content': content,
          'content_mn': contentMn,
          'excerpt': excerpt,
          'excerpt_mn': excerptMn,
          'category_id': categoryId,
          'tags': tags,
          'featured_image_url': featuredImageUrl,
          'media_urls': mediaUrls,
          'post_type': postType,
          'is_published': isPublished,
          'is_featured': isFeatured,
          'published_at': publishedAt?.toIso8601String(),
          'scheduled_publish_at': scheduledPublishAt?.toIso8601String(),
          'target_audience': targetAudience,
          'target_regions': targetRegions,
          'slug': slug,
          'meta_description': metaDescription,
        })
        .select()
        .single();

    return PostModel.fromJson(data);
  }

  /// Update a post
  Future<PostModel> updatePost({
    required String postId,
    String? title,
    String? titleMn,
    String? content,
    String? contentMn,
    String? excerpt,
    String? excerptMn,
    String? categoryId,
    List<String>? tags,
    String? featuredImageUrl,
    List<String>? mediaUrls,
    String? postType,
    bool? isPublished,
    bool? isFeatured,
    DateTime? publishedAt,
    DateTime? scheduledPublishAt,
    String? targetAudience,
    List<String>? targetRegions,
    String? slug,
    String? metaDescription,
  }) async {
    final updateData = <String, dynamic>{};
    if (title != null) updateData['title'] = title;
    if (titleMn != null) updateData['title_mn'] = titleMn;
    if (content != null) updateData['content'] = content;
    if (contentMn != null) updateData['content_mn'] = contentMn;
    if (excerpt != null) updateData['excerpt'] = excerpt;
    if (excerptMn != null) updateData['excerpt_mn'] = excerptMn;
    if (categoryId != null) updateData['category_id'] = categoryId;
    if (tags != null) updateData['tags'] = tags;
    if (featuredImageUrl != null) updateData['featured_image_url'] = featuredImageUrl;
    if (mediaUrls != null) updateData['media_urls'] = mediaUrls;
    if (postType != null) updateData['post_type'] = postType;
    if (isPublished != null) {
      updateData['is_published'] = isPublished;
      if (isPublished && publishedAt == null) {
        updateData['published_at'] = DateTime.now().toIso8601String();
      }
    }
    if (isFeatured != null) updateData['is_featured'] = isFeatured;
    if (publishedAt != null) updateData['published_at'] = publishedAt.toIso8601String();
    if (scheduledPublishAt != null) {
      updateData['scheduled_publish_at'] = scheduledPublishAt.toIso8601String();
    }
    if (targetAudience != null) updateData['target_audience'] = targetAudience;
    if (targetRegions != null) updateData['target_regions'] = targetRegions;
    if (slug != null) updateData['slug'] = slug;
    if (metaDescription != null) updateData['meta_description'] = metaDescription;

    final data = await supabase
        .from('posts')
        .update(updateData)
        .eq('id', postId)
        .select()
        .single();

    return PostModel.fromJson(data);
  }

  /// Publish a draft post
  Future<PostModel> publishPost(String postId) async {
    final data = await supabase
        .from('posts')
        .update({
          'is_published': true,
          'published_at': DateTime.now().toIso8601String(),
        })
        .eq('id', postId)
        .select()
        .single();

    return PostModel.fromJson(data);
  }

  /// Unpublish a post
  Future<PostModel> unpublishPost(String postId) async {
    final data = await supabase
        .from('posts')
        .update({'is_published': false})
        .eq('id', postId)
        .select()
        .single();

    return PostModel.fromJson(data);
  }

  /// Delete a post
  Future<void> deletePost(String postId) async {
    await supabase.from('posts').delete().eq('id', postId);
  }

  /// Increment view count
  Future<void> incrementViewCount(String postId) async {
    await supabase.rpc('increment', params: {
      'table_name': 'posts',
      'column_name': 'view_count',
      'row_id': postId,
    });
  }

  /// Increment share count
  Future<void> incrementShareCount(String postId) async {
    await supabase.rpc('increment', params: {
      'table_name': 'posts',
      'column_name': 'share_count',
      'row_id': postId,
    });
  }

  /// Like/Unlike a post
  Future<void> likePost({required String postId, required String userId}) async {
    await supabase.from('post_likes').insert({
      'post_id': postId,
      'user_id': userId,
    });
  }

  Future<void> unlikePost({required String postId, required String userId}) async {
    await supabase
        .from('post_likes')
        .delete()
        .eq('post_id', postId)
        .eq('user_id', userId);
  }

  /// Check if user liked a post
  Future<bool> hasUserLikedPost({
    required String postId,
    required String userId,
  }) async {
    final data = await supabase
        .from('post_likes')
        .select('id')
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    return data != null;
  }

  /// Get trending posts (high engagement)
  Future<List<PostModel>> getTrendingPosts({int limit = 10}) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('is_published', true)
        .gte('view_count', 100) // At least 100 views
        .order('view_count', ascending: false)
        .limit(limit);

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Get recent posts (for home screen)
  Future<List<PostModel>> getRecentPosts({int limit = 5}) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          ),
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('is_published', true)
        .order('published_at', ascending: false)
        .limit(limit);

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }

  /// Get related posts (same category, exclude current)
  Future<List<PostModel>> getRelatedPosts({
    required String postId,
    required String categoryId,
    int limit = 5,
  }) async {
    final data = await supabase
        .from('posts')
        .select('''
          *,
          post_categories(
            id,
            name,
            name_mn
          )
        ''')
        .eq('is_published', true)
        .eq('category_id', categoryId)
        .neq('id', postId)
        .order('published_at', ascending: false)
        .limit(limit);

    return (data as List).map((json) => PostModel.fromJson(json)).toList();
  }
}
