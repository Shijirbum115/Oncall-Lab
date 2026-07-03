import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/shared/widgets/tappable_card.dart';
import 'package:bugamed/l10n/app_localizations.dart';

/// Displays services in a 3-column grid of square buttons, grouped by category.
class ServiceCategoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final void Function(Map<String, dynamic> service) onServiceTap;
  final String? selectedCategory;

  const ServiceCategoryGrid({
    super.key,
    required this.services,
    required this.onServiceTap,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMn = l10n.localeName == 'mn';

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final service in services) {
      final categoryName = service['category_name'] as String? ?? '';
      grouped.putIfAbsent(categoryName, () => []).add(service);
    }

    final categories = selectedCategory != null
        ? [if (grouped.containsKey(selectedCategory)) selectedCategory!]
        : grouped.keys.toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, sectionIndex) {
          final category = categories[sectionIndex];
          final categoryServices = grouped[category] ?? [];
          if (categoryServices.isEmpty) return const SizedBox.shrink();

          final firstService = categoryServices.first;
          final categoryLabel = isMn
              ? (firstService['category_name_mn'] as String? ?? category)
              : category;

          final colorIndex = categories.indexOf(category);
          final categoryColor = AppColors.getServiceCategoryColor(colorIndex);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppPadding.screenH,
                  child: Text(categoryLabel, style: AppTypography.h3),
                ),
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: AppPadding.screenH,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 1,
                    ),
                    itemCount: categoryServices.length,
                    itemBuilder: (context, index) {
                      final service = categoryServices[index];
                      return _ServiceSquareTile(
                        service: service,
                        color: categoryColor,
                        isMn: isMn,
                        onTap: () => onServiceTap(service),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }
}

class _ServiceSquareTile extends StatelessWidget {
  final Map<String, dynamic> service;
  final Color color;
  final bool isMn;
  final VoidCallback onTap;

  const _ServiceSquareTile({
    required this.service,
    required this.color,
    required this.isMn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = isMn
        ? (service['service_name_mn'] as String? ??
            service['service_name'] as String)
        : service['service_name'] as String;

    return TappableCard(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                _getServiceIcon(service['category_icon'] as String?),
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                name,
                style: AppTypography.label.copyWith(
                  color: AppColors.ink,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _getServiceIcon(String? iconName) {
    switch (iconName) {
      case 'heart':
        return Iconsax.heart;
      case 'activity':
        return Iconsax.activity;
      case 'health':
        return Iconsax.health;
      case 'hospital':
        return Iconsax.hospital;
      case 'blood':
        return Iconsax.drop;
      case 'microscope':
        return Iconsax.microscope;
      case 'shield':
        return Iconsax.shield_tick;
      case 'flask':
        return Iconsax.filter;
      default:
        return Iconsax.health;
    }
  }
}
