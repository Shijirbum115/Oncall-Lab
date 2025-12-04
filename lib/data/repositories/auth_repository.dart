import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/profile_model.dart';
import 'package:oncall_lab/data/models/doctor_profile_model.dart';

class AuthRepository {
  static const String _phoneEmailDomain = 'oncalllab.dev';

  String _buildEmailFromPhone(String phoneNumber) {
    var sanitized = phoneNumber.replaceAll(' ', '');

    // Support both legacy "+976XXXXXXXX" and new "XXXXXXXX" format
    if (sanitized.startsWith('+976')) {
      sanitized = sanitized.substring(4);
    }

    return '$sanitized@$_phoneEmailDomain';
  }

  /// Sign up with phone and password (email-based auth since Supabase web doesn't support phone on localhost)
  Future<User> signUp({
    required String phoneNumber,
    required String password,
  }) async {
    // Use email-based auth for web (phone@oncalllab.dev, e.g., 99123456@oncalllab.dev)
    final email = _buildEmailFromPhone(phoneNumber);

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Failed to create user');
    }

    return response.user!;
  }

  /// Sign in with phone and password
  Future<User> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    final email = _buildEmailFromPhone(phoneNumber);

    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Failed to sign in');
    }

    return response.user!;
  }

  /// Create patient profile
  Future<ProfileModel> createPatientProfile({
    required String userId,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    String? email,
    int? age,
    String? gender,
    required String permanentAddress,
    String? registrationNumber,
    required bool isMongolianCitizen,
    required bool isForeignCitizen,
    String? passportNumber,
    String? allergies,
  }) async {
    final profileData = {
      'id': userId,
      'role': 'patient',
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': '$firstName $lastName',
      'email': email,
      'age': age,
      'gender': gender,
      'permanent_address': permanentAddress,
      'registration_number': registrationNumber,
      'is_mongolian_citizen': isMongolianCitizen,
      'is_foreign_citizen': isForeignCitizen,
      'passport_number': passportNumber,
      'allergies': allergies,
      'is_active': true,
      'is_verified': true, // Auto-verify patients
    };

    final data = await supabase
        .from('profiles')
        .insert(profileData)
        .select()
        .single();

    return ProfileModel.fromJson(data);
  }

  /// Create doctor profile
  Future<Map<String, dynamic>> createDoctorProfile({
    required String userId,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    String? email,
    required String profession,
    required String licenseNumber,
    String? academicDegree,
    int? workExperienceYears,
    String? professionalDevelopment,
    String? photoUrl,
  }) async {
    // Create base profile
    final profileData = {
      'id': userId,
      'role': 'doctor',
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': '$firstName $lastName',
      'email': email,
      'is_active': true,
      'is_verified': false, // Doctors need admin verification
    };

    final profile = await supabase
        .from('profiles')
        .insert(profileData)
        .select()
        .single();

    // Create doctor profile
    final doctorProfileData = {
      'id': userId,
      'profession': profession,
      'license_number': licenseNumber,
      'academic_degree': academicDegree,
      'work_experience_years': workExperienceYears,
      'professional_development': professionalDevelopment,
      'photo_url': photoUrl,
      'rating': 0.0,
      'total_reviews': 0,
      'total_completed_requests': 0,
      'is_available': false, // Set to false until verified
    };

    final doctorProfile = await supabase
        .from('doctor_profiles')
        .insert(doctorProfileData)
        .select()
        .single();

    return {
      'profile': ProfileModel.fromJson(profile),
      'doctor_profile': DoctorProfileModel.fromJson(doctorProfile),
    };
  }

  /// Get current user profile
  Future<ProfileModel?> getCurrentProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return ProfileModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Get doctor profile
  Future<DoctorProfileModel?> getDoctorProfile(String userId) async {
    try {
      final data = await supabase
          .from('doctor_profiles')
          .select()
          .eq('id', userId)
          .single();

      return DoctorProfileModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /// Update current user profile fields
  Future<ProfileModel> updateProfile({
    required String userId,
    required String firstName,
    required String lastName,
    String? email,
    String? permanentAddress,
    String? registrationNumber,
    String? allergies,
  }) async {
    final updateData = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'full_name': '$firstName $lastName'.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (email != null) {
      updateData['email'] = email.isEmpty ? null : email;
    }
    if (permanentAddress != null) {
      updateData['permanent_address'] =
          permanentAddress.isEmpty ? null : permanentAddress;
    }
    if (registrationNumber != null) {
      updateData['registration_number'] =
          registrationNumber.isEmpty ? null : registrationNumber;
    }
    if (allergies != null) {
      updateData['allergies'] = allergies.isEmpty ? null : allergies;
    }

    final data = await supabase
        .from('profiles')
        .update(updateData)
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(data);
  }

  /// Get current user
  User? get currentUser => supabase.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => supabase.auth.currentUser != null;
}
