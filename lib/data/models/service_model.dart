// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_lab/data/models/service_category_model.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    String? description,
    @JsonKey(name: 'sample_type') String? sampleType,
    @JsonKey(name: 'equipment_needed') String? equipmentNeeded,
    @JsonKey(name: 'preparation_instructions') String? preparationInstructions,
    @JsonKey(name: 'estimated_duration_minutes') int? estimatedDurationMinutes,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships (when fetched with joins)
    @JsonKey(name: 'service_categories') ServiceCategoryModel? category,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);
}
