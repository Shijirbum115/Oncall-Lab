// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oncall_lab/core/utils/avatar_helper.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

enum UserRole {
  @JsonValue('patient')
  patient,
  @JsonValue('doctor')
  doctor,
  @JsonValue('admin')
  admin,
}

@freezed
class ProfileModel with _$ProfileModel {
  const ProfileModel._(); // Private constructor for custom methods

  const factory ProfileModel({
    required String id,
    required UserRole role,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    String? gender,
    int? age,
    @JsonKey(name: 'permanent_address') String? permanentAddress,
    @JsonKey(name: 'registration_number') String? registrationNumber,
    @JsonKey(name: 'is_mongolian_citizen') bool? isMongolianCitizen,
    @JsonKey(name: 'is_foreign_citizen') bool? isForeignCitizen,
    @JsonKey(name: 'passport_number') String? passportNumber,
    String? allergies,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'is_verified') required bool isVerified,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  // Custom getters and methods
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return fullName ?? phoneNumber;
  }

  /// Get avatar URL - returns custom avatar if set, otherwise returns default avatar
  String getAvatarUrl() {
    // If user has uploaded a custom avatar, use it
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return avatarUrl!;
    }

    // Otherwise, return a default avatar based on gender and role
    return AvatarHelper.getDefaultAvatar(
      gender: gender,
      role: role.name, // 'patient', 'doctor', or 'admin'
      userId: id,
    );
  }

  /// Get initials for avatar fallback
  String get initials {
    if (firstName != null && firstName!.isNotEmpty) {
      return firstName!.substring(0, 1).toUpperCase();
    }
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!.substring(0, 1).toUpperCase();
    }
    return 'U';
  }
}
