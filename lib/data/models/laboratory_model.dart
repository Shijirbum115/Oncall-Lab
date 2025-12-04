// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'laboratory_model.freezed.dart';
part 'laboratory_model.g.dart';

@freezed
class LaboratoryModel with _$LaboratoryModel {
  const factory LaboratoryModel({
    required String id,
    required String name,
    required String address,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    String? email,
    @JsonKey(name: 'operating_hours') Map<String, dynamic>? operatingHours,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _LaboratoryModel;

  factory LaboratoryModel.fromJson(Map<String, dynamic> json) =>
      _$LaboratoryModelFromJson(json);
}
