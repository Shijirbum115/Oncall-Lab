import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// Maps a [RequestStatus] onto the patient-facing journey used by
/// [StatusTimeline]: position in the step list + localized labels.
class RequestJourney {
  RequestJourney._();

  /// Journey labels in order (cancelled is handled separately).
  static List<String> steps(AppLocalizations l10n) => [
        l10n.pending,
        l10n.accepted,
        l10n.onTheWay,
        l10n.sampleCollected,
        l10n.deliveredToLab,
        l10n.completed,
      ];

  static int indexOf(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return 0;
      case RequestStatus.accepted:
        return 1;
      case RequestStatus.onTheWay:
        return 2;
      case RequestStatus.sampleCollected:
        return 3;
      case RequestStatus.deliveredToLab:
        return 4;
      case RequestStatus.completed:
        return 5;
      case RequestStatus.cancelled:
        return 0; // unused — StatusTimeline renders cancelled separately
    }
  }

  static bool isCancelled(RequestStatus status) =>
      status == RequestStatus.cancelled;

  static String label(RequestStatus status, AppLocalizations l10n) {
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
