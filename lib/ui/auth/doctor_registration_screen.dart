import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/services/storage_service.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/ui/auth/widgets/step_progress_bar.dart';

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
  final List<String> _stepLabels = const [
    'Profile',
    'Professional',
    'Security',
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Doctor application submitted! We will verify your credentials soon.',
          ),
        ),
      );
      Navigator.of(context).pop();
    } else if (authStore.errorMessage != null) {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Doctor Registration'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Join as Doctor / Lab Technician',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Provide accurate details to pass verification.',
                style: TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 24),
              StepProgressBar(
                totalSteps: _totalSteps,
                currentStep: _currentStep,
                icons: _stepIcons,
                labels: _stepLabels,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: Form(
                    key: _stepFormKeys[_currentStep],
                    child: SingleChildScrollView(
                      key: ValueKey(_currentStep),
                      physics: const BouncingScrollPhysics(),
                      child: _buildStepContent(_currentStep),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                        child: const Text('Back'),
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
                                    ? 'Submit Application'
                                    : 'Continue',
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
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Already registered? Sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildIdentityStep();
      case 1:
        return _buildProfessionalStep();
      case 2:
      default:
        return _buildSecurityStep();
    }
  }

  Widget _buildIdentityStep() {
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
                  'First name *',
                  Icons.person_outline,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: _buildInputDecoration(
                  'Last name *',
                  Icons.person_outline,
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: _buildInputDecoration(
            'Phone number *',
            Icons.phone_outlined,
            hint: '99123456',
          ),
          validator: (value) {
            final v = value?.trim() ?? '';
            if (v.isEmpty) return 'Required';
            if (v.length != 8 || int.tryParse(v) == null) {
              return 'Enter 8 digit number (e.g. 99123456)';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildInputDecoration(
            'Email (optional)',
            Icons.email_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: _professionController,
          decoration: _buildInputDecoration(
            'Profession *',
            Icons.medical_services_outlined,
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _licenseController,
          decoration: _buildInputDecoration(
            'License number *',
            Icons.badge_outlined,
          ),
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _academicDegreeController,
          decoration: _buildInputDecoration(
            'Academic degree (optional)',
            Icons.school_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration(
            'Years of experience',
            Icons.timeline_outlined,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _developmentController,
          maxLines: 2,
          decoration: _buildInputDecoration(
            'Professional development (optional)',
            Icons.menu_book_outlined,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Profile photo (optional)',
          style: TextStyle(fontWeight: FontWeight.w600),
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
                      ? 'Upload profile photo'
                      : 'Change photo',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecurityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _buildInputDecoration(
            'Password *',
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
              return 'Required';
            }
            if (value.length < 6) {
              return 'Must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: _buildInputDecoration(
            'Confirm password *',
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
              return 'Required';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
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
