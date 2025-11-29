import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/ui/shared/widgets/app_card.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

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
          showShadow: false,
          borderRadius: 14,
          borderColor: selected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.2),
          backgroundColor: AppColors.primary.withValues(alpha: 0.05),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: onUseAddress,
            title: Text(
              address,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.grey,
            ),
          ),
        ),
        const SizedBox(height: 8),
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
