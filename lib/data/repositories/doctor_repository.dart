import 'package:oncall_lab/core/services/supabase_service.dart';

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
  Future<List<Map<String, dynamic>>> getAvailableDoctors() async {
    final data = await supabase.rpc('get_available_doctors');
    return List<Map<String, dynamic>>.from(data);
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
