// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_lab/data/models/service_model.dart';

part 'laboratory_service_model.freezed.dart';
part 'laboratory_service_model.g.dart';

@freezed
class LaboratoryServiceModel with _$LaboratoryServiceModel {
  const factory LaboratoryServiceModel({
    required String id,
    @JsonKey(name: 'laboratory_id') required String laboratoryId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'price_mnt') required int priceMnt,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'estimated_duration_hours') int? estimatedDurationHours,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships
    @JsonKey(name: 'services') ServiceModel? service,
  }) = _LaboratoryServiceModel;

  factory LaboratoryServiceModel.fromJson(Map<String, dynamic> json) =>
      _$LaboratoryServiceModelFromJson(json);
}
