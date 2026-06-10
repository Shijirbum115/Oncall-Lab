import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:iconsax/iconsax.dart';

/// Horizontal step indicator for the request journey.
///
/// The story is told by *position*, not hue: completed steps and the current
/// step are brand coral, future steps are neutral, the final completed state
/// turns green, and a cancelled request collapses into a single neutral row.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({
    super.key,
    required this.steps,
    required this.currentIndex,
    this.cancelled = false,
    this.cancelledLabel,
    this.compact = false,
  });

  /// Localized labels, in journey order.
  final List<String> steps;

  /// 0-based index of the current step. Values past the end mean "done".
  final int currentIndex;

  final bool cancelled;
  final String? cancelledLabel;

  /// Compact mode: dots + current label only (for list cards).
  final bool compact;

  bool get _isDone => !cancelled && currentIndex >= steps.length - 1;

  @override
  Widget build(BuildContext context) {
    if (cancelled) {
      return Row(
        children: [
          const Icon(Iconsax.close_circle, size: 18, color: AppColors.cancelled),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              cancelledLabel ?? '—',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.cancelled,
              ),
            ),
          ),
        ],
      );
    }

    final clamped = currentIndex.clamp(0, steps.length - 1);
    final activeColor = _isDone ? AppColors.success : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              _StepDot(
                state: i < clamped
                    ? _DotState.done
                    : i == clamped
                        ? _DotState.current
                        : _DotState.future,
                color: activeColor,
              ),
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2.5,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i < clamped
                          ? activeColor
                          : AppColors.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ],
        ),
        SizedBox(height: compact ? 8 : 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                steps[clamped],
                style: TextStyle(
                  fontSize: compact ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: activeColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${clamped + 1}/${steps.length}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum _DotState { done, current, future }

class _StepDot extends StatelessWidget {
  const _StepDot({required this.state, required this.color});

  final _DotState state;
  final Color color;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _DotState.done:
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 11, color: Colors.white),
        );
      case _DotState.current:
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.5),
          ),
          child: Center(
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        );
      case _DotState.future:
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outline, width: 2),
          ),
        );
    }
  }
}
