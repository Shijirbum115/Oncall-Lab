// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doctor_profile_model.freezed.dart';
part 'doctor_profile_model.g.dart';

@freezed
class DoctorProfileModel with _$DoctorProfileModel {
  const factory DoctorProfileModel({
    required String id,
    String? profession,
    @JsonKey(name: 'license_number') required String licenseNumber,
    @JsonKey(name: 'academic_degree') String? academicDegree,
    @JsonKey(name: 'years_of_experience') int? yearsOfExperience,
    @JsonKey(name: 'work_experience_years') int? workExperienceYears,
    @JsonKey(name: 'professional_development') String? professionalDevelopment,
    @JsonKey(name: 'photo_url') String? photoUrl,
    required double rating,
    @JsonKey(name: 'total_reviews') required int totalReviews,
    @JsonKey(name: 'total_completed_requests') required int totalCompletedRequests,
    String? bio,
    dynamic certifications,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'preferred_areas') List<String>? preferredAreas,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DoctorProfileModel;

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileModelFromJson(json);
}
