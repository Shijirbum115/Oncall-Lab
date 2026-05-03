import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/services/storage_service.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/auth/widgets/step_progress_bar.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({super.key});

  @override
  State<DoctorRegistrationScreen> createState() =>
      _DoctorRegistrationScreenState();
}

class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final int _totalSteps = 3;
  int _currentStep = 0;
  late final List<GlobalKey<FormState>> _stepFormKeys =
      List.generate(_totalSteps, (_) => GlobalKey<FormState>());
  final List<IconData> _stepIcons = const [
    Icons.person_outline,
    Icons.medical_information_outlined,
    Icons.lock_outline,
  ];

  List<String> _getStepLabels(AppLocalizations l10n) => [
        l10n.profileStep,
        l10n.professionalStep,
        l10n.securityStep,
      ];

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _professionController = TextEditingController();
  final _licenseController = TextEditingController();
  final _academicDegreeController = TextEditingController();
  final _experienceController = TextEditingController();
  final _developmentController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  File? _selectedProfilePhoto;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _professionController.dispose();
    _licenseController.dispose();
    _academicDegreeController.dispose();
    _experienceController.dispose();
    _developmentController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    final currentForm = _stepFormKeys[_currentStep].currentState;
    if (currentForm == null) return;
    if (currentForm.validate()) {
      FocusScope.of(context).unfocus();
      if (_currentStep < _totalSteps - 1) {
        setState(() => _currentStep++);
      } else {
        _handleRegister();
      }
    }
  }

  void _goToPreviousStep() {
    if (_currentStep == 0) return;
    FocusScope.of(context).unfocus();
    setState(() => _currentStep--);
  }

  Future<void> _handleRegister() async {
    final l10n = AppLocalizations.of(context)!;
    final success = await authStore.registerDoctor(
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      profession: _professionController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      academicDegree: _academicDegreeController.text.trim().isEmpty
          ? null
          : _academicDegreeController.text.trim(),
      workExperienceYears: _experienceController.text.trim().isEmpty
          ? null
          : int.tryParse(_experienceController.text.trim()),
      professionalDevelopment: _developmentController.text.trim().isEmpty
          ? null
          : _developmentController.text.trim(),
      photoUrl: null,
    );

    if (!mounted) return;
    if (success) {
      // Optional profile photo upload after account creation
      if (_selectedProfilePhoto != null) {
        try {
          final userId = authStore.currentUser?.id;
          if (userId != null) {
            final url = await StorageService.uploadProfilePhoto(
              userId: userId,
              file: _selectedProfilePhoto!,
            );
            if (url != null) {
              final cacheBustedUrl =
                  '$url?t=${DateTime.now().millisecondsSinceEpoch}';
              await supabase
                  .from('profiles')
                  .update({
                    'avatar_url': cacheBustedUrl,
                    'updated_at': DateTime.now().toIso8601String(),
                  })
                  .eq('id', userId);

              await supabase
                  .from('doctor_profiles')
                  .update({
                    'photo_url': cacheBustedUrl,
                    'updated_at': DateTime.now().toIso8601String(),
                  })
                  .eq('id', userId);

              await authStore.loadCurrentProfile();
            }
          }
        } catch (_) {
          // Ignore upload errors here; application already submitted
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.doctorApplicationSubmitted),
        ),
      );
      Navigator.of(context).pop();
    } else if (authStore.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authStore.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Keyboard overlays instead of pushing
      appBar: AppBar(
        title: Text(l10n.doctorRegistration),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Scrollable content area
          Positioned.fill(
            bottom: 120 + bottomPadding, // Space for bottom buttons
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.joinAsDoctorLabTech,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.provideAccurateDetails,
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 24),
                  StepProgressBar(
                    totalSteps: _totalSteps,
                    currentStep: _currentStep,
                    icons: _stepIcons,
                    labels: _getStepLabels(l10n),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Form(
                      key: _stepFormKeys[_currentStep],
                      child: KeyedSubtree(
                        key: ValueKey(_currentStep),
                        child: _buildStepContent(_currentStep, l10n),
                      ),
                    ),
                  ),
                  // Extra padding for keyboard
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 200 : 0),
                ],
              ),
            ),
          ),
          // Fixed bottom buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                authStore.isLoading ? null : _goToPreviousStep,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(l10n.back),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        child: Observer(
                          builder: (_) => ElevatedButton(
                            onPressed: authStore.isLoading ? null : _goToNextStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: authStore.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    _currentStep == _totalSteps - 1
                                        ? l10n.submitApplication
                                        : l10n.continue_,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.alreadyRegisteredSignIn),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step, AppLocalizations l10n) {
    switch (step) {
      case 0:
        return _buildIdentityStep(l10n);
      case 1:
        return _buildProfessionalStep(l10n);
      case 2:
      default:
        return _buildSecurityStep(l10n);
    }
  }

  Widget _buildIdentityStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _firstNameController,
                decoration: _buildInputDecoration(
                  l10n.firstNameRequired,
                  Icons.person_outline,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? l10n.required : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: _buildInputDecoration(
                  l10n.lastNameRequired,
                  Icons.person_outline,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? l10n.required : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: _buildInputDecoration(
            l10n.phoneNumberRequired,
            Icons.phone_outlined,
            hint: '99123456',
          ),
          validator: (value) {
            final v = value?.trim() ?? '';
            if (v.isEmpty) return l10n.required;
            if (v.length != 8 || int.tryParse(v) == null) {
              return l10n.enterValidPhoneNumber;
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration(
            l10n.emailOptional,
            Icons.email_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: _professionController,
          decoration: _buildInputDecoration(
            l10n.professionRequired,
            Icons.medical_services_outlined,
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? l10n.required : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _licenseController,
          decoration: _buildInputDecoration(
            l10n.licenseNumberRequired,
            Icons.badge_outlined,
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? l10n.required : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _academicDegreeController,
          decoration: _buildInputDecoration(
            l10n.academicDegreeOptional,
            Icons.school_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration(
            l10n.yearsOfExperience,
            Icons.timeline_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _developmentController,
          maxLines: 2,
          decoration: _buildInputDecoration(
            l10n.professionalDevelopmentOptional,
            Icons.menu_book_outlined,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.profilePhotoOptional,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: _selectedProfilePhoto != null
                  ? FileImage(_selectedProfilePhoto!)
                  : null,
              child: _selectedProfilePhoto == null
                  ? const Icon(
                      Icons.camera_alt,
                      color: AppColors.primary,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final file = await StorageService.pickImage();
                  if (file != null) {
                    setState(() {
                      _selectedProfilePhoto = file;
                    });
                  }
                },
                icon: const Icon(Icons.upload),
                label: Text(
                  _selectedProfilePhoto == null
                      ? l10n.uploadProfilePhoto
                      : l10n.changePhoto,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _buildInputDecoration(
            l10n.passwordRequired,
            Icons.lock_outline,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.required;
            }
            if (value.length < 6) {
              return l10n.passwordMinLength;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: _buildInputDecoration(
            l10n.confirmPasswordRequired,
            Icons.lock_outline,
          ).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.primary,
              ),
              onPressed: () {
                setState(() =>
                    _obscureConfirmPassword = !_obscureConfirmPassword);
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.required;
            }
            if (value != _passwordController.text) {
              return l10n.passwordsMustMatch;
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon,
      {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
    );
  }
}
