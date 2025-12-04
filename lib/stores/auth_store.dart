import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oncall_lab/data/repositories/auth_repository.dart';
import 'package:oncall_lab/data/models/profile_model.dart';
import 'package:oncall_lab/data/models/doctor_profile_model.dart';
import 'package:oncall_lab/core/services/storage_service.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  _AuthStore(this._repository);

  final AuthRepository _repository;

  @observable
  User? currentUser;

  @observable
  ProfileModel? currentProfile;

  @observable
  DoctorProfileModel? currentDoctorProfile;

  @observable
  bool isInitializing = true;

  @observable
  bool isLoading = false;

  @observable
  bool isUpdatingProfile = false;

  @observable
  bool isUpdatingAddress = false;

  @observable
  String? errorMessage;

  @observable
  bool isUploadingAvatar = false;

  @computed
  bool get isAuthenticated => currentUser != null && currentProfile != null;

  @computed
  UserRole? get userRole => currentProfile?.role;

  @computed
  bool get isPatient => userRole == UserRole.patient;

  @computed
  bool get isDoctor => userRole == UserRole.doctor;

  @computed
  bool get isAdmin => userRole == UserRole.admin;

  @action
  Future<void> initialize() async {
    isInitializing = true;
    try {
      currentUser = _repository.currentUser;
      if (currentUser != null) {
        await loadCurrentProfile();
      } else {
        currentProfile = null;
        currentDoctorProfile = null;
      }
    } finally {
      isInitializing = false;
    }
  }

  @action
  Future<void> loadCurrentProfile() async {
    try {
      currentProfile = await _repository.getCurrentProfile();

      if (currentProfile?.role == UserRole.doctor) {
        currentDoctorProfile =
            await _repository.getDoctorProfile(currentUser!.id);
      }
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  @action
  Future<bool> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      currentUser = await _repository.signIn(
        phoneNumber: phoneNumber,
        password: password,
      );

      await loadCurrentProfile();

      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = _getErrorMessage(e);
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> registerPatient({
    required String phoneNumber,
    required String password,
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
    isLoading = true;
    errorMessage = null;

    try {
      // Create auth user
      currentUser = await _repository.signUp(
        phoneNumber: phoneNumber,
        password: password,
      );

      // Create profile
      currentProfile = await _repository.createPatientProfile(
        userId: currentUser!.id,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        email: email,
        age: age,
        gender: gender,
        permanentAddress: permanentAddress,
        registrationNumber: registrationNumber,
        isMongolianCitizen: isMongolianCitizen,
        isForeignCitizen: isForeignCitizen,
        passportNumber: passportNumber,
        allergies: allergies,
      );

      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = _getErrorMessage(e);
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> registerDoctor({
    required String phoneNumber,
    required String password,
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
    isLoading = true;
    errorMessage = null;

    try {
      // Create auth user
      currentUser = await _repository.signUp(
        phoneNumber: phoneNumber,
        password: password,
      );

      // Create profiles
      final result = await _repository.createDoctorProfile(
        userId: currentUser!.id,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profession: profession,
        licenseNumber: licenseNumber,
        academicDegree: academicDegree,
        workExperienceYears: workExperienceYears,
        professionalDevelopment: professionalDevelopment,
        photoUrl: photoUrl,
      );

      currentProfile = result['profile'] as ProfileModel;
      currentDoctorProfile = result['doctor_profile'] as DoctorProfileModel;

      isLoading = false;
      return true;
    } catch (e) {
      errorMessage = _getErrorMessage(e);
      isLoading = false;
      return false;
    }
  }

  @action
  Future<void> signOut() async {
    await _repository.signOut();
    currentUser = null;
    currentProfile = null;
    currentDoctorProfile = null;
    errorMessage = null;
  }

  @action
  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? email,
    String? permanentAddress,
    String? registrationNumber,
    String? allergies,
  }) async {
    if (currentUser == null) return false;

    isUpdatingProfile = true;
    errorMessage = null;

    try {
      final updatedProfile = await _repository.updateProfile(
        userId: currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        permanentAddress: permanentAddress,
        registrationNumber: registrationNumber,
        allergies: allergies,
      );

      currentProfile = updatedProfile;
      isUpdatingProfile = false;
      return true;
    } catch (e) {
      errorMessage = _getErrorMessage(e);
      isUpdatingProfile = false;
      return false;
    }
  }

  @action
  Future<bool> uploadProfileAvatar() async {
    final user = currentUser;
    if (user == null) return false;

    isUploadingAvatar = true;
    errorMessage = null;

    try {
      final file = await StorageService.pickImage();
      if (file == null) {
        isUploadingAvatar = false;
        return false;
      }

      final url = await StorageService.uploadProfilePhoto(
        userId: user.id,
        file: file,
      );

      if (url == null) {
        throw Exception('Failed to upload avatar');
      }

      // Persist avatar URL directly on the profile record, with cache buster
      final cacheBustedUrl =
          '$url?t=${DateTime.now().millisecondsSinceEpoch}';
      await supabase
          .from('profiles')
          .update({
            'avatar_url': cacheBustedUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);

      // Reload profile to ensure all fields are in sync
      await loadCurrentProfile();

      isUploadingAvatar = false;
      return true;
    } catch (e) {
      errorMessage = _getErrorMessage(e);
      isUploadingAvatar = false;
      return false;
    }
  }

  @action
  Future<bool> updateSavedAddress(String? address) async {
    final profile = currentProfile;
    if (profile == null) return false;

    String resolveFirstName() {
      if (profile.firstName != null && profile.firstName!.isNotEmpty) {
        return profile.firstName!;
      }
      final full = profile.fullName?.trim();
      if (full != null && full.isNotEmpty) {
        final parts = full.split(RegExp(r'\s+'));
        if (parts.isNotEmpty) {
          return parts.first;
        }
      }
      return 'User';
    }

    String resolveLastName() {
      if (profile.lastName != null && profile.lastName!.isNotEmpty) {
        return profile.lastName!;
      }
      final full = profile.fullName?.trim();
      if (full != null && full.isNotEmpty) {
        final parts = full.split(RegExp(r'\s+'));
        if (parts.length > 1) {
          return parts.sublist(1).join(' ');
        }
      }
      return profile.firstName ?? 'User';
    }

    isUpdatingAddress = true;
    errorMessage = null;

    try {
      final success = await updateProfile(
        firstName: resolveFirstName(),
        lastName: resolveLastName(),
        email: null,
        permanentAddress: address,
        registrationNumber: null,
        allergies: null,
      );
      isUpdatingAddress = false;
      return success;
    } finally {
      isUpdatingAddress = false;
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid phone number or password';
        case 'User already registered':
          return 'This phone number is already registered';
        case 'Email rate limit exceeded':
          return 'Too many attempts. Please try again later';
        default:
          return error.message;
      }
    } else if (error is PostgrestException) {
      if (error.code == '23505') {
        return 'This phone number is already registered';
      }
      return 'Database error: ${error.message}';
    }
    return error.toString();
  }
}

final GetIt _getIt = GetIt.instance;

AuthStore get authStore => _getIt<AuthStore>();
