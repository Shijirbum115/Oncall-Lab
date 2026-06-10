import 'package:flutter/material.dart';

/// Soft radial-gradient blob used as a decorative accent inside cards.
/// Reads as a blurred light bubble but costs nothing (no ImageFilter).
/// Place inside a ClipRRect'ed Stack with negative Positioned offsets so
/// the bubble bleeds off the card edge.
class BlurBubble extends StatelessWidget {
  const BlurBubble({
    super.key,
    required this.size,
    required this.color,
    this.alpha = 0.30,
  });

  final double size;
  final Color color;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
