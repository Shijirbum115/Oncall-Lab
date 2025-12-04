import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/core/services/storage_service.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';
import 'package:oncall_lab/data/models/profile_model.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/ui/shared/widgets/profile_avatar.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/design_system/widgets/app_text_field.dart';
import 'package:oncall_lab/ui/shared/widgets/language_switcher.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Observer(
          builder: (_) {
            final profile = authStore.currentProfile;
            return Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
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
                              const SizedBox(height: 12),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.profilePhotoUpdated),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${l10n.failedToUpdatePhoto}: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
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
                          color: Colors.white,
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
                const SizedBox(height: 20),
                Text(
                  profile?.displayName ?? l10n.user,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  profile?.phoneNumber ?? profile?.email ?? l10n.noPhoneNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.patient,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
                const SizedBox(height: 40),
                _buildProfileOption(
              icon: Icons.person_outline,
              title: l10n.editProfile,
              onTap: () {
                final userProfile = authStore.currentProfile;
                if (userProfile != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (ctx) => EditProfileSheet(profile: userProfile),
                  );
                }
              },
            ),
                _buildProfileOption(
              icon: Icons.history,
              title: l10n.requestHistory,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.viewAll),
                  ),
                );
              },
            ),
                _buildProfileOption(
              icon: Icons.language,
              title: 'Language / Хэл',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => const LanguageSettingsSheet(),
                );
              },
            ),
                _buildProfileOption(
              icon: Icons.notifications_outlined,
              title: l10n.notifications,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${l10n.notifications} ${l10n.adminComingSoon}'),
                  ),
                );
              },
            ),
            const Spacer(),
                Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final shouldSignOut = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      final dialogL10n = AppLocalizations.of(context)!;
                      return AlertDialog(
                        title: Text(dialogL10n.signOut),
                        content: Text('${dialogL10n.yes}? ${dialogL10n.signOut}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(dialogL10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                            ),
                            child: Text(dialogL10n.signOut),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldSignOut == true && context.mounted) {
                    await authStore.signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.success),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.signOut),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ),
                const Text(
              'OnCall Lab v1.0.0',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
              ],
            );
          },
        ),
      ),
    );
  }

Widget _buildProfileOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.grey,
        ),
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
        left: 20,
        right: 20,
        bottom: bottomPadding > 0 ? bottomPadding : 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                l10n.editProfile,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _firstNameController,
                      label: l10n.firstName,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? l10n.required
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
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
              const SizedBox(height: 12),
              _buildTextField(
                controller: _emailController,
                label: l10n.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _addressController,
                label: l10n.address,
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _registrationController,
                label: l10n.registrationNumber,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _allergiesController,
                label: l10n.allergies,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: Observer(
                  builder: (_) => ElevatedButton(
                    onPressed: authStore.isUpdatingProfile ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authStore.isUpdatingProfile
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            l10n.saveChanges,
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
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
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
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            l10n.savedAddresses,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDefaultAddressCard(hasAddress),
          if (showEditField) ...[
            const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  Observer(
                    builder: (_) => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: authStore.isUpdatingAddress
                            ? null
                            : () {
                                if (_editFormKey.currentState!.validate()) {
                                  _persistAddress(_editController.text);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: authStore.isUpdatingAddress
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(l10n.saveChanges),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
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
            const SizedBox(height: 12),
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
                  const SizedBox(height: 12),
                  Observer(
                    builder: (_) => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: authStore.isUpdatingAddress
                            ? null
                            : () {
                                if (_addFormKey.currentState!.validate()) {
                                  _persistAddress(_addController.text);
                                }
                              },
                        child: authStore.isUpdatingAddress
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(l10n.saveAddress),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: authStore.isUpdatingAddress
                  ? null
                  : hasAddress && isSelected
                      ? _clearAddress
                      : () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasAddress && isSelected ? AppColors.error : AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(
                hasAddress && isSelected ? l10n.removeAddress : l10n.close,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAddressCard(bool hasAddress) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: hasAddress
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: hasAddress
            ? () {
                setState(() {
                  isSelected = !isSelected;
                });
              }
            : null,
        title: Text(
          hasAddress ? _currentAddress! : l10n.noDefaultAddressSaved,
          style: TextStyle(
            fontWeight: hasAddress ? FontWeight.w600 : FontWeight.normal,
            color: hasAddress ? AppColors.black : AppColors.grey,
          ),
        ),
        trailing: hasAddress
            ? IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  setState(() {
                    showEditField = !showEditField;
                    showAddField = false;
                    isSelected = false;
                    _editController.text = _currentAddress ?? '';
                  });
                },
              )
            : null,
      ),
    );
  }
}
