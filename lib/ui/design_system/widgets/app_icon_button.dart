import 'package:flutter/material.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// Consistent rounded-square icon button: white surface, soft outline.
/// Used in headers (notifications, avatar, back) so all tappable squares
/// share one visual weight.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.icon,
    this.child,
    this.onTap,
    this.size = 46,
    this.iconColor = AppColors.textPrimary,
    this.semanticLabel,
  }) : assert(icon != null || child != null);

  final IconData? icon;

  /// Custom content (e.g. an avatar) rendered inside the bordered square.
  final Widget? child;
  final VoidCallback? onTap;
  final double size;
  final Color iconColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outline),
          ),
          clipBehavior: Clip.antiAlias,
          child: child ??
              Icon(icon, size: size * 0.46, color: iconColor),
        ),
      ),
    );
  }
}
