import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/test_request_store.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
import 'package:bugamed/ui/design_system/widgets/status_timeline.dart';
import 'package:bugamed/ui/patient/widgets/request_journey.dart';

/// Bookings tab: the patient's request history built around the
/// status journey.
class PatientRequestsScreen extends StatefulWidget {
  const PatientRequestsScreen({super.key});

  @override
  State<PatientRequestsScreen> createState() => _PatientRequestsScreenState();
}

class _PatientRequestsScreenState extends State<PatientRequestsScreen> {
  int _segment = 0;

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
    final user = authStore.currentUser;
    if (user != null) {
      await testRequestStore.loadPatientRequests(user.id);
    }
  }

  // NOTE: testRequestStore is an app-wide singleton — it must not be
  // disposed here (home shares the same subscription).

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Observer(
      builder: (_) {
        return SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.myRequests, style: AppTypography.titleLarge),
                    const SizedBox(height: 4),
                    Text(l10n.requestHistory, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: AppPadding.screenH,
                child: _SegmentedFilter(
                  segments: [
                    l10n.activeShort,
                    l10n.completed,
                    l10n.cancelled,
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
      },
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (testRequestStore.isLoading && testRequestStore.patientRequests.isEmpty) {
      return Center(
        child: AppEmptyState(
          emotion: AppEmptyEmotion.loading,
          title: l10n.loading,
        ),
      );
    }

    if (testRequestStore.errorMessage != null &&
        testRequestStore.patientRequests.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: AppEmptyState(
            emotion: AppEmptyEmotion.error,
            title: l10n.somethingWentWrong,
            subtitle: l10n.pleaseTryAgainLater,
            actionText: l10n.retry,
            onAction: _refreshRequests,
          ),
        ),
      );
    }

    final requests = switch (_segment) {
      0 => testRequestStore.activeRequests,
      1 => testRequestStore.completedRequests,
      _ => testRequestStore.cancelledRequests,
    };

    if (requests.isEmpty) {
      final emotion = switch (_segment) {
        0 => AppEmptyEmotion.empty,
        1 => AppEmptyEmotion.sleeping,
        _ => AppEmptyEmotion.canceled,
      };
      final title = switch (_segment) {
        0 => l10n.noActiveRequests,
        1 => l10n.noCompletedRequests,
        _ => l10n.noCancelledRequests,
      };

      return RefreshIndicator(
        onRefresh: _refreshRequests,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            const SizedBox(height: 40),
            AppEmptyState(
              emotion: emotion,
              title: title,
              subtitle: l10n.requestHomeServicePrompt,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshRequests,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        itemCount: requests.length,
        itemBuilder: (context, index) =>
            _RequestCard(request: requests[index], l10n: l10n),
        separatorBuilder: (_, _) => const SizedBox(height: 14),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Segmented filter
// ---------------------------------------------------------------------------

class _SegmentedFilter extends StatelessWidget {
  const _SegmentedFilter({
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<String> segments;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: List.generate(segments.length, (i) {
          final isSelected = i == selected;
          return Expanded(
            child: Semantics(
              button: true,
              selected: isSelected,
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    boxShadow: isSelected ? AppShadows.sm : null,
                  ),
                  child: Text(
                    segments[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Request card
// ---------------------------------------------------------------------------

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request, required this.l10n});

  final TestRequestModel request;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isLab = request.requestType == RequestType.labService;
    final title = isLab ? l10n.labTestCollection : l10n.homeServiceRequest;
    final typeLabel =
        isLab ? l10n.labTestServiceLabel : l10n.directHomeServiceLabel;

    final statusColor = AppColors.getStatusColor(_statusKey(request.status));

    return AppCard(
      borderRadius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  isLab ? Iconsax.drop : Iconsax.home_2,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
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
            ],
          ),
          const SizedBox(height: 14),

          // Status badge + date chip (scannable order-state row)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusBadge(
                label: RequestJourney.label(request.status, l10n),
                color: statusColor,
              ),
              _InfoChip(
                icon: Iconsax.calendar_1,
                label: '${request.scheduledDate}'
                    '${request.scheduledTimeSlot != null ? ' · ${request.scheduledTimeSlot}' : ''}',
              ),
            ],
          ),
          const SizedBox(height: 14),
          StatusTimeline(
            steps: RequestJourney.steps(l10n),
            currentIndex: RequestJourney.indexOf(request.status),
            cancelled: RequestJourney.isCancelled(request.status),
            cancelledLabel:
                '${l10n.cancelled}${request.cancellationReason != null ? ' · ${request.cancellationReason}' : ''}',
            compact: true,
          ),
          const SizedBox(height: 14),
          _MetaRow(icon: Iconsax.location, label: request.patientAddress),
          if (request.patientNotes != null &&
              request.patientNotes!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _MetaRow(icon: Iconsax.note_1, label: request.patientNotes!),
          ],
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.totalAmount, style: AppTypography.bodySmall),
              Text(
                l10n.priceInMNT(request.priceMnt),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _statusKey(RequestStatus status) {
    return switch (status) {
      RequestStatus.pending => 'pending',
      RequestStatus.accepted => 'accepted',
      RequestStatus.onTheWay => 'on_the_way',
      RequestStatus.sampleCollected => 'sample_collected',
      RequestStatus.deliveredToLab => 'delivered_to_lab',
      RequestStatus.completed => 'completed',
      RequestStatus.cancelled => 'cancelled',
    };
  }
}

/// FreshPack-style state pill: solid dot + uppercase label on a tonal bg.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        // Elevated chip: colored glow instead of a flat border
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
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 4,
                ),
              ],
            ),
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

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
