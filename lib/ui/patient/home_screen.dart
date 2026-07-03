import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/home_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/patient/widgets/visit_options_section.dart';
import 'package:bugamed/ui/patient/widgets/test_types_section.dart';
import 'package:bugamed/ui/patient/widgets/available_doctors_section.dart';
import 'package:bugamed/ui/patient/all_lab_services_screen.dart';
import 'package:bugamed/ui/patient/direct_services_screen.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_section_header.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';
import 'package:bugamed/ui/shared/widgets/notification_bell.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/patient/widgets/ad_banner.dart';

class PatientHomeScreen extends StatefulWidget {
  final VoidCallback onNavigateToProfile;

  const PatientHomeScreen({
    super.key,
    required this.onNavigateToProfile,
  });

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  late final HomeStore _homeStore;

  @override
  void initState() {
    super.initState();
    _homeStore = homeStore;

    // Load initial data
    _homeStore.loadHomeData();

    // Start real-time subscriptions for live updates
    _homeStore.startRealtimeSubscriptions();
  }

  @override
  void dispose() {
    // Cancel real-time subscriptions to prevent memory leaks
    _homeStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (_) {
        final hasData = _homeStore.testTypes.isNotEmpty ||
            _homeStore.availableDoctors.isNotEmpty;

        if (_homeStore.isLoading && !hasData) {
          return const Center(
            child: MascotStateWidget(
              emotion: MascotEmotion.loading,
              title: 'Мэдээлэл уншиж байна...',
            ),
          );
        }

        if (_homeStore.errorMessage != null && !hasData) {
          return Center(
            child: SingleChildScrollView(
              child: MascotStateWidget(
                emotion: MascotEmotion.error,
                title: l10n.errorLoadingData,
                subtitle: _homeStore.errorMessage ?? '',
                actionText: l10n.retry,
                onAction: _homeStore.loadHomeData,
              ),
            ),
          );
        }

        final tests = _homeStore.testTypes.toList();
        final doctors = _homeStore.availableDoctors.toList();

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildHeader(l10n),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _homeStore.loadHomeData,
                  displacement: 30,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisitOptionsSection(
                          onClinicTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllLabServicesScreen(),
                              ),
                            );
                          },
                          onHomeTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DirectServicesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const AdBanner(),
                        const SizedBox(height: AppSpacing.lg),
                        TestTypesSection(
                          testTypes: tests,
                          onSeeAllTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AllLabServicesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        AppSectionHeader(
                          title: l10n.availableDoctors,
                          actionLabel: l10n.viewAll,
                          onActionTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DirectServicesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AvailableDoctorsSection(doctors: doctors),
                        const SizedBox(height: 110), // Extra padding for floating navbar
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final profile = authStore.currentProfile;
    final displayName =
        (profile?.firstName?.isNotEmpty ?? false) ? profile!.firstName : profile?.displayName;

    return AppScreenHeader(
      title: displayName ?? l10n.welcome,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NotificationBell(),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.onNavigateToProfile,
            child: ProfileAvatar(
              avatarUrl: profile?.getAvatarUrl(),
              initials: profile?.initials ?? 'U',
              radius: 27,
            ),
          ),
        ],
      ),
    );
  }

}
