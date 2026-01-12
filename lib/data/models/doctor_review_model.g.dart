// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DoctorReviewModelImpl _$$DoctorReviewModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DoctorReviewModelImpl(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String,
      patientId: json['patient_id'] as String,
      testRequestId: json['test_request_id'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewTitle: json['review_title'] as String?,
      reviewText: json['review_text'] as String?,
      professionalismRating:
          (json['professionalism_rating'] as num?)?.toDouble(),
      punctualityRating: (json['punctuality_rating'] as num?)?.toDouble(),
      communicationRating: (json['communication_rating'] as num?)?.toDouble(),
      isVerified: json['is_verified'] as bool? ?? false,
      isVisible: json['is_visible'] as bool? ?? true,
      doctorResponse: json['doctor_response'] as String?,
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at'] as String),
      helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
      notHelpfulCount: (json['not_helpful_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DoctorReviewModelImplToJson(
        _$DoctorReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'patient_id': instance.patientId,
      'test_request_id': instance.testRequestId,
      'rating': instance.rating,
      'review_title': instance.reviewTitle,
      'review_text': instance.reviewText,
      'professionalism_rating': instance.professionalismRating,
      'punctuality_rating': instance.punctualityRating,
      'communication_rating': instance.communicationRating,
      'is_verified': instance.isVerified,
      'is_visible': instance.isVisible,
      'doctor_response': instance.doctorResponse,
      'responded_at': instance.respondedAt?.toIso8601String(),
      'helpful_count': instance.helpfulCount,
      'not_helpful_count': instance.notHelpfulCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'profile': instance.profile,
    };
