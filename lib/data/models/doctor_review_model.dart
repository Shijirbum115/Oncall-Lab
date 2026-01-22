// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bugamed/data/models/profile_model.dart';

part 'doctor_review_model.freezed.dart';
part 'doctor_review_model.g.dart';

@freezed
class DoctorReviewModel with _$DoctorReviewModel {
  const DoctorReviewModel._(); // Private constructor for custom methods

  const factory DoctorReviewModel({
    required String id,
    @JsonKey(name: 'doctor_id') required String doctorId,
    @JsonKey(name: 'patient_id') required String patientId,
    @JsonKey(name: 'test_request_id') String? testRequestId,
    required double rating,
    @JsonKey(name: 'review_title') String? reviewTitle,
    @JsonKey(name: 'review_text') String? reviewText,
    @JsonKey(name: 'professionalism_rating') double? professionalismRating,
    @JsonKey(name: 'punctuality_rating') double? punctualityRating,
    @JsonKey(name: 'communication_rating') double? communicationRating,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'is_visible') @Default(true) bool isVisible,
    @JsonKey(name: 'doctor_response') String? doctorResponse,
    @JsonKey(name: 'responded_at') DateTime? respondedAt,
    @JsonKey(name: 'helpful_count') @Default(0) int helpfulCount,
    @JsonKey(name: 'not_helpful_count') @Default(0) int notHelpfulCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Nested relationships (when fetched with joins)
    ProfileModel? profile, // Patient profile
  }) = _DoctorReviewModel;

  factory DoctorReviewModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorReviewModelFromJson(json);

  // Custom getters
  bool get hasDetailedRatings =>
      professionalismRating != null ||
      punctualityRating != null ||
      communicationRating != null;

  double get averageDetailedRating {
    if (!hasDetailedRatings) return rating;

    final ratings = [
      if (professionalismRating != null) professionalismRating!,
      if (punctualityRating != null) punctualityRating!,
      if (communicationRating != null) communicationRating!,
    ];

    if (ratings.isEmpty) return rating;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  bool get hasDoctorResponse =>
      doctorResponse != null && doctorResponse!.isNotEmpty;

  String get ratingDisplay => rating.toStringAsFixed(1);

  // Check if review is recent (within 7 days)
  bool get isRecent {
    final difference = DateTime.now().difference(createdAt);
    return difference.inDays <= 7;
  }

  // Check if patient can still edit (within 30 days)
  bool get canEdit {
    final difference = DateTime.now().difference(createdAt);
    return difference.inDays <= 30;
  }

  // Get rating emoji
  String get ratingEmoji {
    if (rating >= 4.5) return '⭐️';
    if (rating >= 3.5) return '👍';
    if (rating >= 2.5) return '😐';
    return '👎';
  }

  // Get rating color (for UI)
  String get ratingColorHex {
    if (rating >= 4.5) return '#4CAF50'; // Green
    if (rating >= 3.5) return '#8BC34A'; // Light Green
    if (rating >= 2.5) return '#FFC107'; // Amber
    return '#F44336'; // Red
  }
}
