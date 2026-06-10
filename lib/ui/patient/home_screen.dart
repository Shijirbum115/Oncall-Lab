import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/home_store.dart';
import 'package:bugamed/stores/test_request_store.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
import 'package:bugamed/ui/design_system/widgets/status_timeline.dart';
import 'package:bugamed/ui/patient/all_lab_services_screen.dart';
import 'package:bugamed/ui/patient/direct_services_screen.dart';
import 'package:bugamed/ui/patient/widgets/available_doctors_section.dart';
import 'package:bugamed/ui/patient/widgets/request_journey.dart';
import 'package:bugamed/ui/patient/widgets/service_category_row.dart';
import 'package:bugamed/ui/shared/widgets/notification_bell.dart';
import 'package:bugamed/ui/shared/widgets/profile_avatar.dart';
import 'package:bugamed/core/utils/error_handler.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// CallCare home — a state machine:
/// active booking first, then booking entry points and discovery content.
class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({
    super.key,
    required this.onNavigateToProfile,
    this.onNavigateToBookings,
    this.onNavigateToAssistant,
  });

  final VoidCallback onNavigateToProfile;
  final VoidCallback? onNavigateToBookings;
  final VoidCallback? onNavigateToAssistant;

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool _requestsSubscribed = false;

  @override
  void initState() {
    super.initState();
    homeStore.loadHomeData();
    homeStore.startRealtimeSubscriptions();
  }

  /// Surface the user's active booking on home (the card they open the app
  /// for). Runs from build so it also kicks in when a guest signs in while
  /// this State stays alive in the IndexedStack. The store is a singleton —
  /// never disposed from a screen.
  void _ensureRequestsSubscription() {
    final user = authStore.currentUser;
    if (user == null) {
      _requestsSubscribed = false;
      return;
    }
    if (_requestsSubscribed) return;
    _requestsSubscribed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) testRequestStore.subscribeToPatientRequests(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (_) {
        _ensureRequestsSubscription();
        final hasData = homeStore.serviceCategories.isNotEmpty ||
            homeStore.testTypes.isNotEmpty ||
            homeStore.availableDoctors.isNotEmpty;

        if (homeStore.isLoading && !hasData) {
          return Center(
            child: AppEmptyState(
              emotion: AppEmptyEmotion.loading,
              title: l10n.loading,
            ),
          );
        }

        if (homeStore.errorMessage != null && !hasData) {
          return Center(
            child: SingleChildScrollView(
              child: AppEmptyState(
                emotion: AppEmptyEmotion.error,
                title: l10n.errorLoadingData,
                subtitle: friendlyErrorMessage(l10n, homeStore.errorMessage),
                actionText: l10n.retry,
                onAction: homeStore.loadHomeData,
              ),
            ),
          );
        }

        final doctors = homeStore.availableDoctors.toList();
        final activeRequest = authStore.isAuthenticated &&
                testRequestStore.activeRequests.isNotEmpty
            ? testRequestStore.activeRequests.first
            : null;

        return SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: homeStore.loadHomeData,
            displacement: 30,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  _buildHeader(l10n),
                  const SizedBox(height: AppSpacing.lg),

                  // ----- Active booking: always first when present -----
                  if (activeRequest != null) ...[
                    Padding(
                      padding: AppPadding.screenH,
                      child: _ActiveCareCard(
                        request: activeRequest,
                        l10n: l10n,
                        onTap: widget.onNavigateToBookings,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // ----- Booking entry points -----
                  Padding(
                    padding: AppPadding.screenH,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _HeroActionCard(
                              gradient: true,
                              icon: Iconsax.drop,
                              title: l10n.bookLabTest,
                              subtitle: l10n.bookLabTestSubtitle,
                              onTap: () => _push(const AllLabServicesScreen()),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _HeroActionCard(
                              gradient: false,
                              icon: Iconsax.home_2,
                              title: l10n.callDoctor,
                              subtitle: l10n.callTheDoctorHome,
                              onTap: () => _push(const DirectServicesScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ----- Assistant entry -----
                  Padding(
                    padding: AppPadding.screenH,
                    child: _AssistantCard(
                      l10n: l10n,
                      onTap: widget.onNavigateToAssistant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ----- Services -----
                  _SectionHeader(
                    title: l10n.services,
                    actionText: l10n.viewAll,
                    onAction: () => _push(const AllLabServicesScreen()),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ServiceCategoryRow(
                    categories: homeStore.serviceCategories.toList(),
                    onCategoryTap: (category) {
                      final isMn = l10n.localeName == 'mn';
                      final name = isMn
                          ? (category['name_mn'] as String? ??
                              category['name'] as String?)
                          : category['name'] as String?;
                      _push(AllLabServicesScreen(initialCategory: name));
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ----- Available doctors -----
                  if (doctors.isNotEmpty) ...[
                    _SectionHeader(
                      title: l10n.availableDoctors,
                      actionText: l10n.viewAll,
                      onAction: () => _push(const DirectServicesScreen()),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AvailableDoctorsSection(doctors: doctors),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _push(Widget screen) {
    Navigator.push(context, CupertinoPageRoute(builder: (_) => screen));
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final profile = authStore.currentProfile;
    final displayName = (profile?.firstName?.isNotEmpty ?? false)
        ? profile!.firstName
        : profile?.displayName;

    return Padding(
      padding: AppPadding.screenH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName != null ? l10n.welcome : 'CallCare',
                  style: AppTypography.labelSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  displayName ?? l10n.healthcareAtYourDoorstep,
                  style: displayName != null
                      ? AppTypography.titleLarge
                      : AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              const NotificationBell(),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onNavigateToProfile,
                child: ProfileAvatar(
                  avatarUrl: profile?.getAvatarUrl(),
                  initials: profile?.initials ?? 'U',
                  radius: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Active booking card
// ---------------------------------------------------------------------------

class _ActiveCareCard extends StatelessWidget {
  const _ActiveCareCard({
    required this.request,
    required this.l10n,
    this.onTap,
  });

  final TestRequestModel request;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = request.requestType == RequestType.labService
        ? l10n.labTestCollection
        : l10n.homeServiceRequest;

    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      shadow: AppShadows.md,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Iconsax.activity,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.activeBooking, style: AppTypography.labelSmall),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Iconsax.arrow_right_3,
                  size: 18, color: AppColors.grey),
            ],
          ),
          const SizedBox(height: 16),
          StatusTimeline(
            steps: RequestJourney.steps(l10n),
            currentIndex: RequestJourney.indexOf(request.status),
            cancelled: RequestJourney.isCancelled(request.status),
            cancelledLabel: l10n.cancelled,
            compact: true,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Iconsax.calendar_1,
                  size: 15, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.scheduledAt(
                    request.scheduledDate,
                    request.scheduledTimeSlot ?? '',
                  ),
                  style: AppTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Hero booking actions
// ---------------------------------------------------------------------------

class _HeroActionCard extends StatelessWidget {
  const _HeroActionCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool gradient;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = gradient ? Colors.white : AppColors.textPrimary;
    final subtitleColor =
        gradient ? Colors.white.withValues(alpha: 0.85) : AppColors.textSecondary;

    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      backgroundColor: gradient ? Colors.transparent : Colors.white,
      shadow: gradient ? AppShadows.md : AppShadows.sm,
      borderColor: gradient ? null : AppColors.outline,
      gradient: gradient ? AppColors.brandGradient : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: gradient
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppColors.red50,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon,
                color: gradient ? Colors.white : AppColors.primary, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, height: 1.35, color: subtitleColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Assistant entry card
// ---------------------------------------------------------------------------

class _AssistantCard extends StatelessWidget {
  const _AssistantCard({required this.l10n, this.onTap});

  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      gradient: AppColors.brandGradientSoft,
      shadow: AppShadows.none,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Iconsax.message_question,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.assistantIntroTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: AppColors.red900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.assistantIntroSubtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: AppColors.red700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Iconsax.arrow_right_3, size: 18, color: AppColors.red700),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  final String title;
  final String actionText;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.sectionHeader),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
