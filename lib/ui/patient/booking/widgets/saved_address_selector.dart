import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class SavedAddressSelector extends StatelessWidget {
  const SavedAddressSelector({
    super.key,
    required this.address,
    required this.selected,
    required this.onUseAddress,
    required this.onManualEntry,
  });

  final String address;
  final bool selected;
  final VoidCallback onUseAddress;
  final VoidCallback onManualEntry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          elevation: AppCardElevation.none,
          borderRadius: AppRadius.sm,
          borderColor: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.2),
          backgroundColor: AppColors.primarySoft,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: onUseAddress,
            title: Text(
              address,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.inkSubtle,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton.icon(
          onPressed: selected ? onManualEntry : onUseAddress,
          icon: Icon(
            selected ? Icons.edit_location_alt : Icons.check_circle,
          ),
          label: Text(
            selected ? l10n.typeDifferentAddress : l10n.useSavedAddress,
          ),
        ),
      ],
    );
  }
}
