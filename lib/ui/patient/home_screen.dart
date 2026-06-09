import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/home_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/patient/widgets/visit_options_section.dart';
import 'package:bugamed/ui/patient/widgets/service_category_row.dart';
import 'package:bugamed/ui/patient/widgets/available_doctors_section.dart';
import 'package:bugamed/ui/patient/all_lab_services_screen.dart';
import 'package:bugamed/ui/patient/direct_services_screen.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';
import 'package:bugamed/ui/shared/widgets/notification_bell.dart';
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/core/utils/error_handler.dart';
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

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with SingleTickerProviderStateMixin {
  late final HomeStore _homeStore;

  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _homeStore = homeStore;

    // Load initial data
    _homeStore.loadHomeData();

    // Start real-time subscriptions for live updates
    _homeStore.startRealtimeSubscriptions();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _waveAnimation =
        Tween<double>(begin: -0.12, end: 0.12).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waveController.repeat(reverse: true);
      Timer(const Duration(seconds: 4), () {
        if (mounted) {
          _waveController.forward(from: 0);
          _waveController.stop();
        }
      });
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    // Cancel real-time subscriptions to prevent memory leaks
    _homeStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (_) {
        final hasData = _homeStore.serviceCategories.isNotEmpty ||
            _homeStore.testTypes.isNotEmpty ||
            _homeStore.availableDoctors.isNotEmpty;

        if (_homeStore.isLoading && !hasData) {
          return const Center(
            child: AppEmptyState(
              emotion: AppEmptyEmotion.loading,
              title: 'Мэдээлэл уншиж байна...',
            ),
          );
        }

        if (_homeStore.errorMessage != null && !hasData) {
          return Center(
            child: SingleChildScrollView(
              child: AppEmptyState(
                emotion: AppEmptyEmotion.error,
                title: l10n.errorLoadingData,
                subtitle: friendlyErrorMessage(l10n, _homeStore.errorMessage),
                actionText: l10n.retry,
                onAction: _homeStore.loadHomeData,
              ),
            ),
          );
        }

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
                              CupertinoPageRoute(
                                builder: (_) => const AllLabServicesScreen(),
                              ),
                            );
                          },
                          onHomeTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const DirectServicesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: AppPadding.screenH,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.services,
                                style: AppTypography.sectionHeader,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          const AllLabServicesScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  l10n.viewAll,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ServiceCategoryRow(
                          categories: _homeStore.serviceCategories.toList(),
                          onCategoryTap: (category) {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const AllLabServicesScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const AdBanner(),
                        const SizedBox(height: AppSpacing.lg),
                        Padding(
                          padding: AppPadding.screenH,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.availableDoctors,
                                style: AppTypography.sectionHeader,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                          const DirectServicesScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  l10n.viewAll,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
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

    return Padding(
      padding: AppPadding.screenH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    displayName ?? l10n.welcome,
                    style: AppTypography.heading,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _waveAnimation.value,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    "assets/images/hand.png",
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),
          ),
          Row(
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
        ],
      ),
    );
  }

}
