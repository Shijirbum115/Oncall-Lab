import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/auth/patient_registration_screen.dart';
import 'package:bugamed/ui/auth/doctor_registration_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/shared/widgets/language_switcher.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';

import 'package:bugamed/core/utils/notification_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.message,
    this.onLoginSuccess,
  });

  /// Optional message to display above the login form
  final String? message;

  /// Optional callback to execute after successful login
  final VoidCallback? onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authStore.signIn(
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (success) {
      // Execute callback if provided
      widget.onLoginSuccess?.call();
      
      // Pop with success result if this screen was pushed
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    } else if (authStore.errorMessage != null && mounted) {
      NotificationHelper.showError(context, authStore.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // Keyboard overlays instead of pushing
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable content area
            Positioned.fill(
              bottom: 180 + bottomPadding, // Space for bottom buttons
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language switcher at the top
                      const Align(
                        alignment: Alignment.centerRight,
                        child: LanguageSwitcher(),
                      ),
                      const SizedBox(height: 20),
                      // Logo or app name
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_hospital,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        l10n.welcomeBack,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.signInToContinue,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                      // Show custom message if provided
                      if (widget.message != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  widget.message!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      // Phone number field
                      AppTextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        label: l10n.phoneNumber,
                        hint: l10n.phoneNumberHint,
                        prefixIcon: const Icon(Icons.phone),
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) return l10n.pleaseEnterPhoneNumber;
                          if (v.length != 8 || int.tryParse(v) == null) {
                            return l10n.enterValidPhoneNumber;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Password field
                      AppTextField(
                        controller: _passwordController,
                        label: l10n.password,
                        prefixIcon: const Icon(Icons.lock),
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.pleaseEnterPassword;
                          }
                          if (value.length < 6) {
                            return l10n.passwordMinLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            NotificationHelper.show(context, l10n.passwordResetComingSoon);
                          },
                          child: Text(l10n.forgotPassword),
                        ),
                      ),
                      // Extra padding for keyboard
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 200 : 0),
                    ],
                  ),
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
                    // Login button
                    Observer(
                      builder: (_) => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: authStore.isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
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
                                  l10n.signIn,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Register links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const PatientRegistrationScreen(),
                              ),
                            );
                          },
                          child: Text(l10n.registerAsPatient),
                        ),
                        Text(
                          '  |  ',
                          style: TextStyle(
                            color: AppColors.grey.withValues(alpha: 0.5),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const DoctorRegistrationScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.info,
                          ),
                          child: Text(l10n.registerAsDoctor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
