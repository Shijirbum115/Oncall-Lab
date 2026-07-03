import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_button.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_status_chip.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/doctor_request_store.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/ui/doctor/doctor_request_detail_screen.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';
import 'package:bugamed/ui/shared/widgets/notification_bell.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _subscribeToRequests();
  }

  void _subscribeToRequests() {
    final doctorId = authStore.currentUser?.id;
    if (doctorId != null) {
      // Subscribe to real-time available requests
      doctorRequestStore.subscribeToAvailableRequests();

      // Subscribe to real-time active requests
      doctorRequestStore.subscribeToMyActiveRequests(doctorId);

      // Load completed requests (one-time, doesn't need real-time)
      doctorRequestStore.loadMyCompletedRequests(doctorId);
    }
  }

  @override
  void dispose() {
    doctorRequestStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (_) {
        if (doctorRequestStore.isLoading &&
            doctorRequestStore.availableRequests.isEmpty &&
            doctorRequestStore.myActiveRequests.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: AppScreenHeader(
                  title: l10n.myDashboard,
                  trailing: const NotificationBell(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: AppPadding.screenH,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.border.withValues(alpha: 0.5),
                            borderRadius:
                                BorderRadius.circular(AppRadius.sm),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final tabWidth =
                                  (constraints.maxWidth - 12) / 3;
                              return TabBar(
                                indicatorColor: AppColors.primary,
                                unselectedLabelColor:
                                    AppColors.ink.withValues(alpha: 0.6),
                                labelStyle: AppTypography.bodySm.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelStyle: AppTypography.bodySm,
                                labelColor: AppColors.surface,
                                dividerColor: Colors.transparent,
                                indicator: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.sm),
                                ),
                                tabs: [
                                  SizedBox(
                                    width: tabWidth,
                                    child: Tab(text: l10n.availableTab),
                                  ),
                                  SizedBox(
                                    width: tabWidth,
                                    child: Tab(text: l10n.myRequestsTab),
                                  ),
                                  SizedBox(
                                    width: tabWidth,
                                    child: Tab(text: l10n.completedTab),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _buildAvailableRequestsList(l10n),
                            _buildMyRequestsList(l10n),
                            _buildCompletedRequestsList(l10n),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvailableRequestsList(AppLocalizations l10n) {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.availableRequests.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: MascotStateWidget(
                emotion: MascotEmotion.empty,
                title: l10n.noAvailableRequests,
                subtitle: l10n.newRequestsWillAppear,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => doctorRequestStore.loadAvailableRequests(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xs / 2, AppSpacing.md, 110),
            itemCount: doctorRequestStore.availableRequests.length,
            separatorBuilder: (_, unused) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final request = doctorRequestStore.availableRequests[index];
              return _RequestCard(
                request: request,
                showAcceptButton: true,
                onTap: () => _navigateToDetail(request),
                l10n: l10n,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMyRequestsList(AppLocalizations l10n) {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.myActiveRequests.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: MascotStateWidget(
                emotion: MascotEmotion.sleeping,
                title: l10n.noActiveRequests,
                subtitle: l10n.acceptRequestToStart,
              ),
            ),
          );
        }

        final doctorId = authStore.currentUser?.id;
        return RefreshIndicator(
          onRefresh: () => doctorRequestStore.loadMyActiveRequests(doctorId!),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xs / 2, AppSpacing.md, 110),
            itemCount: doctorRequestStore.myActiveRequests.length,
            separatorBuilder: (_, unused) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final request = doctorRequestStore.myActiveRequests[index];
              return _RequestCard(
                request: request,
                onTap: () => _navigateToDetail(request),
                l10n: l10n,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCompletedRequestsList(AppLocalizations l10n) {
    return Observer(
      builder: (_) {
        if (doctorRequestStore.myCompletedRequests.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: MascotStateWidget(
                emotion: MascotEmotion.happy,
                title: l10n.noCompletedRequests,
                subtitle: l10n.completedRequestsWillAppear,
              ),
            ),
          );
        }

        final doctorId = authStore.currentUser?.id;
        return RefreshIndicator(
          onRefresh: () =>
              doctorRequestStore.loadMyCompletedRequests(doctorId!),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.xs / 2, AppSpacing.md, 110),
            itemCount: doctorRequestStore.myCompletedRequests.length,
            separatorBuilder: (_, unused) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final request = doctorRequestStore.myCompletedRequests[index];
              return _RequestCard(
                request: request,
                onTap: () => _navigateToDetail(request),
                l10n: l10n,
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToDetail(TestRequestModel request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorRequestDetailScreen(request: request),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final TestRequestModel request;
  final VoidCallback onTap;
  final bool showAcceptButton;
  final AppLocalizations l10n;

  const _RequestCard({
    required this.request,
    required this.onTap,
    required this.l10n,
    this.showAcceptButton = false,
  });

  String _getStatusString() {
    switch (request.status) {
      case RequestStatus.pending:
        return 'pending';
      case RequestStatus.accepted:
        return 'accepted';
      case RequestStatus.onTheWay:
        return 'on_the_way';
      case RequestStatus.sampleCollected:
        return 'sample_collected';
      case RequestStatus.deliveredToLab:
        return 'delivered_to_lab';
      case RequestStatus.completed:
        return 'completed';
      case RequestStatus.cancelled:
        return 'cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusStr = _getStatusString();
    final isLab = request.requestType == RequestType.labService;
    final typeTint = isLab ? AppColors.info : AppColors.primary;

    return AppCard(
      elevation: AppCardElevation.resting,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeTint.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    isLab
                        ? l10n.labTestServiceLabel
                        : l10n.directHomeServiceLabel,
                    style: AppTypography.label.copyWith(
                      color: typeTint,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppStatusChip.fromString(statusStr, l10n),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Iconsax.calendar_1,
                size: 16,
                color: AppColors.inkSubtle,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${l10n.scheduled}: ${request.scheduledDate} ${request.scheduledTimeSlot ?? ''}',
                  style: AppTypography.bodySm,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Iconsax.location,
                size: 16,
                color: AppColors.inkSubtle,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  request.patientAddress,
                  style: AppTypography.bodySm,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.priceMnt(request.priceMnt),
                style: AppTypography.bodyLg.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
              if (showAcceptButton)
                AppButton(
                  label: l10n.accept,
                  variant: AppButtonVariant.primary,
                  fullWidth: false,
                  onPressed: () async {
                    final result = await doctorRequestStore.acceptRequest(
                      requestId: request.id,
                    );

                    if (!context.mounted) return;
                    if (result != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.requestAcceptedSuccess),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else {
                      final reason = doctorRequestStore.errorMessage ?? '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(reason),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
