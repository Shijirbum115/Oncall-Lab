import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/stores/locale_store.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// Compact inline segmented pill for language selection.
/// Designed to be embedded in profile headers, settings sections, or
/// auth screens — the single, consistent language control across the app.
class LanguageSegmentedPill extends StatelessWidget {
  const LanguageSegmentedPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPill('MN', '🇲🇳', localeStore.isMongolian, () {
              localeStore.changeLocale(const Locale('mn'));
            }),
            _buildPill('EN', '🇬🇧', localeStore.isEnglish, () {
              localeStore.changeLocale(const Locale('en'));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPill(
    String code,
    String flag,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              code,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
