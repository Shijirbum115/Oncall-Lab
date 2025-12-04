import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/home_store.dart';
import 'package:oncall_lab/ui/patient/widgets/visit_options_section.dart';
import 'package:oncall_lab/ui/patient/widgets/test_types_section.dart';
import 'package:oncall_lab/ui/patient/widgets/available_doctors_section.dart';
import 'package:oncall_lab/ui/patient/all_lab_services_screen.dart';
import 'package:oncall_lab/ui/patient/direct_services_screen.dart';
import 'package:oncall_lab/ui/shared/widgets/profile_avatar.dart';
import 'package:oncall_lab/ui/shared/widgets/notification_bell.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/patient/widgets/ad_banner.dart';

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
    _homeStore.loadHomeData();
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
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (_homeStore.errorMessage != null && !hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.errorLoadingData,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _homeStore.errorMessage ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _homeStore.loadHomeData,
                    child: Text(l10n.retry),
                  ),
                ],
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
              const SizedBox(height: 20),
              _buildHeader(l10n),
              const SizedBox(height: 20),
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
                        const SizedBox(height: 30),
                        const AdBanner(),
                        const SizedBox(height: 24),
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
                        const SizedBox(height: 35),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.availableDoctors,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.black,
                                  letterSpacing: -.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
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
                        const SizedBox(height: 15),
                        AvailableDoctorsSection(doctors: doctors),
                        const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    displayName ?? l10n.welcome,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
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
