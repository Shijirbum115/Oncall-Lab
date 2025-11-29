import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/test_request_store.dart';
import 'package:oncall_lab/data/models/test_request_model.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';
import 'package:oncall_lab/ui/shared/widgets/app_card.dart';

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
      // Subscribe to real-time updates
      testRequestStore.subscribeToPatientRequests(user.id);
    }
  }

  Future<void> _refreshRequests() async {
    _subscribeToRequests();
    // Wait a bit for the stream to fetch initial data
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
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        if (testRequestStore.errorMessage != null) {
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
                    testRequestStore.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _refreshRequests,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.myRequests,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.requestHistory,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          indicatorPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          labelPadding: EdgeInsets.zero,
                          labelColor: Colors.white,
                          unselectedLabelColor:
                              AppColors.black.withValues(alpha: 0.6),
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
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
                      const SizedBox(height: 16),
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
      final iconData = switch (type) {
        'active' => Icons.calendar_today_outlined,
        'completed' => Icons.emoji_events_outlined,
        _ => Icons.cancel_outlined,
      };

      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: AppCard(
            borderRadius: 20,
            showShadow: false,
            backgroundColor: AppColors.grey.withValues(alpha: 0.08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, size: 48, color: AppColors.grey),
                const SizedBox(height: 16),
                Text(
                  switch (type) {
                    'active' => l10n.noActiveRequests,
                    'completed' => l10n.noCompletedRequests,
                    _ => l10n.noCancelledRequests,
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.requestHomeServicePrompt,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRequests,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
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
    final statusColor = AppColors.getStatusColor(statusKey);
    final statusLabel = _statusLabel(request.status, l10n);
    final typeInfo = _RequestTypeInfo.fromRequest(request, l10n);

    return AppCard(
      borderRadius: 18,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeInfo.tint,
                  borderRadius: BorderRadius.circular(12),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      typeInfo.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: typeInfo.iconColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _RequestMetaRow(
            icon: Icons.calendar_month_outlined,
            label: l10n.scheduledAt(
              request.scheduledDate,
              request.scheduledTimeSlot ?? '',
            ),
          ),
          const SizedBox(height: 8),
          _RequestMetaRow(
            icon: Icons.location_on_outlined,
            label: request.patientAddress,
          ),
          const SizedBox(height: 8),
          _RequestMetaRow(
            icon: Icons.payments_outlined,
            label: l10n.priceInMNT(request.priceMnt),
            valueStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          if (request.patientNotes != null &&
              request.patientNotes!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _RequestMetaRow(
              icon: Icons.note_alt_outlined,
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

  static String _statusLabel(RequestStatus status, AppLocalizations l10n) {
    switch (status) {
      case RequestStatus.pending:
        return l10n.pending;
      case RequestStatus.accepted:
        return l10n.accepted;
      case RequestStatus.onTheWay:
        return l10n.onTheWay;
      case RequestStatus.sampleCollected:
        return l10n.sampleCollected;
      case RequestStatus.deliveredToLab:
        return l10n.deliveredToLab;
      case RequestStatus.completed:
        return l10n.completed;
      case RequestStatus.cancelled:
        return l10n.cancelled;
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
        Icon(icon, size: 18, color: AppColors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
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
        icon: Icons.biotech_outlined,
        tint: Colors.blue.withValues(alpha: 0.1),
        iconColor: Colors.blue[700]!,
      );
    }

    return _RequestTypeInfo(
      label: l10n.directHomeServiceLabel,
      icon: Icons.home_work_outlined,
      tint: Colors.purple.withValues(alpha: 0.12),
      iconColor: Colors.purple[600]!,
    );
  }
}
