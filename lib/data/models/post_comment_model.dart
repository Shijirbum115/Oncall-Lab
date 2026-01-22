// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bugamed/data/models/profile_model.dart';

part 'post_comment_model.freezed.dart';
part 'post_comment_model.g.dart';

@freezed
class PostCommentModel with _$PostCommentModel {
  const PostCommentModel._(); // Private constructor for custom methods

  const factory PostCommentModel({
    required String id,
    @JsonKey(name: 'post_id') required String postId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'parent_comment_id') String? parentCommentId,
    @JsonKey(name: 'comment_text') required String commentText,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'is_visible') @Default(true) bool isVisible,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships (when fetched with joins)
    ProfileModel? profile, // Commenter profile
    List<PostCommentModel>? replies, // Child comments
  }) = _PostCommentModel;

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentModelFromJson(json);

  // Check if this is a reply to another comment
  bool get isReply => parentCommentId != null;

  // Check if comment has replies
  bool get hasReplies => replies != null && replies!.isNotEmpty;

  // Get reply count
  int get replyCount => replies?.length ?? 0;

  // Check if comment is new (within 24 hours)
  bool get isNew {
    final difference = DateTime.now().difference(createdAt);
    return difference.inHours <= 24;
  }

  // Check if comment can be edited (within 15 minutes)
  bool get canEdit {
    final difference = DateTime.now().difference(createdAt);
    return difference.inMinutes <= 15;
  }

  // Get display time
  String get displayTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Яг одоо';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} минутын өмнө';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} цагийн өмнө';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} өдрийн өмнө';
    } else {
      return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
    }
  }
}
