// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bugamed/data/models/profile_model.dart';

part 'post_like_model.freezed.dart';
part 'post_like_model.g.dart';

@freezed
class PostLikeModel with _$PostLikeModel {
  const factory PostLikeModel({
    required String id,
    @JsonKey(name: 'post_id') required String postId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Nested relationships (when fetched with joins)
    ProfileModel? profile,
  }) = _PostLikeModel;

  factory PostLikeModel.fromJson(Map<String, dynamic> json) =>
      _$PostLikeModelFromJson(json);
}
