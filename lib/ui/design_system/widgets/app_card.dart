import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_radius.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';

enum AppCardElevation { none, resting, raised, floating }

/// Canonical card surface. All card-shaped containers in the app go through this.
/// Replaces ad-hoc `Container(decoration: BoxDecoration(...))` patterns.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = AppRadius.md,
    this.elevation = AppCardElevation.resting,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final AppCardElevation elevation;

  List<BoxShadow> get _shadow {
    switch (elevation) {
      case AppCardElevation.none:
        return AppShadows.none;
      case AppCardElevation.resting:
        return AppShadows.resting;
      case AppCardElevation.raised:
        return AppShadows.raised;
      case AppCardElevation.floating:
        return AppShadows.floating;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: _shadow,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
