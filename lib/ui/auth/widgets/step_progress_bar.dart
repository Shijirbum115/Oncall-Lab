import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    required this.icons,
    required this.labels,
  })  : assert(totalSteps == icons.length),
        assert(totalSteps == labels.length);

  final int totalSteps;
  final int currentStep;
  final List<IconData> icons;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final bool isActive = index <= currentStep;
            final bool leftActive = index - 1 < currentStep;
            final bool rightActive = index < currentStep;
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (index != 0)
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: leftActive
                                  ? AppColors.primary
                                  : AppColors.inkSubtle.withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xs),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 0),
                      _StepCircle(icon: icons[index], isActive: isActive),
                      if (index != totalSteps - 1)
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: rightActive
                                  ? AppColors.primary
                                  : AppColors.inkSubtle.withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.xs),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 0),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labels[index],
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.copyWith(
                      fontWeight: index <= currentStep
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: index <= currentStep
                          ? AppColors.primary
                          : AppColors.inkSubtle,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.icon, required this.isActive});

  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary
            : AppColors.inkSubtle.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: isActive ? AppColors.surface : AppColors.inkSubtle,
      ),
    );
  }
}
