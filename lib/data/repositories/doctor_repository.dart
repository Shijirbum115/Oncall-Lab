import 'package:bugamed/core/services/supabase_service.dart';

class DoctorRepository {
  /// Get full doctor details including profile and services
  Future<Map<String, dynamic>> getDoctorDetails(String doctorId) async {
    // Get doctor profile with joined profile data
    final doctorData = await supabase
        .from('doctor_profiles')
        .select('''
          *,
          profiles(
            id,
            full_name,
            phone_number,
            email,
            permanent_address
          )
        ''')
        .eq('id', doctorId)
        .maybeSingle();

    if (doctorData == null) {
      throw Exception('Doctor profile not found for ID: $doctorId');
    }

    // Get doctor's services with pricing
    final servicesData = await supabase
        .from('doctor_services')
        .select('''
          *,
          services(
            id,
            name,
            description
          )
        ''')
        .eq('doctor_id', doctorId)
        .eq('is_available', true);

    return {
      ...doctorData,
      'doctor_services': servicesData,
    };
  }

  /// Get available doctors (lightweight query for list views)
  Future<List<Map<String, dynamic>>> getAvailableDoctors({
    DateTime? scheduledDate,
    String? scheduledTime,
  }) async {
    final params = <String, dynamic>{};
    
    if (scheduledDate != null) {
      // Format date as YYYY-MM-DD
      params['p_scheduled_date'] = scheduledDate.toIso8601String().split('T')[0];
    }
    
    if (scheduledTime != null) {
      params['p_scheduled_time'] = scheduledTime;
    }
    
    final data = await supabase.rpc('get_available_doctors', params: params);
    return List<Map<String, dynamic>>.from(data);
  }

  /// Toggle whether the doctor appears in the available pool
  Future<void> updateAvailability({
    required String doctorId,
    required bool isAvailable,
  }) async {
    await supabase
        .from('doctor_profiles')
        .update({
          'is_available': isAvailable,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', doctorId);
  }

  /// Get doctor's service pricing
  Future<List<Map<String, dynamic>>> getDoctorServices(String doctorId) async {
    final data = await supabase
        .from('doctor_services')
        .select('''
          *,
          services(
            id,
            name,
            description,
            service_categories(
              id,
              name,
              type
            )
          )
        ''')
        .eq('doctor_id', doctorId)
        .eq('is_available', true)
        .order('services(name)');

    return List<Map<String, dynamic>>.from(data);
  }
}
