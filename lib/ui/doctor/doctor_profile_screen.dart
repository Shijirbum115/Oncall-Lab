import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/core/services/storage_service.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Observer(
        builder: (_) {
          final profile = authStore.currentProfile;
          final doctorProfile = authStore.currentDoctorProfile;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: AppSpacing.lg),
              AppScreenHeader(title: l10n.profile),
              const SizedBox(height: AppSpacing.lg),

              // Avatar and Name
              Padding(
                padding: AppPadding.screenH,
                child: Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final user = authStore.currentUser;
                          if (user == null) return;

                          final change = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.changeProfilePhoto),
                              content: Text(l10n.changeProfilePhotoConfirm),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(false),
                                  child: Text(l10n.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(true),
                                  child: Text(l10n.change),
                                ),
                              ],
                            ),
                          );

                          if (change != true || !context.mounted) return;

                          final File? file =
                              await StorageService.pickImage();
                          if (file == null || !context.mounted) return;

                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.useThisPhoto),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: FileImage(file),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.profilePhotoPreview,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(false),
                                  child: Text(l10n.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(ctx).pop(true),
                                  child: Text(l10n.save),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true || !context.mounted) return;

                          try {
                            final url =
                                await StorageService.uploadProfilePhoto(
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
                                  'updated_at': DateTime.now()
                                      .toIso8601String(),
                                })
                                .eq('id', user.id);

                            await supabase
                                .from('doctor_profiles')
                                .update({
                                  'photo_url': cacheBustedUrl,
                                  'updated_at': DateTime.now()
                                      .toIso8601String(),
                                })
                                .eq('id', user.id);

                            await authStore.loadCurrentProfile();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.profilePhotoUpdated),
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    l10n.failedToUpdatePhotoError(e.toString())),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ProfileAvatar(
                              avatarUrl: profile?.getAvatarUrl(),
                              initials: profile?.initials ?? 'D',
                              radius: 50,
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Iconsax.camera,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        profile?.displayName ?? 'Doctor',
                        style: AppTypography.h2,
                      ),
                      if (doctorProfile?.profession != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            doctorProfile?.profession ?? '',
                            style: AppTypography.bodySm,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Stats Cards
              if (doctorProfile != null)
                Padding(
                  padding: AppPadding.screenH,
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.star,
                          value: doctorProfile.rating.toStringAsFixed(1),
                          label: l10n.rating,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.tick_circle,
                          value:
                              doctorProfile.totalCompletedRequests.toString(),
                          label: l10n.completedCount,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _StatCard(
                          icon: Iconsax.calendar,
                          value: '${doctorProfile.yearsOfExperience ?? 0}',
                          label: l10n.yearsExp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Information Section
              Padding(
                padding: AppPadding.screenH,
                child: _InfoSection(
                  title: l10n.contactInformation,
                  icon: Iconsax.call,
                  children: [
                    if (profile?.phoneNumber != null)
                      _InfoRow(
                        label: l10n.phone,
                        value: profile?.phoneNumber ?? '',
                        icon: Iconsax.mobile,
                      ),
                    if (profile?.email != null)
                      _InfoRow(
                        label: l10n.email,
                        value: profile?.email ?? '',
                        icon: Iconsax.sms,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Professional Information
              if (doctorProfile != null)
                Padding(
                  padding: AppPadding.screenH,
                  child: _InfoSection(
                    title: l10n.professionalDetails,
                    icon: Iconsax.briefcase,
                    children: [
                      _InfoRow(
                        label: l10n.licenseNumber,
                        value: doctorProfile.licenseNumber,
                        icon: Iconsax.card,
                      ),
                      if (doctorProfile.academicDegree != null)
                        _InfoRow(
                          label: l10n.academicDegree,
                          value: doctorProfile.academicDegree!,
                          icon: Iconsax.award,
                        ),
                      _InfoRow(
                        label: l10n.status,
                        value: doctorProfile.isAvailable
                            ? l10n.available
                            : l10n.unavailable,
                        icon: Iconsax.status,
                        valueColor: doctorProfile.isAvailable
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.md),

              // Bio Section
              if (doctorProfile?.bio != null && doctorProfile!.bio!.isNotEmpty)
                Padding(
                  padding: AppPadding.screenH,
                  child: _InfoSection(
                    title: l10n.about,
                    icon: Iconsax.document_text,
                    children: [
                      Text(
                        doctorProfile.bio!,
                        style: AppTypography.body.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Logout Button
              Padding(
                padding: AppPadding.screenH,
                child: AppButton(
                  label: l10n.logout,
                  variant: AppButtonVariant.danger,
                  icon: Iconsax.logout,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.logout),
                        content: Text(l10n.areYouSureLogout),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(l10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: AppColors.surface,
                            ),
                            child: Text(l10n.logout),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      await authStore.signOut();
                      if (!context.mounted) return;
                      // Let AuthGate decide the next screen
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: AppCardElevation.none,
      backgroundColor: color.withValues(alpha: 0.1),
      borderColor: color.withValues(alpha: 0.3),
      borderRadius: AppRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevation: AppCardElevation.none,
      borderColor: AppColors.border,
      borderRadius: AppRadius.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: AppTypography.h3,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.inkSubtle),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption,
                ),
                Text(
                  value,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
