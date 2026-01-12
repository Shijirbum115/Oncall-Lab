// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_lab/data/models/doctor_profile_model.dart';
import 'package:oncall_lab/data/models/profile_model.dart';

part 'laboratory_technician_model.freezed.dart';
part 'laboratory_technician_model.g.dart';

@freezed
class LaboratoryTechnicianModel with _$LaboratoryTechnicianModel {
  const factory LaboratoryTechnicianModel({
    required String id,
    @JsonKey(name: 'laboratory_id') required String laboratoryId,
    @JsonKey(name: 'technician_id') required String technicianId,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_primary_technician') @Default(false) bool isPrimaryTechnician,
    @JsonKey(name: 'employment_start_date') String? employmentStartDate,
    @JsonKey(name: 'employment_end_date') String? employmentEndDate,
    @JsonKey(name: 'can_collect_samples') @Default(true) bool canCollectSamples,
    @JsonKey(name: 'can_perform_tests') @Default(true) bool canPerformTests,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships (when fetched with joins)
    @JsonKey(name: 'doctor_profiles') DoctorProfileModel? doctorProfile,
    ProfileModel? profile,
  }) = _LaboratoryTechnicianModel;

  factory LaboratoryTechnicianModel.fromJson(Map<String, dynamic> json) =>
      _$LaboratoryTechnicianModelFromJson(json);
}
