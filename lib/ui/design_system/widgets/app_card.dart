import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bugamed/ui/design_system/app_shadows.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// Unified card surface for the design system.
///
/// When [onTap] is null it renders a static card. When [onTap] is provided it
/// adds a scale-down (0.97) press animation plus a light haptic on tap.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor = Colors.white,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius,
    this.shadow,
    this.gradient,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double? borderRadius;
  final List<BoxShadow>? shadow;

  /// When set, the card surface uses this gradient instead of
  /// [backgroundColor].
  final Gradient? gradient;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  bool get _isTappable => widget.onTap != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppRadius.md;
    final resolvedShadow = widget.shadow ?? AppShadows.sm;

    Widget content = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.gradient == null ? widget.backgroundColor : null,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(radius),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
            : null,
        boxShadow: resolvedShadow,
      ),
      child: widget.child,
    );

    if (_isTappable) {
      content = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) =>
              Transform.scale(scale: _scaleAnimation.value, child: child),
          child: content,
        ),
      );
    }

    if (widget.margin != null) {
      content = Padding(padding: widget.margin!, child: content);
    }

    return content;
  }
}
