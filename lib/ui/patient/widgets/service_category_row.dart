import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';

/// Horizontal scrollable row of service category cards for the home screen.
/// Replaces the auto-scrolling carousel (a UX anti-pattern).
class ServiceCategoryRow extends StatelessWidget {
  const ServiceCategoryRow({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<Map<String, dynamic>> categories;
  final void Function(Map<String, dynamic> category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: AppPadding.screenH,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = AppColors.getServiceCategoryColor(index);
          final name = category['name'] as String? ?? '';
          final icon = _getCategoryIcon(category['icon'] as String?);

          return AppCard(
            onTap: () => onCategoryTap(category),
            padding: EdgeInsets.zero,
            shadow: AppShadows.none,
            borderColor: AppColors.grey.withValues(alpha: 0.12),
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      name,
                      style: AppTypography.caption.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static IconData _getCategoryIcon(String? iconName) {
    return switch (iconName) {
      'heart' => Iconsax.heart,
      'activity' => Iconsax.activity,
      'health' => Iconsax.health,
      'hospital' => Iconsax.hospital,
      'blood' => Iconsax.drop,
      'microscope' => Iconsax.microscope,
      'shield' => Iconsax.shield_tick,
      'flask' => Iconsax.filter,
      _ => Iconsax.health,
    };
  }
}
