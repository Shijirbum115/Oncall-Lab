import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/test_request_store.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_status_chip.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';

class PatientRequestsScreen extends StatefulWidget {
  const PatientRequestsScreen({super.key});

  @override
  State<PatientRequestsScreen> createState() => _PatientRequestsScreenState();
}

class _PatientRequestsScreenState extends State<PatientRequestsScreen> {
  @override
  void initState() {
    super.initState();
    _subscribeToRequests();
  }

  void _subscribeToRequests() {
    final user = authStore.currentUser;
    if (user != null) {
      testRequestStore.subscribeToPatientRequests(user.id);
    }
  }

  Future<void> _refreshRequests() async {
    _subscribeToRequests();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    testRequestStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (_) {
        if (testRequestStore.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (testRequestStore.errorMessage != null) {
          return Center(
            child: SingleChildScrollView(
              child: MascotStateWidget(
                emotion: MascotEmotion.error,
                title: l10n.errorLoadingData,
                subtitle: testRequestStore.errorMessage!,
                actionText: l10n.retry,
                onAction: _refreshRequests,
              ),
            ),
          );
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: AppScreenHeader(
                  title: l10n.myRequests,
                  subtitle: l10n.requestHistory,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: AppPadding.screenH,
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          indicatorPadding: const EdgeInsets.symmetric(
                              horizontal: 4),
                          labelPadding: EdgeInsets.zero,
                          labelColor: Colors.white,
                          unselectedLabelColor:
                              AppColors.ink.withValues(alpha: 0.6),
                          labelStyle: AppTypography.bodySm
                              .copyWith(fontWeight: FontWeight.w600),
                          unselectedLabelStyle: AppTypography.bodySm,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    l10n.activeRequests,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    l10n.completedRequests,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: SizedBox(
                                height: 40,
                                child: Center(
                                  child: Text(
                                    l10n.cancelledCount,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: TabBarView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildRequestsList(
                              testRequestStore.activeRequests,
                              'active',
                              l10n,
                            ),
                            _buildRequestsList(
                              testRequestStore.completedRequests,
                              'completed',
                              l10n,
                            ),
                            _buildRequestsList(
                              testRequestStore.cancelledRequests,
                              'cancelled',
                              l10n,
                            ),
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

  Widget _buildRequestsList(
    List<TestRequestModel> requests,
    String type,
    AppLocalizations l10n,
  ) {
    if (requests.isEmpty) {
      final emotion = switch (type) {
        'active' => MascotEmotion.empty,
        'completed' => MascotEmotion.sleeping,
        _ => MascotEmotion.canceled,
      };

      final title = switch (type) {
        'active' => l10n.noActiveRequests,
        'completed' => l10n.noCompletedRequests,
        _ => l10n.noCancelledRequests,
      };

      return Center(
        child: SingleChildScrollView(
          child: MascotStateWidget(
            emotion: emotion,
            title: title,
            subtitle: l10n.requestHomeServicePrompt,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRequests,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.xs / 2, AppSpacing.md, 110),
        itemCount: requests.length,
        itemBuilder: (context, index) =>
            _RequestCard(request: requests[index], l10n: l10n),
        separatorBuilder: (_, unused) => const SizedBox(height: 14),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.l10n,
  });

  final TestRequestModel request;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final statusKey = _statusString(request.status);
    final typeInfo = _RequestTypeInfo.fromRequest(request, l10n);

    return AppCard(
      elevation: AppCardElevation.resting,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeInfo.tint,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(typeInfo.icon, color: typeInfo.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(l10n),
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      typeInfo.label,
                      style: AppTypography.bodySm.copyWith(
                        color: typeInfo.iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              AppStatusChip.fromString(statusKey, l10n),
            ],
          ),
          const SizedBox(height: 16),
          _RequestMetaRow(
            icon: Iconsax.calendar_1,
            label: l10n.scheduledAt(
              request.scheduledDate,
              request.scheduledTimeSlot ?? '',
            ),
          ),
          const SizedBox(height: 8),
          _RequestMetaRow(
            icon: Iconsax.location,
            label: request.patientAddress,
          ),
          const SizedBox(height: 8),
          _RequestMetaRow(
            icon: Iconsax.wallet_money,
            label: l10n.priceInMNT(request.priceMnt),
            valueStyle: AppTypography.body.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (request.patientNotes != null &&
              request.patientNotes!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _RequestMetaRow(
              icon: Iconsax.note_text,
              label: request.patientNotes!,
            ),
          ],
        ],
      ),
    );
  }

  String _title(AppLocalizations l10n) {
    return request.requestType == RequestType.labService
        ? l10n.labTestCollection
        : l10n.homeServiceRequest;
  }

  static String _statusString(RequestStatus status) {
    switch (status) {
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
}

class _RequestMetaRow extends StatelessWidget {
  const _RequestMetaRow({
    required this.icon,
    required this.label,
    this.valueStyle,
  });

  final IconData icon;
  final String label;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.inkSubtle),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: valueStyle ?? AppTypography.bodySm,
          ),
        ),
      ],
    );
  }
}

class _RequestTypeInfo {
  final String label;
  final IconData icon;
  final Color tint;
  final Color iconColor;

  _RequestTypeInfo({
    required this.label,
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  factory _RequestTypeInfo.fromRequest(
    TestRequestModel request,
    AppLocalizations l10n,
  ) {
    if (request.requestType == RequestType.labService) {
      return _RequestTypeInfo(
        label: l10n.labTestServiceLabel,
        icon: Iconsax.microscope,
        tint: AppColors.info.withValues(alpha: 0.12),
        iconColor: AppColors.info,
      );
    }

    return _RequestTypeInfo(
      label: l10n.directHomeServiceLabel,
      icon: Iconsax.home_2,
      tint: AppColors.primarySoft,
      iconColor: AppColors.primary,
    );
  }
}
