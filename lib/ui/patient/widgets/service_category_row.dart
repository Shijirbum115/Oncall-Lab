import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/shared/widgets/category_icon.dart';

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
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isMn =
              Localizations.localeOf(context).languageCode == 'mn';
          final name = (isMn
                  ? (category['name_mn'] as String? ??
                      category['name'] as String?)
                  : category['name'] as String?) ??
              '';

          return GestureDetector(
            onTap: () => onCategoryTap(category),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CategoryIcon(
                    categoryName: category['name'] as String?,
                    iconName: category['icon'] as String?,
                    size: 54,
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

}
