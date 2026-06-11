import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/doctor_request_store.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
import 'package:bugamed/ui/design_system/widgets/app_segmented_filter.dart';
import 'package:bugamed/ui/design_system/widgets/status_timeline.dart';
import 'package:bugamed/ui/doctor/doctor_request_detail_screen.dart';
import 'package:bugamed/ui/patient/widgets/request_journey.dart';
import 'package:bugamed/ui/shared/widgets/notification_bell.dart';

/// Doctor job board: available jobs to grab, jobs in progress, history.
class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  int _segment = 0;

  Future<void> _refresh() async {
    final doctorId = authStore.currentUser?.id;
    if (doctorId == null) return;
    switch (_segment) {
      case 0:
        await doctorRequestStore.loadAvailableRequests();
      case 1:
        await doctorRequestStore.loadMyActiveRequests(doctorId);
      default:
        await doctorRequestStore.loadMyCompletedRequests(doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.myDashboard, style: AppTypography.titleLarge),
                      const SizedBox(height: 4),
                      Observer(
                        builder: (_) => Text(
                          l10n.availableJobsCount(
                              doctorRequestStore.availableRequestsCount),
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const NotificationBell(),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: AppPadding.screenH,
            child: AppSegmentedFilter(
              segments: [
                l10n.availableTab,
                l10n.myRequestsTab,
                l10n.completedTab,
              ],
              selected: _segment,
              onChanged: (i) => setState(() => _segment = i),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    return Observer(
      builder: (_) {
        final requests = switch (_segment) {
          0 => doctorRequestStore.availableRequests,
          1 => doctorRequestStore.myActiveRequests,
          _ => doctorRequestStore.myCompletedRequests,
        };

        if (doctorRequestStore.isLoading && requests.isEmpty) {
          return Center(
            child: AppEmptyState(
              emotion: AppEmptyEmotion.loading,
              title: l10n.loading,
            ),
          );
        }

        if (requests.isEmpty) {
          final (emotion, title, subtitle) = switch (_segment) {
            0 => (
                AppEmptyEmotion.searching,
                l10n.noAvailableRequests,
                l10n.newRequestsWillAppear,
              ),
            1 => (
                AppEmptyEmotion.empty,
                l10n.noActiveRequests,
                l10n.acceptRequestToStart,
              ),
            _ => (
                AppEmptyEmotion.sleeping,
                l10n.noCompletedRequests,
                l10n.completedRequestsWillAppear,
              ),
          };

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: [
                const SizedBox(height: 40),
                AppEmptyState(
                  emotion: emotion,
                  title: title,
                  subtitle: subtitle,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            itemCount: requests.length,
            itemBuilder: (context, index) => _JobCard(
              request: requests[index],
              mode: switch (_segment) {
                0 => _JobCardMode.available,
                1 => _JobCardMode.active,
                _ => _JobCardMode.history,
              },
              l10n: l10n,
              onTap: () => _openDetail(requests[index]),
              onAccept: () => _accept(requests[index], l10n),
            ),
            separatorBuilder: (_, _) => const SizedBox(height: 14),
          ),
        );
      },
    );
  }

  void _openDetail(TestRequestModel request) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => DoctorRequestDetailScreen(request: request),
      ),
    );
  }

  Future<void> _accept(TestRequestModel request, AppLocalizations l10n) async {
    final doctorId = authStore.currentUser?.id;
    if (doctorId == null) return;

    final result = await doctorRequestStore.acceptRequest(
      requestId: request.id,
      doctorId: doctorId,
    );

    if (!mounted) return;
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.requestAcceptedSuccess),
          backgroundColor: AppColors.success,
        ),
      );
      _openDetail(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              doctorRequestStore.errorMessage ?? l10n.somethingWentWrong),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

enum _JobCardMode { available, active, history }

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.request,
    required this.mode,
    required this.l10n,
    required this.onTap,
    required this.onAccept,
  });

  final TestRequestModel request;
  final _JobCardMode mode;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final isLab = request.requestType == RequestType.labService;
    final title = isLab ? l10n.labTestCollection : l10n.homeServiceRequest;
    final typeLabel =
        isLab ? l10n.labTestServiceLabel : l10n.directHomeServiceLabel;

    if (mode == _JobCardMode.history) {
      return _HistoryRow(
        request: request,
        title: title,
        isLab: isLab,
        l10n: l10n,
        onTap: onTap,
      );
    }

    final statusColor =
        AppColors.getStatusColor(request.status.dbValue);

    return AppCard(
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _JobTypeIcon(isLab: isLab, size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(typeLabel, style: AppTypography.labelSmall),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.priceInMNT(request.doctorEarningsMnt),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (mode == _JobCardMode.active)
                _ChipBadge(
                  label: RequestJourney.label(request.status, l10n,
                      type: request.requestType),
                  color: statusColor,
                ),
              _PaymentChip(isPaid: request.isPaid, l10n: l10n),
              _InfoChip(
                icon: Iconsax.calendar_1,
                label: '${request.scheduledDate}'
                    '${request.scheduledTimeSlot != null ? ' · ${request.scheduledTimeSlot}' : ''}',
              ),
            ],
          ),
          if (mode == _JobCardMode.active) ...[
            const SizedBox(height: 14),
            StatusTimeline(
              steps: RequestJourney.steps(l10n, type: request.requestType),
              currentIndex: RequestJourney.indexOf(request.status,
                  type: request.requestType),
              cancelled: RequestJourney.isCancelled(request.status),
              compact: true,
            ),
          ],
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Iconsax.location,
                  size: 15, color: AppColors.textTertiary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  request.patientAddress,
                  style: AppTypography.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (mode == _JobCardMode.available) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: onAccept,
                        icon: const Icon(Iconsax.tick_circle, size: 18),
                        label: Text(
                          l10n.accept,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact history row for completed jobs.
class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.request,
    required this.title,
    required this.isLab,
    required this.l10n,
    required this.onTap,
  });

  final TestRequestModel request;
  final String title;
  final bool isLab;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = AppColors.getStatusColor(request.status.dbValue);

    return AppCard(
      borderRadius: AppRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      shadow: AppShadows.none,
      borderColor: AppColors.grey.withValues(alpha: 0.12),
      onTap: onTap,
      child: Row(
        children: [
          _JobTypeIcon(isLab: isLab, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  request.scheduledDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                l10n.priceInMNT(request.doctorEarningsMnt),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    RequestJourney.label(request.status, l10n,
                        type: request.requestType),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JobTypeIcon extends StatelessWidget {
  const _JobTypeIcon({required this.isLab, required this.size});

  final bool isLab;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      isLab
          ? 'assets/icons/hero/lab_test.png'
          : 'assets/icons/hero/doctor.png',
      width: size,
      height: size,
      errorBuilder: (_, _, _) => Icon(
        isLab ? Iconsax.drop : Iconsax.home_2,
        color: AppColors.primary,
        size: size * 0.5,
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({required this.isPaid, required this.l10n});

  final bool isPaid;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPaid ? Iconsax.tick_circle : Iconsax.clock,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            isPaid ? l10n.paid : l10n.awaitingPayment,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipBadge extends StatelessWidget {
  const _ChipBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
