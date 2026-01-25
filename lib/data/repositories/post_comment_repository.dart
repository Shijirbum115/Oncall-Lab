import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/post_comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostCommentRepository {
  /// Get all approved comments for a post (with nested replies)
  Future<List<PostCommentModel>> getCommentsForPost({
    required String postId,
    bool onlyApproved = true,
  }) async {
    var query = supabase
        .from('post_comments')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url,
            role
          )
        ''')
        .eq('post_id', postId)
        .filter('parent_comment_id', 'is', null); // Only get top-level comments

    if (onlyApproved) {
      query = query.eq('is_approved', true).eq('is_visible', true);
    }

    final data = await query.order('created_at', ascending: false);
    
    final comments = (data as List)
        .map((json) => PostCommentModel.fromJson(json))
        .toList();

    // Fetch replies for each comment
    for (var i = 0; i < comments.length; i++) {
      final replies = await getRepliesForComment(comments[i].id);
      // Create a new instance with replies
      comments[i] = comments[i].copyWith(replies: replies);
    }

    return comments;
  }

  /// Get replies for a specific comment
  Future<List<PostCommentModel>> getRepliesForComment(String parentCommentId) async {
    final data = await supabase
        .from('post_comments')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url,
            role
          )
        ''')
        .eq('parent_comment_id', parentCommentId)
        .eq('is_approved', true)
        .eq('is_visible', true)
        .order('created_at', ascending: true);

    return (data as List)
        .map((json) => PostCommentModel.fromJson(json))
        .toList();
  }

  /// Get a specific comment by ID
  Future<PostCommentModel> getCommentById(String commentId) async {
    final data = await supabase
        .from('post_comments')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('id', commentId)
        .single();

    return PostCommentModel.fromJson(data);
  }

  /// Get comments by user
  Future<List<PostCommentModel>> getCommentsByUser({
    required String userId,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await supabase
        .from('post_comments')
        .select('''
          *,
          posts!inner(
            id,
            title,
            title_mn,
            slug
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List)
        .map((json) => PostCommentModel.fromJson(json))
        .toList();
  }

  /// Get pending comments for moderation (Admin only)
  Future<List<PostCommentModel>> getPendingComments({
    int limit = 50,
    int offset = 0,
  }) async {
    final data = await supabase
        .from('post_comments')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url,
            role
          ),
          posts!inner(
            id,
            title,
            title_mn
          )
        ''')
        .eq('is_approved', false)
        .eq('is_visible', true)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List)
        .map((json) => PostCommentModel.fromJson(json))
        .toList();
  }

  /// Create a new comment
  Future<PostCommentModel> createComment({
    required String postId,
    required String userId,
    required String commentText,
    String? parentCommentId,
  }) async {
    final data = await supabase
        .from('post_comments')
        .insert({
          'post_id': postId,
          'user_id': userId,
          'comment_text': commentText,
          'parent_comment_id': parentCommentId,
          'is_approved': false, // Requires moderation by default
          'is_visible': true,
        })
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .single();

    return PostCommentModel.fromJson(data);
  }

  /// Update a comment (user can edit within 15 minutes)
  Future<PostCommentModel> updateComment({
    required String commentId,
    required String commentText,
  }) async {
    final data = await supabase
        .from('post_comments')
        .update({'comment_text': commentText})
        .eq('id', commentId)
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .single();

    return PostCommentModel.fromJson(data);
  }

  /// Delete a comment
  Future<void> deleteComment(String commentId) async {
    // This will cascade delete all replies due to ON DELETE CASCADE
    await supabase.from('post_comments').delete().eq('id', commentId);
  }

  /// Approve a comment (Admin only)
  Future<PostCommentModel> approveComment(String commentId) async {
    final data = await supabase
        .from('post_comments')
        .update({'is_approved': true})
        .eq('id', commentId)
        .select()
        .single();

    return PostCommentModel.fromJson(data);
  }

  /// Reject/Hide a comment (Admin only)
  Future<PostCommentModel> hideComment(String commentId) async {
    final data = await supabase
        .from('post_comments')
        .update({'is_visible': false})
        .eq('id', commentId)
        .select()
        .single();

    return PostCommentModel.fromJson(data);
  }

  /// Bulk approve comments (Admin only)
  Future<void> bulkApproveComments(List<String> commentIds) async {
    await supabase
        .from('post_comments')
        .update({'is_approved': true})
        .filter('id', 'in', commentIds);
  }

  /// Bulk delete comments (Admin only)
  Future<void> bulkDeleteComments(List<String> commentIds) async {
    await supabase.from('post_comments').delete().filter('id', 'in', commentIds);
  }

  /// Get comment count for a post
  Future<int> getCommentCount(String postId) async {
    final count = await supabase
        .from('post_comments')
        .count(CountOption.exact)
        .eq('post_id', postId)
        .eq('is_approved', true)
        .eq('is_visible', true);

    return count;
  }

  /// Get total comment count across all posts
  Future<int> getTotalCommentCount() async {
    final count = await supabase
        .from('post_comments')
        .count(CountOption.exact)
        .eq('is_approved', true)
        .eq('is_visible', true);

    return count;
  }

  /// Get recent comments (for admin dashboard)
  Future<List<PostCommentModel>> getRecentComments({int limit = 10}) async {
    final data = await supabase
        .from('post_comments')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          ),
          posts!inner(
            id,
            title,
            title_mn,
            slug
          )
        ''')
        .eq('is_approved', true)
        .eq('is_visible', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((json) => PostCommentModel.fromJson(json))
        .toList();
  }

  /// Check if user can edit comment (within 15 minutes)
  Future<bool> canUserEditComment({
    required String commentId,
    required String userId,
  }) async {
    final comment = await getCommentById(commentId);

    if (comment.userId != userId) return false;

    final difference = DateTime.now().difference(comment.createdAt);
    return difference.inMinutes <= 15;
  }

  /// Report a comment (for moderation)
  Future<void> reportComment({
    required String commentId,
    required String reportedBy,
    String? reason,
  }) async {
    // You could create a separate comment_reports table for this
    // For now, we'll just hide the comment for review
    await supabase
        .from('post_comments')
        .update({
          'is_visible': false,
          // Could add metadata field to store report info
        })
        .eq('id', commentId);
  }
}