import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';

/// Soft lavender wave shapes for the bottom-left corner of a screen. Place it
/// first in a Stack so content is drawn on top; it ignores touches.
class BackgroundWaves extends StatelessWidget {
  const BackgroundWaves({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      bottom: 0,
      child: IgnorePointer(
        child: CustomPaint(
          size: Size(
            AppSizes.backgroundWaveWidth,
            AppSizes.backgroundWaveHeight,
          ),
          painter: _WavesPainter(),
        ),
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  const _WavesPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.2)
        ..cubicTo(w * 0.35, h * 0.05, w * 0.45, h * 0.55, w * 0.8, h * 0.6)
        ..quadraticBezierTo(w * 0.95, h * 0.62, w, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = AppColors.waveLight,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h * 0.55)
        ..cubicTo(w * 0.25, h * 0.4, w * 0.4, h * 0.85, w * 0.65, h)
        ..lineTo(0, h)
        ..close(),
      Paint()..color = AppColors.waveDeep,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
