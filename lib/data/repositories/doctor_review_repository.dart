import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/doctor_review_model.dart';

class DoctorReviewRepository {
  /// Get all reviews for a specific doctor
  Future<List<DoctorReviewModel>> getReviewsForDoctor({
    required String doctorId,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await supabase
        .from('doctor_reviews')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('doctor_id', doctorId)
        .eq('is_visible', true)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List)
        .map((json) => DoctorReviewModel.fromJson(json))
        .toList();
  }

  /// Get reviews using database function (optimized query)
  Future<List<Map<String, dynamic>>> getReviewsForDoctorOptimized({
    required String doctorId,
    int limit = 20,
    int offset = 0,
  }) async {
    final data = await supabase.rpc('get_doctor_reviews', params: {
      'p_doctor_id': doctorId,
      'p_limit': limit,
      'p_offset': offset,
    });

    return List<Map<String, dynamic>>.from(data);
  }

  /// Get reviews written by a specific patient
  Future<List<DoctorReviewModel>> getReviewsByPatient(String patientId) async {
    final data = await supabase
        .from('doctor_reviews')
        .select('''
          *,
          doctor_profiles(
            id,
            profession
          ),
          profiles!doctor_reviews_doctor_id_fkey(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('patient_id', patientId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((json) => DoctorReviewModel.fromJson(json))
        .toList();
  }

  /// Get a specific review by ID
  Future<DoctorReviewModel> getReviewById(String reviewId) async {
    final data = await supabase
        .from('doctor_reviews')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          )
        ''')
        .eq('id', reviewId)
        .single();

    return DoctorReviewModel.fromJson(data);
  }

  /// Check if patient can review a doctor for a specific request
  Future<bool> canPatientReviewDoctor({
    required String patientId,
    required String doctorId,
    required String testRequestId,
  }) async {
    final result = await supabase.rpc('can_patient_review_doctor', params: {
      'p_patient_id': patientId,
      'p_doctor_id': doctorId,
      'p_test_request_id': testRequestId,
    });

    return result as bool;
  }

  /// Create a new review (Patient only)
  Future<DoctorReviewModel> createReview({
    required String doctorId,
    required String patientId,
    required String testRequestId,
    required double rating,
    String? reviewTitle,
    String? reviewText,
    double? professionalismRating,
    double? punctualityRating,
    double? communicationRating,
  }) async {
    final data = await supabase
        .from('doctor_reviews')
        .insert({
          'doctor_id': doctorId,
          'patient_id': patientId,
          'test_request_id': testRequestId,
          'rating': rating,
          'review_title': reviewTitle,
          'review_text': reviewText,
          'professionalism_rating': professionalismRating,
          'punctuality_rating': punctualityRating,
          'communication_rating': communicationRating,
          'is_verified': true, // Auto-verified since linked to test_request
        })
        .select()
        .single();

    return DoctorReviewModel.fromJson(data);
  }

  /// Update a review (Patient can update within 30 days)
  Future<DoctorReviewModel> updateReview({
    required String reviewId,
    double? rating,
    String? reviewTitle,
    String? reviewText,
    double? professionalismRating,
    double? punctualityRating,
    double? communicationRating,
  }) async {
    final updateData = <String, dynamic>{};
    if (rating != null) updateData['rating'] = rating;
    if (reviewTitle != null) updateData['review_title'] = reviewTitle;
    if (reviewText != null) updateData['review_text'] = reviewText;
    if (professionalismRating != null) {
      updateData['professionalism_rating'] = professionalismRating;
    }
    if (punctualityRating != null) {
      updateData['punctuality_rating'] = punctualityRating;
    }
    if (communicationRating != null) {
      updateData['communication_rating'] = communicationRating;
    }

    final data = await supabase
        .from('doctor_reviews')
        .update(updateData)
        .eq('id', reviewId)
        .select()
        .single();

    return DoctorReviewModel.fromJson(data);
  }

  /// Add doctor response to a review (Doctor only)
  Future<DoctorReviewModel> addDoctorResponse({
    required String reviewId,
    required String doctorResponse,
  }) async {
    final data = await supabase
        .from('doctor_reviews')
        .update({
          'doctor_response': doctorResponse,
          'responded_at': DateTime.now().toIso8601String(),
        })
        .eq('id', reviewId)
        .select()
        .single();

    return DoctorReviewModel.fromJson(data);
  }

  /// Mark review as helpful
  Future<void> markReviewHelpful(String reviewId) async {
    await supabase.rpc('increment', params: {
      'table_name': 'doctor_reviews',
      'column_name': 'helpful_count',
      'row_id': reviewId,
    });
  }

  /// Mark review as not helpful
  Future<void> markReviewNotHelpful(String reviewId) async {
    await supabase.rpc('increment', params: {
      'table_name': 'doctor_reviews',
      'column_name': 'not_helpful_count',
      'row_id': reviewId,
    });
  }

  /// Hide/unhide review (Admin only)
  Future<DoctorReviewModel> setReviewVisibility({
    required String reviewId,
    required bool isVisible,
  }) async {
    final data = await supabase
        .from('doctor_reviews')
        .update({'is_visible': isVisible})
        .eq('id', reviewId)
        .select()
        .single();

    return DoctorReviewModel.fromJson(data);
  }

  /// Delete a review (Admin only, or patient within edit window)
  Future<void> deleteReview(String reviewId) async {
    await supabase.from('doctor_reviews').delete().eq('id', reviewId);
  }

  /// Get review statistics for a doctor
  Future<Map<String, dynamic>> getReviewStatistics(String doctorId) async {
    final data = await supabase
        .from('doctor_reviews')
        .select('rating, professionalism_rating, punctuality_rating, communication_rating')
        .eq('doctor_id', doctorId)
        .eq('is_visible', true);

    final reviews = data as List;
    if (reviews.isEmpty) {
      return {
        'total_reviews': 0,
        'average_rating': 0.0,
        'average_professionalism': 0.0,
        'average_punctuality': 0.0,
        'average_communication': 0.0,
        'rating_distribution': {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0},
      };
    }

    double avgRating = 0.0;
    double avgProfessionalism = 0.0;
    double avgPunctuality = 0.0;
    double avgCommunication = 0.0;
    int profCount = 0, punctCount = 0, commCount = 0;

    final ratingDist = {'5': 0, '4': 0, '3': 0, '2': 0, '1': 0};

    for (var review in reviews) {
      final rating = (review['rating'] as num).toDouble();
      avgRating += rating;

      // Count rating distribution
      final ratingInt = rating.round();
      ratingDist[ratingInt.toString()] = (ratingDist[ratingInt.toString()] ?? 0) + 1;

      if (review['professionalism_rating'] != null) {
        avgProfessionalism += (review['professionalism_rating'] as num).toDouble();
        profCount++;
      }
      if (review['punctuality_rating'] != null) {
        avgPunctuality += (review['punctuality_rating'] as num).toDouble();
        punctCount++;
      }
      if (review['communication_rating'] != null) {
        avgCommunication += (review['communication_rating'] as num).toDouble();
        commCount++;
      }
    }

    return {
      'total_reviews': reviews.length,
      'average_rating': avgRating / reviews.length,
      'average_professionalism': profCount > 0 ? avgProfessionalism / profCount : 0.0,
      'average_punctuality': punctCount > 0 ? avgPunctuality / punctCount : 0.0,
      'average_communication': commCount > 0 ? avgCommunication / commCount : 0.0,
      'rating_distribution': ratingDist,
    };
  }

  /// Get recent reviews (for home screen / featured reviews)
  Future<List<DoctorReviewModel>> getRecentReviews({int limit = 10}) async {
    final data = await supabase
        .from('doctor_reviews')
        .select('''
          *,
          profile:profiles(
            id,
            full_name,
            avatar_url
          ),
          doctor_profiles!inner(
            id,
            profession
          )
        ''')
        .eq('is_visible', true)
        .gte('rating', 4.0) // Only show good reviews on home
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((json) => DoctorReviewModel.fromJson(json))
        .toList();
  }
}
