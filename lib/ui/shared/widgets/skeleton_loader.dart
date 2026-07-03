import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

/// A shimmer animation wrapper that sweeps a light gradient across its child.
class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.border,
                AppColors.background,
                AppColors.border,
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value.clamp(0.0, 1.0),
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A rectangular skeleton placeholder.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = AppRadius.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.inkSubtle.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// A circular skeleton placeholder.
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.inkSubtle.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Skeleton for a request card (used in requests_screen.dart).
class SkeletonRequestCard extends StatelessWidget {
  const SkeletonRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonBox(
                  width: 40,
                  height: 40,
                  borderRadius: AppRadius.sm,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(height: 16, width: 140),
                      SizedBox(height: 6),
                      SkeletonBox(height: 12, width: 100),
                    ],
                  ),
                ),
                const SkeletonBox(
                  width: 70,
                  height: 24,
                  borderRadius: AppRadius.lg,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const SkeletonBox(height: 14),
            const SizedBox(height: AppSpacing.xs),
            const SkeletonBox(height: 14),
            const SizedBox(height: AppSpacing.xs),
            const SkeletonBox(height: 14, width: 120),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the service category grid (3-column square tiles).
class SkeletonServiceGrid extends StatelessWidget {
  final int itemCount;

  const SkeletonServiceGrid({super.key, this.itemCount = 9});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.screen),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SkeletonBox(
                    width: 44,
                    height: 44,
                    borderRadius: AppRadius.sm,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBox(width: 60, height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
