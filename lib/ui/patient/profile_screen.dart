import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/services/storage_service.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/profile_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';
import 'package:bugamed/ui/shared/widgets/language_switcher.dart';
import 'package:bugamed/l10n/app_localizations.dart';

import 'package:bugamed/core/utils/notification_helper.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
                AppPadding.screen, AppSpacing.lg, AppPadding.screen, AppSpacing.md),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 30),
              child: IntrinsicHeight(
                child: Observer(
                  builder: (_) {
                    final profile = authStore.currentProfile;
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md),
                          child: AppScreenHeader(
                            title: 'Profile',
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _onAvatarTap(context, l10n),
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ProfileAvatar(
                                avatarUrl: profile?.getAvatarUrl(),
                                initials: profile?.initials ?? 'U',
                                radius: 50,
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          profile?.displayName ?? l10n.user,
                          style: AppTypography.h2,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          profile?.phoneNumber ?? profile?.email ?? l10n.noPhoneNumber,
                          style: AppTypography.bodyLg.copyWith(
                            color: AppColors.inkMuted,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            l10n.patient,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _ProfileOption(
                          icon: Icons.person_outline,
                          title: l10n.editProfile,
                          onTap: () => _openEditProfile(context),
                        ),
                        _ProfileOption(
                          icon: Icons.history,
                          title: l10n.requestHistory,
                          onTap: () =>
                              NotificationHelper.show(context, l10n.viewAll),
                        ),
                        _ProfileOption(
                          icon: Icons.language,
                          title: 'Language / Хэл',
                          onTap: () => _openLanguageSheet(context),
                        ),
                        _ProfileOption(
                          icon: Icons.notifications_outlined,
                          title: l10n.notifications,
                          onTap: () => NotificationHelper.show(
                              context, '${l10n.notifications} ${l10n.adminComingSoon}'),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                          child: AppButton(
                            label: l10n.signOut,
                            icon: Icons.logout,
                            variant: AppButtonVariant.danger,
                            onPressed: () => _confirmSignOut(context, l10n),
                          ),
                        ),
                        Text(
                          'OnCall Lab v1.0.0',
                          style: AppTypography.caption,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onAvatarTap(BuildContext context, AppLocalizations l10n) async {
    final user = authStore.currentUser;
    if (user == null) return;

    final change = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dialogL10n.changeProfilePhoto),
          content: Text(dialogL10n.changeProfilePhotoConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(dialogL10n.change),
            ),
          ],
        );
      },
    );

    if (change != true || !context.mounted) return;

    final File? file = await StorageService.pickImage();
    if (file == null || !context.mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(dialogL10n.useThisPhoto),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: FileImage(file),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                dialogL10n.profilePhotoPreview,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(dialogL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(dialogL10n.save),
            ),
          ],
        );
      },
    );

    if (confirm != true || !context.mounted) return;

    try {
      final url = await StorageService.uploadProfilePhoto(
        userId: user.id,
        file: file,
      );

      if (url == null) {
        throw Exception('Failed to upload photo');
      }

      final cacheBustedUrl =
          '$url?t=${DateTime.now().millisecondsSinceEpoch}';

      await supabase
          .from('profiles')
          .update({
            'avatar_url': cacheBustedUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id);

      await authStore.loadCurrentProfile();

      if (context.mounted) {
        NotificationHelper.showSuccess(context, l10n.profilePhotoUpdated);
      }
    } catch (e) {
      if (context.mounted) {
        NotificationHelper.showError(
            context, '${l10n.failedToUpdatePhoto}: $e');
      }
    }
  }

  void _openEditProfile(BuildContext context) {
    final userProfile = authStore.currentProfile;
    if (userProfile == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => EditProfileSheet(profile: userProfile),
    );
  }

  void _openLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const LanguageSettingsSheet(),
    );
  }

  Future<void> _confirmSignOut(
      BuildContext context, AppLocalizations l10n) async {
    final shouldSignOut = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SheetGrabber(),
              const SizedBox(height: AppSpacing.lg),
              Text(
                dialogL10n.signOut,
                style: AppTypography.h3.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${dialogL10n.yes}? ${dialogL10n.signOut}',
                style: AppTypography.bodyLg.copyWith(color: AppColors.inkMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: dialogL10n.cancel,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.pop(ctx, false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      label: dialogL10n.signOut,
                      variant: AppButtonVariant.danger,
                      onPressed: () => Navigator.pop(ctx, true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        );
      },
    );

    if (shouldSignOut == true && context.mounted) {
      await authStore.signOut();
      if (context.mounted) {
        NotificationHelper.showSuccess(context, l10n.success);
      }
    }
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        elevation: AppCardElevation.resting,
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkSubtle),
          ],
        ),
      ),
    );
  }
}

class _SheetGrabber extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.inkSubtle.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
    );
  }
}

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key, required this.profile});

  final ProfileModel profile;

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _registrationController;
  late final TextEditingController _allergiesController;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _firstNameController =
        TextEditingController(text: profile.firstName ?? '');
    _lastNameController = TextEditingController(text: profile.lastName ?? '');
    _emailController = TextEditingController(text: profile.email ?? '');
    _addressController =
        TextEditingController(text: profile.permanentAddress ?? '');
    _registrationController =
        TextEditingController(text: profile.registrationNumber ?? '');
    _allergiesController =
        TextEditingController(text: profile.allergies ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _registrationController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    final success = await authStore.updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      permanentAddress: _addressController.text.trim(),
      registrationNumber: _registrationController.text.trim(),
      allergies: _allergiesController.text.trim(),
    );

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.profileUpdatedSuccessfully)),
      );
    } else if (authStore.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(authStore.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.screen,
        right: AppPadding.screen,
        bottom: bottomPadding > 0 ? bottomPadding : AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: _SheetGrabber()),
              const SizedBox(height: AppSpacing.md),
              Text(l10n.editProfile, style: AppTypography.h3),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _firstNameController,
                      label: l10n.firstName,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.required
                              : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppTextField(
                      controller: _lastNameController,
                      label: l10n.lastName,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.required
                              : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _emailController,
                label: l10n.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _addressController,
                label: l10n.address,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _registrationController,
                label: l10n.registrationNumber,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _allergiesController,
                label: l10n.allergies,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),
              Observer(
                builder: (_) => AppButton(
                  label: l10n.saveChanges,
                  loading: authStore.isUpdatingProfile,
                  onPressed:
                      authStore.isUpdatingProfile ? null : _handleSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SavedAddressSheet extends StatefulWidget {
  const SavedAddressSheet({super.key, this.initialAddress});

  final String? initialAddress;

  @override
  State<SavedAddressSheet> createState() => _SavedAddressSheetState();
}

class _SavedAddressSheetState extends State<SavedAddressSheet> {
  final _editFormKey = GlobalKey<FormState>();
  final _addFormKey = GlobalKey<FormState>();
  late final TextEditingController _editController;
  late final TextEditingController _addController;
  String? _currentAddress;
  bool showEditField = false;
  bool showAddField = false;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.initialAddress;
    _editController = TextEditingController(text: widget.initialAddress ?? '');
    _addController = TextEditingController();
    showAddField = (_currentAddress == null || _currentAddress!.isEmpty);
  }

  @override
  void dispose() {
    _editController.dispose();
    _addController.dispose();
    super.dispose();
  }

  Future<void> _persistAddress(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final success = await authStore.updateSavedAddress(trimmed);

    if (success) {
      setState(() {
        _currentAddress = trimmed;
        showEditField = false;
        showAddField = false;
        isSelected = false;
        _editController.text = trimmed;
      });
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.addressSaved)),
      );
    } else if (authStore.errorMessage != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(authStore.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _clearAddress() async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final success = await authStore.updateSavedAddress(null);
    if (success) {
      setState(() {
        _currentAddress = null;
        showAddField = true;
        showEditField = false;
        isSelected = false;
        _editController.clear();
      });
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.savedAddressRemoved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAddress = _currentAddress != null && _currentAddress!.isNotEmpty;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.screen,
        right: AppPadding.screen,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _SheetGrabber()),
          const SizedBox(height: AppSpacing.md),
          Text(l10n.savedAddresses, style: AppTypography.h3),
          const SizedBox(height: AppSpacing.md),
          _buildDefaultAddressCard(hasAddress),
          if (showEditField) ...[
            const SizedBox(height: AppSpacing.sm),
            Form(
              key: _editFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _editController,
                    maxLines: 3,
                    label: l10n.editAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterAddress;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Observer(
                    builder: (_) => AppButton(
                      label: l10n.saveChanges,
                      loading: authStore.isUpdatingAddress,
                      onPressed: authStore.isUpdatingAddress
                          ? null
                          : () {
                              if (_editFormKey.currentState!.validate()) {
                                _persistAddress(_editController.text);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: () {
              setState(() {
                showAddField = !showAddField;
                showEditField = false;
                isSelected = false;
                _addController.clear();
              });
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.addAddress),
          ),
          if (showAddField) ...[
            const SizedBox(height: AppSpacing.sm),
            Form(
              key: _addFormKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _addController,
                    maxLines: 3,
                    label: l10n.newAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.pleaseEnterAddress;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Observer(
                    builder: (_) => AppButton(
                      label: l10n.saveAddress,
                      loading: authStore.isUpdatingAddress,
                      onPressed: authStore.isUpdatingAddress
                          ? null
                          : () {
                              if (_addFormKey.currentState!.validate()) {
                                _persistAddress(_addController.text);
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: hasAddress && isSelected ? l10n.removeAddress : l10n.close,
            variant: hasAddress && isSelected
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: authStore.isUpdatingAddress
                ? null
                : hasAddress && isSelected
                    ? _clearAddress
                    : () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAddressCard(bool hasAddress) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      backgroundColor:
          hasAddress ? AppColors.primarySoft : AppColors.background,
      borderColor: isSelected ? AppColors.primary : null,
      borderWidth: isSelected ? 2 : 1,
      borderRadius: AppRadius.sm,
      elevation: AppCardElevation.none,
      onTap: hasAddress
          ? () {
              setState(() {
                isSelected = !isSelected;
              });
            }
          : null,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasAddress ? _currentAddress! : l10n.noDefaultAddressSaved,
              style: AppTypography.body.copyWith(
                fontWeight:
                    hasAddress ? FontWeight.w600 : FontWeight.normal,
                color: hasAddress ? AppColors.ink : AppColors.inkMuted,
              ),
            ),
          ),
          if (hasAddress)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                setState(() {
                  showEditField = !showEditField;
                  showAddField = false;
                  isSelected = false;
                  _editController.text = _currentAddress ?? '';
                });
              },
            ),
        ],
      ),
    );
  }
}
