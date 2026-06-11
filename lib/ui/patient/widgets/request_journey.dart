import 'package:bugamed/data/models/test_request_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// Maps a [RequestStatus] onto the journey used by [StatusTimeline]:
/// position in the step list + localized labels.
///
/// The journey is type-aware: direct home services have no lab leg, so the
/// `sample_collected` status represents "treatment given" and the journey
/// skips "delivered to lab".
class RequestJourney {
  RequestJourney._();

  /// Journey labels in order (cancelled is handled separately).
  static List<String> steps(AppLocalizations l10n,
      {RequestType type = RequestType.labService}) {
    if (type == RequestType.directService) {
      return [
        l10n.pending,
        l10n.accepted,
        l10n.onTheWay,
        l10n.treatmentDone,
        l10n.completed,
      ];
    }
    return [
      l10n.pending,
      l10n.accepted,
      l10n.onTheWay,
      l10n.sampleCollected,
      l10n.deliveredToLab,
      l10n.completed,
    ];
  }

  static int indexOf(RequestStatus status,
      {RequestType type = RequestType.labService}) {
    final isDirect = type == RequestType.directService;
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
        return 4; // not reachable for direct services
      case RequestStatus.completed:
        return isDirect ? 4 : 5;
      case RequestStatus.cancelled:
        return 0; // unused — StatusTimeline renders cancelled separately
    }
  }

  static bool isCancelled(RequestStatus status) =>
      status == RequestStatus.cancelled;

  static String label(RequestStatus status, AppLocalizations l10n,
      {RequestType type = RequestType.labService}) {
    switch (status) {
      case RequestStatus.pending:
        return l10n.pending;
      case RequestStatus.accepted:
        return l10n.accepted;
      case RequestStatus.onTheWay:
        return l10n.onTheWay;
      case RequestStatus.sampleCollected:
        return type == RequestType.directService
            ? l10n.treatmentDone
            : l10n.sampleCollected;
      case RequestStatus.deliveredToLab:
        return l10n.deliveredToLab;
      case RequestStatus.completed:
        return l10n.completed;
      case RequestStatus.cancelled:
        return l10n.cancelled;
    }
  }
}
