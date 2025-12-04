import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/services/storage_service.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/ui/auth/widgets/step_progress_bar.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final int _totalSteps = 3;
  int _currentStep = 0;
  late final List<GlobalKey<FormState>> _stepFormKeys =
      List.generate(_totalSteps, (_) => GlobalKey<FormState>());
  final List<IconData> _stepIcons = const [
    Icons.person_outline,
    Icons.security_outlined,
    Icons.home_outlined,
  ];

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _passportNumberController = TextEditingController();
  final _allergiesController = TextEditingController();

  File? _selectedProfilePhoto;

  String? _selectedGender;
  bool _isMongolianCitizen = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _registrationNumberController.dispose();
    _passportNumberController.dispose();
    _allergiesController.dispose();
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
    final success = await authStore.registerPatient(
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      age: _ageController.text.isEmpty
          ? null
          : int.tryParse(_ageController.text),
      gender: _selectedGender,
      permanentAddress: _addressController.text.trim(),
      registrationNumber: _registrationNumberController.text.trim().isEmpty
          ? null
          : _registrationNumberController.text.trim(),
      isMongolianCitizen: _isMongolianCitizen,
      isForeignCitizen: !_isMongolianCitizen,
      passportNumber: _passportNumberController.text.trim().isEmpty
          ? null
          : _passportNumberController.text.trim(),
      allergies: _allergiesController.text.trim().isEmpty
          ? null
          : _allergiesController.text.trim(),
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
              await authStore.loadCurrentProfile();
            }
          }
        } catch (_) {
          // Ignore upload errors here; account is already created
        }
      }

      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.patientAccountCreated),
          ),
        );
      }
      Navigator.of(context).pop();
    } else if (authStore.errorMessage != null && mounted) {
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
    final stepLabels = [
      l10n.basics,
      l10n.security,
      l10n.address,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.patientRegistration),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.createPatientAccount,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.stepByStepOnboarding,
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 24),
              StepProgressBar(
                totalSteps: _totalSteps,
                currentStep: _currentStep,
                icons: _stepIcons,
                labels: stepLabels,
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
                      child: _buildStepContent(_currentStep, l10n),
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
                                    ? l10n.createAccount
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
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.alreadyHaveAccountSignIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(int step, AppLocalizations l10n) {
    switch (step) {
      case 0:
        return _buildPersonalInfoStep(l10n);
      case 1:
        return _buildSecurityStep(l10n);
      case 2:
      default:
        return _buildAddressStep(l10n);
    }
  }

  Widget _buildPersonalInfoStep(AppLocalizations l10n) {
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
                  '${l10n.firstName} *',
                  Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lastNameController,
                decoration: _buildInputDecoration(
                  '${l10n.lastName} *',
                  Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: _buildInputDecoration(
            '${l10n.phoneNumber} *',
            Icons.phone_outlined,
            hint: l10n.phoneNumberHint,
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
          controller: _ageController,
          keyboardType: TextInputType.number,
          decoration: _buildInputDecoration(
            l10n.age,
            Icons.cake_outlined,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.gender,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: ['male', 'female', 'other'].map((gender) {
            final isSelected = _selectedGender == gender;
            final genderLabel = gender == 'male'
                ? l10n.male
                : gender == 'female'
                    ? l10n.female
                    : l10n.other;
            return ChoiceChip(
              label: Text(genderLabel),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (_) {
                setState(() => _selectedGender = gender);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _buildInputDecoration(
            '${l10n.password} *',
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
        const SizedBox(height: 14),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: _buildInputDecoration(
            '${l10n.confirmPassword} *',
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

  Widget _buildAddressStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: _buildInputDecoration(
            '${l10n.permanentAddress} *',
            Icons.location_on_outlined,
            hint: l10n.addressHint,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.required;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _registrationNumberController,
                decoration: _buildInputDecoration(
                  l10n.registrationNumber,
                  Icons.badge_outlined,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _passportNumberController,
                decoration: _buildInputDecoration(
                  l10n.passportNumber,
                  Icons.airplane_ticket_outlined,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.mongolianCitizen),
          activeColor: AppColors.primary,
          value: _isMongolianCitizen,
          onChanged: (value) {
            setState(() => _isMongolianCitizen = value);
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _allergiesController,
          maxLines: 2,
          decoration: _buildInputDecoration(
            l10n.allergiesOptional,
            Icons.health_and_safety_outlined,
          ),
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
