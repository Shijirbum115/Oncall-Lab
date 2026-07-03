import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/core/services/storage_service.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/auth/widgets/step_progress_bar.dart';
import 'package:bugamed/l10n/app_localizations.dart';

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

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.patientAccountCreated),
        ),
      );
      
      Navigator.of(context).pop();
    } else if (authStore.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authStore.errorMessage!),
          backgroundColor: AppColors.error, // TODO: token — no `danger` token defined; using `error` alias
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final stepLabels = [
      l10n.basics,
      l10n.security,
      l10n.address,
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: false, // Keyboard overlays instead of pushing
      appBar: AppBar(
        title: Text(l10n.patientRegistration),
        backgroundColor: AppColors.surface,
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
                    l10n.createPatientAccount,
                    style: AppTypography.h1,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.stepByStepOnboarding,
                    style: AppTypography.body.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  StepProgressBar(
                    totalSteps: _totalSteps,
                    currentStep: _currentStep,
                    icons: _stepIcons,
                    labels: stepLabels,
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
                color: AppColors.surface,
                boxShadow: AppShadows.raised,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: AppButton(
                            label: l10n.back,
                            variant: AppButtonVariant.secondary,
                            onPressed: authStore.isLoading
                                ? null
                                : _goToPreviousStep,
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        child: Observer(
                          builder: (_) => AppButton(
                            label: _currentStep == _totalSteps - 1
                                ? l10n.createAccount
                                : l10n.continue_,
                            onPressed:
                                authStore.isLoading ? null : _goToNextStep,
                            loading: authStore.isLoading,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.alreadyHaveAccountSignIn),
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
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primarySoft,
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
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
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
              labelStyle: AppTypography.body.copyWith(
                color: isSelected ? AppColors.surface : AppColors.ink,
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
          activeTrackColor: AppColors.primary,
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
