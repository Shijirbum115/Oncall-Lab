// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_lab/data/models/service_model.dart';

part 'doctor_service_model.freezed.dart';
part 'doctor_service_model.g.dart';

@freezed
class DoctorServiceModel with _$DoctorServiceModel {
  const factory DoctorServiceModel({
    required String id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'price_mnt') required int priceMnt,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships
    @JsonKey(name: 'services') ServiceModel? service,
  }) = _DoctorServiceModel;

  factory DoctorServiceModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorServiceModelFromJson(json);
}
