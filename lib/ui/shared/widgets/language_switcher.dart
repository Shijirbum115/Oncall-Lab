import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/stores/locale_store.dart';

/// Simple circular flag-style language toggle
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFlagButton(
            '🇲🇳',
            'MN',
            localeStore.isMongolian,
            () => localeStore.changeLocale(const Locale('mn')),
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildFlagButton(
            '🇬🇧',
            'EN',
            localeStore.isEnglish,
            () => localeStore.changeLocale(const Locale('en')),
          ),
        ],
      ),
    );
  }

  Widget _buildFlagButton(
    String flag,
    String code,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.inkSubtle.withValues(alpha: 0.1),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            flag,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

/// Simple icon-based language toggle button
class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => IconButton(
        onPressed: () => localeStore.toggleLocale(),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Text(
            localeStore.currentLocale.languageCode.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet for language settings
class LanguageSettingsSheet extends StatelessWidget {
  const LanguageSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.inkSubtle.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Title
          Text(
            'Language / Хэл',
            style: AppTypography.h3.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Language selector
          const LanguageSwitcher(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
