import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.icon,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || loading;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    );
    final padding = const EdgeInsets.symmetric(horizontal: 24);

    return SizedBox(
      height: 52,
      width: fullWidth ? double.infinity : null,
      child: switch (variant) {
        AppButtonVariant.primary => ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              elevation: 0,
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(Colors.white),
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(AppColors.primary),
          ),
        AppButtonVariant.ghost => TextButton(
            onPressed: isDisabled ? null : onPressed,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(AppColors.primary),
          ),
        AppButtonVariant.danger => ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.error.withValues(alpha: 0.5),
              elevation: 0,
              padding: padding,
              shape: shape,
            ),
            child: _buildChild(Colors.white),
          ),
      },
    );
  }

  Widget _buildChild(Color color) {
    if (loading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    final text = Text(
      label,
      style: AppTypography.bodyMedium.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          text,
        ],
      );
    }

    return text;
  }
}
