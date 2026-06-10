import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/auth/patient_registration_screen.dart';
import 'package:bugamed/ui/auth/doctor_registration_screen.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/shared/widgets/language_switcher.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
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
      widget.onLoginSuccess?.call();
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    } else if (authStore.errorMessage != null && mounted) {
      NotificationHelper.showError(context, authStore.errorMessage!);
    }
  }

  void _showSupportSheet(AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.contactSupport, style: AppTypography.sectionHeader),
            const SizedBox(height: AppSpacing.sm),
            Text(l10n.forgotPasswordHelp, style: AppTypography.bodyMedium),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: l10n.close,
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: LanguageSegmentedPill(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // CallCare brand mark
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: AppColors.brandGradient,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Iconsax.health5,
                            size: 42, color: Colors.white),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'CallCare',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Text(l10n.welcomeBack, style: AppTypography.heading),
                const SizedBox(height: 6),
                Text(l10n.signInToContinue, style: AppTypography.bodyMedium),

                if (widget.message != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.red50,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(color: AppColors.red200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.info_circle,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.message!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  label: l10n.phoneNumber,
                  hint: l10n.phoneNumberHint,
                  prefixIcon: const Icon(Iconsax.call),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return l10n.pleaseEnterPhoneNumber;
                    if (v.length != 8 || int.tryParse(v) == null) {
                      return l10n.enterValidPhoneNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _passwordController,
                  label: l10n.password,
                  prefixIcon: const Icon(Iconsax.lock_1),
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
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
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _showSupportSheet(l10n),
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                Observer(
                  builder: (_) => AppButton(
                    label: l10n.signIn,
                    loading: authStore.isLoading,
                    onPressed: authStore.isLoading ? null : _handleLogin,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Patient registration — the primary path for new users
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        l10n.noAccountYet,
                        style: AppTypography.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const PatientRegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(l10n.register),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Doctor onboarding — deliberately demoted to a footer link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const DoctorRegistrationScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textTertiary,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text('${l10n.areDoctor} ${l10n.registerAsDoctor}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
