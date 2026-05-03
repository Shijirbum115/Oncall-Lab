import 'package:flutter/widgets.dart';
import 'package:bugamed/data/models/service_model.dart';
import 'package:bugamed/l10n/app_localizations.dart';

extension ServiceModelExtension on ServiceModel {
  String getLocalizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (l10n.localeName == 'mn' && nameMn != null) {
      return nameMn!;
    }
    return name;
  }

  String? getLocalizedDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (l10n.localeName == 'mn' && descriptionMn != null) {
      return descriptionMn!;
    }
    return description;
  }
}
