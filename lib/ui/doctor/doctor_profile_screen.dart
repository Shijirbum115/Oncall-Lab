import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/services/storage_service.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/data/models/doctor_review_model.dart';
import 'package:bugamed/data/repositories/doctor_repository.dart';
import 'package:bugamed/data/repositories/doctor_review_repository.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _togglingAvailability = false;
  late Future<List<DoctorReviewModel>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _loadReviews();
  }

  Future<List<DoctorReviewModel>> _loadReviews() {
    final doctorId = authStore.currentUser?.id;
    if (doctorId == null) return Future.value(const []);
    return GetIt.I<DoctorReviewRepository>()
        .getReviewsForDoctor(doctorId: doctorId, limit: 20);
  }

  Future<void> _toggleAvailability(bool value) async {
    final doctorId = authStore.currentUser?.id;
    if (doctorId == null || _togglingAvailability) return;

    setState(() => _togglingAvailability = true);
    try {
      await GetIt.I<DoctorRepository>().updateAvailability(
        doctorId: doctorId,
        isAvailable: value,
      );
      await authStore.loadCurrentProfile();
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.somethingWentWrong),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _togglingAvailability = false);
    }
  }

  Future<void> _changePhoto() async {
    final l10n = AppLocalizations.of(context)!;
    final user = authStore.currentUser;
    if (user == null) return;

    final File? file = await StorageService.pickImage();
    if (file == null || !mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.useThisPhoto),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundImage: FileImage(file)),
            const SizedBox(height: 12),
            Text(l10n.profilePhotoPreview, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      final url = await StorageService.uploadProfilePhoto(
        userId: user.id,
        file: file,
      );
      if (url == null) throw Exception('Failed to upload photo');

      final cacheBustedUrl =
          '$url?t=${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now().toIso8601String();

      await supabase.from('profiles').update({
        'avatar_url': cacheBustedUrl,
        'updated_at': now,
      }).eq('id', user.id);

      await supabase.from('doctor_profiles').update({
        'photo_url': cacheBustedUrl,
        'updated_at': now,
      }).eq('id', user.id);

      await authStore.loadCurrentProfile();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profilePhotoUpdated)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToUpdatePhotoError(e.toString())),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
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
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await authStore.signOut();
      if (!mounted) return;
      // Let AuthGate decide the next screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: false,
      child: Observer(
        builder: (_) {
          final profile = authStore.currentProfile;
          final doctorProfile = authStore.currentDoctorProfile;
          final isAvailable = doctorProfile?.isAvailable ?? false;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(l10n.profile, style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.lg),

              // Avatar and name
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _changePhoto,
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.outline),
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
                    const SizedBox(height: 14),
                    Text(
                      profile?.displayName ?? 'Doctor',
                      style: AppTypography.sectionHeader,
                    ),
                    if (doctorProfile?.profession != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        doctorProfile!.profession!,
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Availability: the doctor's "go online" switch
              AppCard(
                borderRadius: AppRadius.lg,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isAvailable,
                  onChanged:
                      _togglingAvailability ? null : _toggleAvailability,
                  activeTrackColor: AppColors.success,
                  title: Text(
                    l10n.availableForRequests,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    isAvailable
                        ? l10n.availabilityOnHint
                        : l10n.availabilityOffHint,
                    style: AppTypography.bodySmall,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Stats
              if (doctorProfile != null)
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Iconsax.star1,
                        value: doctorProfile.rating.toStringAsFixed(1),
                        label: l10n.rating,
                        color: const Color(0xFFB45309),
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
                        icon: Iconsax.calendar_1,
                        value: '${doctorProfile.yearsOfExperience ?? 0}',
                        label: l10n.yearsExp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: AppSpacing.sm),

              // Contact
              _InfoSection(
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

              const SizedBox(height: AppSpacing.sm),

              // Professional info
              if (doctorProfile != null)
                _InfoSection(
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
                  ],
                ),

              // Bio
              if (doctorProfile?.bio != null &&
                  doctorProfile!.bio!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                _InfoSection(
                  title: l10n.about,
                  icon: Iconsax.document_text,
                  children: [
                    Text(
                      doctorProfile.bio!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Reviews
              Text(l10n.myReviews, style: AppTypography.sectionHeader),
              const SizedBox(height: AppSpacing.sm),
              FutureBuilder<List<DoctorReviewModel>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    );
                  }

                  final reviews = snapshot.data ?? const [];
                  if (reviews.isEmpty) {
                    return AppCard(
                      borderRadius: AppRadius.md,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Iconsax.star,
                              size: 20, color: AppColors.textTertiary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l10n.noReviewsYet,
                              style: AppTypography.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: reviews
                        .map((review) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ReviewCard(review: review),
                            ))
                        .toList(),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Logout
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Iconsax.logout, color: AppColors.error),
                  label: Text(
                    l10n.logout,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.error, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ),
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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.85),
            ),
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
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
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

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.labelSmall),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final DoctorReviewModel review;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.md,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.profile?.displayName ?? '—',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating.round()
                        ? Iconsax.star1
                        : Iconsax.star,
                    size: 14,
                    color: const Color(0xFFF59E0B),
                  );
                }),
              ),
            ],
          ),
          if (review.reviewText != null &&
              review.reviewText!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review.reviewText!,
              style: AppTypography.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
