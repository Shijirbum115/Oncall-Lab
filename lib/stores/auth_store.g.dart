// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  Computed<bool>? _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<bool>(() => super.isAuthenticated,
              name: '_AuthStore.isAuthenticated'))
          .value;
  Computed<UserRole?>? _$userRoleComputed;

  @override
  UserRole? get userRole =>
      (_$userRoleComputed ??= Computed<UserRole?>(() => super.userRole,
              name: '_AuthStore.userRole'))
          .value;
  Computed<bool>? _$isPatientComputed;

  @override
  bool get isPatient => (_$isPatientComputed ??=
          Computed<bool>(() => super.isPatient, name: '_AuthStore.isPatient'))
      .value;
  Computed<bool>? _$isDoctorComputed;

  @override
  bool get isDoctor => (_$isDoctorComputed ??=
          Computed<bool>(() => super.isDoctor, name: '_AuthStore.isDoctor'))
      .value;
  Computed<bool>? _$isAdminComputed;

  @override
  bool get isAdmin => (_$isAdminComputed ??=
          Computed<bool>(() => super.isAdmin, name: '_AuthStore.isAdmin'))
      .value;

  late final _$currentUserAtom =
      Atom(name: '_AuthStore.currentUser', context: context);

  @override
  User? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(User? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$currentProfileAtom =
      Atom(name: '_AuthStore.currentProfile', context: context);

  @override
  ProfileModel? get currentProfile {
    _$currentProfileAtom.reportRead();
    return super.currentProfile;
  }

  @override
  set currentProfile(ProfileModel? value) {
    _$currentProfileAtom.reportWrite(value, super.currentProfile, () {
      super.currentProfile = value;
    });
  }

  late final _$currentDoctorProfileAtom =
      Atom(name: '_AuthStore.currentDoctorProfile', context: context);

  @override
  DoctorProfileModel? get currentDoctorProfile {
    _$currentDoctorProfileAtom.reportRead();
    return super.currentDoctorProfile;
  }

  @override
  set currentDoctorProfile(DoctorProfileModel? value) {
    _$currentDoctorProfileAtom.reportWrite(value, super.currentDoctorProfile,
        () {
      super.currentDoctorProfile = value;
    });
  }

  late final _$isInitializingAtom =
      Atom(name: '_AuthStore.isInitializing', context: context);

  @override
  bool get isInitializing {
    _$isInitializingAtom.reportRead();
    return super.isInitializing;
  }

  @override
  set isInitializing(bool value) {
    _$isInitializingAtom.reportWrite(value, super.isInitializing, () {
      super.isInitializing = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AuthStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isUpdatingProfileAtom =
      Atom(name: '_AuthStore.isUpdatingProfile', context: context);

  @override
  bool get isUpdatingProfile {
    _$isUpdatingProfileAtom.reportRead();
    return super.isUpdatingProfile;
  }

  @override
  set isUpdatingProfile(bool value) {
    _$isUpdatingProfileAtom.reportWrite(value, super.isUpdatingProfile, () {
      super.isUpdatingProfile = value;
    });
  }

  late final _$isUpdatingAddressAtom =
      Atom(name: '_AuthStore.isUpdatingAddress', context: context);

  @override
  bool get isUpdatingAddress {
    _$isUpdatingAddressAtom.reportRead();
    return super.isUpdatingAddress;
  }

  @override
  set isUpdatingAddress(bool value) {
    _$isUpdatingAddressAtom.reportWrite(value, super.isUpdatingAddress, () {
      super.isUpdatingAddress = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_AuthStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$isUploadingAvatarAtom =
      Atom(name: '_AuthStore.isUploadingAvatar', context: context);

  @override
  bool get isUploadingAvatar {
    _$isUploadingAvatarAtom.reportRead();
    return super.isUploadingAvatar;
  }

  @override
  set isUploadingAvatar(bool value) {
    _$isUploadingAvatarAtom.reportWrite(value, super.isUploadingAvatar, () {
      super.isUploadingAvatar = value;
    });
  }

  late final _$initializeAsyncAction =
      AsyncAction('_AuthStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$loadCurrentProfileAsyncAction =
      AsyncAction('_AuthStore.loadCurrentProfile', context: context);

  @override
  Future<void> loadCurrentProfile() {
    return _$loadCurrentProfileAsyncAction
        .run(() => super.loadCurrentProfile());
  }

  late final _$signInAsyncAction =
      AsyncAction('_AuthStore.signIn', context: context);

  @override
  Future<bool> signIn({required String phoneNumber, required String password}) {
    return _$signInAsyncAction
        .run(() => super.signIn(phoneNumber: phoneNumber, password: password));
  }

  late final _$registerPatientAsyncAction =
      AsyncAction('_AuthStore.registerPatient', context: context);

  @override
  Future<bool> registerPatient(
      {required String phoneNumber,
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
      String? allergies}) {
    return _$registerPatientAsyncAction.run(() => super.registerPatient(
        phoneNumber: phoneNumber,
        password: password,
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
        allergies: allergies));
  }

  late final _$registerDoctorAsyncAction =
      AsyncAction('_AuthStore.registerDoctor', context: context);

  @override
  Future<bool> registerDoctor(
      {required String phoneNumber,
      required String password,
      required String firstName,
      required String lastName,
      String? email,
      required String profession,
      required String licenseNumber,
      String? academicDegree,
      int? workExperienceYears,
      String? professionalDevelopment,
      String? photoUrl}) {
    return _$registerDoctorAsyncAction.run(() => super.registerDoctor(
        phoneNumber: phoneNumber,
        password: password,
        firstName: firstName,
        lastName: lastName,
        email: email,
        profession: profession,
        licenseNumber: licenseNumber,
        academicDegree: academicDegree,
        workExperienceYears: workExperienceYears,
        professionalDevelopment: professionalDevelopment,
        photoUrl: photoUrl));
  }

  late final _$signOutAsyncAction =
      AsyncAction('_AuthStore.signOut', context: context);

  @override
  Future<void> signOut() {
    return _$signOutAsyncAction.run(() => super.signOut());
  }

  late final _$updateProfileAsyncAction =
      AsyncAction('_AuthStore.updateProfile', context: context);

  @override
  Future<bool> updateProfile(
      {required String firstName,
      required String lastName,
      String? email,
      String? permanentAddress,
      String? registrationNumber,
      String? allergies}) {
    return _$updateProfileAsyncAction.run(() => super.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        permanentAddress: permanentAddress,
        registrationNumber: registrationNumber,
        allergies: allergies));
  }

  late final _$uploadProfileAvatarAsyncAction =
      AsyncAction('_AuthStore.uploadProfileAvatar', context: context);

  @override
  Future<bool> uploadProfileAvatar() {
    return _$uploadProfileAvatarAsyncAction
        .run(() => super.uploadProfileAvatar());
  }

  late final _$updateSavedAddressAsyncAction =
      AsyncAction('_AuthStore.updateSavedAddress', context: context);

  @override
  Future<bool> updateSavedAddress(String? address) {
    return _$updateSavedAddressAsyncAction
        .run(() => super.updateSavedAddress(address));
  }

  late final _$_AuthStoreActionController =
      ActionController(name: '_AuthStore', context: context);

  @override
  void clearError() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.clearError');
    try {
      return super.clearError();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser},
currentProfile: ${currentProfile},
currentDoctorProfile: ${currentDoctorProfile},
isInitializing: ${isInitializing},
isLoading: ${isLoading},
isUpdatingProfile: ${isUpdatingProfile},
isUpdatingAddress: ${isUpdatingAddress},
errorMessage: ${errorMessage},
isUploadingAvatar: ${isUploadingAvatar},
isAuthenticated: ${isAuthenticated},
userRole: ${userRole},
isPatient: ${isPatient},
isDoctor: ${isDoctor},
isAdmin: ${isAdmin}
    ''';
  }
}
