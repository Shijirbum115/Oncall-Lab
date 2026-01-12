// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_category_model.freezed.dart';
part 'post_category_model.g.dart';

@freezed
class PostCategoryModel with _$PostCategoryModel {
  const PostCategoryModel._(); // Private constructor for custom methods

  const factory PostCategoryModel({
    required String id,
    required String name,
    @JsonKey(name: 'name_mn') String? nameMn,
    String? description,
    @JsonKey(name: 'icon_name') String? iconName,
    @JsonKey(name: 'color_hex') String? colorHex,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _PostCategoryModel;

  factory PostCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$PostCategoryModelFromJson(json);

  // Get localized name (Mongolian if available, otherwise English)
  String getLocalizedName({bool preferMongolian = true}) {
    if (preferMongolian && nameMn != null && nameMn!.isNotEmpty) {
      return nameMn!;
    }
    return name;
  }

  // Get color with default fallback
  String get displayColor => colorHex ?? '#665ACF';

  // Get icon with default fallback
  String get displayIcon => iconName ?? 'article';
}
