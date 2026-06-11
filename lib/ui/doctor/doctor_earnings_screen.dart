import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/doctor_request_store.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_empty_state.dart';
import 'package:bugamed/ui/doctor/doctor_request_detail_screen.dart';

/// Earnings tab: period totals up top, the jobs that earned them below.
class DoctorEarningsScreen extends StatelessWidget {
  const DoctorEarningsScreen({super.key});

  Future<void> _refresh() async {
    final doctorId = authStore.currentUser?.id;
    if (doctorId != null) {
      await doctorRequestStore.loadMyCompletedRequests(doctorId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      bottom: false,
      child: Observer(
        builder: (_) {
          final completed = doctorRequestStore.myCompletedRequests;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                Text(l10n.earnings, style: AppTypography.titleLarge),
                const SizedBox(height: 4),
                Text(
                  l10n.completedJobsCount(completed.length),
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),

                // Hero card: this month's earnings on the brand gradient
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: AppShadows.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.thisMonth,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.priceInMNT(doctorRequestStore.monthEarningsMnt),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: _PeriodCard(
                        label: l10n.today,
                        amount: l10n
                            .priceInMNT(doctorRequestStore.todayEarningsMnt),
                        icon: Iconsax.sun_1,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _PeriodCard(
                        label: l10n.thisWeek,
                        amount: l10n
                            .priceInMNT(doctorRequestStore.weekEarningsMnt),
                        icon: Iconsax.calendar_1,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _PeriodCard(
                        label: l10n.allTime,
                        amount: l10n
                            .priceInMNT(doctorRequestStore.totalEarningsMnt),
                        icon: Iconsax.chart_2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                Text(l10n.completedJobs, style: AppTypography.sectionHeader),
                const SizedBox(height: AppSpacing.sm),

                if (completed.isEmpty)
                  AppEmptyState(
                    emotion: AppEmptyEmotion.sleeping,
                    title: l10n.noEarningsYet,
                    subtitle: l10n.completeJobsToEarn,
                  )
                else
                  ...completed.map(
                    (request) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _EarningRow(request: request, l10n: l10n),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({
    required this.label,
    required this.amount,
    required this.icon,
  });

  final String label;
  final String amount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningRow extends StatelessWidget {
  const _EarningRow({required this.request, required this.l10n});

  final TestRequestModel request;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isLab = request.requestType == RequestType.labService;

    return AppCard(
      borderRadius: AppRadius.md,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shadow: AppShadows.none,
      borderColor: AppColors.grey.withValues(alpha: 0.12),
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => DoctorRequestDetailScreen(request: request),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Icon(
              isLab ? Iconsax.drop : Iconsax.home_2,
              size: 18,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLab ? l10n.labTestCollection : l10n.homeServiceRequest,
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
          Text(
            '+${l10n.priceInMNT(request.doctorEarningsMnt)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}
