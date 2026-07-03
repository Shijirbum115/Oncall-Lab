import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// Canonical status pill for test-request lifecycle states.
class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.color,
  });

  factory AppStatusChip.fromStatus(
    RequestStatus status,
    AppLocalizations l10n,
  ) {
    final color = _colorForStatus(status);
    final label = _labelForStatus(status, l10n);
    return AppStatusChip(label: label, color: color);
  }

  factory AppStatusChip.fromString(
    String status,
    AppLocalizations l10n,
  ) {
    final parsed = _parseStatus(status);
    if (parsed != null) {
      return AppStatusChip.fromStatus(parsed, l10n);
    }
    return AppStatusChip(
      label: AppColors.getStatusText(status),
      color: AppColors.getStatusColor(status),
    );
  }

  final String label;
  final Color color;

  static Color _colorForStatus(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return AppColors.pending;
      case RequestStatus.accepted:
        return AppColors.accepted;
      case RequestStatus.onTheWay:
        return AppColors.onTheWay;
      case RequestStatus.sampleCollected:
        return AppColors.sampleCollected;
      case RequestStatus.deliveredToLab:
        return AppColors.deliveredToLab;
      case RequestStatus.completed:
        return AppColors.completed;
      case RequestStatus.cancelled:
        return AppColors.cancelled;
    }
  }

  static String _labelForStatus(RequestStatus status, AppLocalizations l10n) {
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

  static RequestStatus? _parseStatus(String s) {
    switch (s.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'accepted':
        return RequestStatus.accepted;
      case 'on_the_way':
      case 'ontheway':
        return RequestStatus.onTheWay;
      case 'sample_collected':
      case 'samplecollected':
        return RequestStatus.sampleCollected;
      case 'delivered_to_lab':
      case 'deliveredtolab':
        return RequestStatus.deliveredToLab;
      case 'completed':
        return RequestStatus.completed;
      case 'cancelled':
        return RequestStatus.cancelled;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
