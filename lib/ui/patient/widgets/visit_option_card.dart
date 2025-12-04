import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';

class VisitOptionCard extends StatelessWidget {
  const VisitOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
    this.iconFilled = false,
    this.iconSize = 24,
    this.iconWeight,
    this.elevated = true,
    this.showWavyPattern = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final bool iconFilled;
  final double iconSize;
  final FontWeight? iconWeight;
  final bool elevated;
  final bool showWavyPattern;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: elevated
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.06),
                blurRadius: elevated ? 20 : 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                if (showWavyPattern)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _WavyPatternPainter(
                        color: Colors.white,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: iconFilled
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : iconBackgroundColor,
                        child: Icon(
                          icon,
                          color: iconFilled ? AppColors.primary : iconColor,
                          size: iconSize,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WavyPatternPainter extends CustomPainter {
  _WavyPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint buildPaint(double opacity) => Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    Path buildWave(double startY, double amplitude) {
      final path = Path()..moveTo(-size.width * 0.4, startY);
      path.cubicTo(
        size.width * -0.05,
        startY - amplitude,
        size.width * 0.45,
        startY + amplitude * 1.2,
        size.width * 0.7,
        startY - amplitude * 0.6,
      );
      path.cubicTo(
        size.width * 0.9,
        startY - amplitude * 1.4,
        size.width * 1.2,
        startY + amplitude * 0.5,
        size.width * 1.5,
        startY - amplitude * 0.3,
      );
      return path;
    }

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(60 * 3.1415926535897932 / 180);
    canvas.translate(-size.width / 2, -size.height / 2);

    canvas.drawPath(buildWave(size.height * 0.1, 32), buildPaint(0.18));
    canvas.drawPath(buildWave(size.height * 0.45, 28), buildPaint(0.15));
    canvas.drawPath(buildWave(size.height * 0.8, 24), buildPaint(0.12));

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
