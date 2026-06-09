import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// Horizontal scrollable pill bar for filtering a list by category.
/// A leading "All" pill (passing `null`) clears the filter.
class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.allLabel = 'All',
  });

  final List<String> categories;
  final String? selectedCategory;
  final void Function(String? category) onCategorySelected;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: AppPadding.screenH,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length + 1, // +1 for "All"
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final category = isAll ? null : categories[index - 1];
          final label = isAll ? allLabel : category!;
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
