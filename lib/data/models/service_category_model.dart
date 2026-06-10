import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_category_model.freezed.dart';
part 'service_category_model.g.dart';

enum ServiceCategoryType {
  @JsonValue('lab_test')
  labTest,
  @JsonValue('diagnostic_procedure')
  diagnosticProcedure,
  @JsonValue('nursing_care')
  nursingCare,
}

@freezed
class ServiceCategoryModel with _$ServiceCategoryModel {
  const factory ServiceCategoryModel({
    required String id,
    required String name,
    required ServiceCategoryType type,
    String? description,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'name_mn') String? nameMn,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'icon_name') String? iconName,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ServiceCategoryModel;

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryModelFromJson(json);
}
