import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// Pill-style segmented filter used above request lists.
class AppSegmentedFilter extends StatelessWidget {
  const AppSegmentedFilter({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final List<String> segments;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: List.generate(segments.length, (i) {
          final isSelected = i == selected;
          return Expanded(
            child: Semantics(
              button: true,
              selected: isSelected,
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    boxShadow: isSelected ? AppShadows.sm : null,
                  ),
                  child: Text(
                    segments[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
