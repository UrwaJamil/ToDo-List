import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';

/// Small leaf-and-sparkle illustration for the right side of the purple
/// header. Drawn with shapes, so no image asset is needed.
class HeaderDecoration extends StatelessWidget {
  final double size;

  const HeaderDecoration({super.key, this.size = AppSizes.headerDecoration});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.square(size), painter: _LeafSparklePainter());
  }
}

class _LeafSparklePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final base = Offset(s * 0.62, s * 0.98);

    final stem = Paint()
      ..color = AppColors.leafLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.025
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(base.dx, base.dy)
        ..quadraticBezierTo(s * 0.58, s * 0.6, s * 0.7, s * 0.2),
      stem,
    );

    PainterShapes.leaf(
      canvas,
      Offset(s * 0.6, s * 0.72),
      s * 0.34,
      -0.9,
      AppColors.leafDark,
    );
    PainterShapes.leaf(
      canvas,
      Offset(s * 0.64, s * 0.55),
      s * 0.3,
      0.8,
      AppColors.leafLight,
    );
    PainterShapes.leaf(
      canvas,
      Offset(s * 0.68, s * 0.34),
      s * 0.24,
      -0.6,
      AppColors.leafLight,
    );

    final sparkle = Paint()..color = AppColors.sparkle;
    PainterShapes.sparkle(canvas, Offset(s * 0.2, s * 0.3), s * 0.11, sparkle);
    PainterShapes.sparkle(
      canvas,
      Offset(s * 0.92, s * 0.12),
      s * 0.07,
      sparkle,
    );
    PainterShapes.sparkle(canvas, Offset(s * 0.3, s * 0.78), s * 0.05, sparkle);
    canvas.drawCircle(Offset(s * 0.06, s * 0.6), s * 0.025, sparkle);
    canvas.drawCircle(Offset(s * 0.95, s * 0.5), s * 0.02, sparkle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Reusable shapes for the decorative painters (header and empty state).
class PainterShapes {
  PainterShapes._();

  /// A leaf growing from [base] with [length], rotated by [angle] radians.
  static void leaf(
    Canvas canvas,
    Offset base,
    double length,
    double angle,
    Color color,
  ) {
    final width = length * 0.42;
    canvas
      ..save()
      ..translate(base.dx, base.dy)
      ..rotate(angle);
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(width, -length / 2, 0, -length)
        ..quadraticBezierTo(-width, -length / 2, 0, 0),
      Paint()..color = color,
    );
    canvas.drawLine(
      Offset.zero,
      Offset(0, -length * 0.8),
      Paint()
        ..color = AppColors.decorativeCircle
        ..strokeWidth = length * 0.04,
    );
    canvas.restore();
  }

  /// A four-pointed sparkle (curved star) centred on [c].
  static void sparkle(Canvas canvas, Offset c, double r, Paint paint) {
    canvas.drawPath(
      Path()
        ..moveTo(c.dx, c.dy - r)
        ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
        ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
        ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
        ..close(),
      paint,
    );
  }

  /// Short lines radiating from [c], like a little "shine" mark.
  static void shine(Canvas canvas, Offset c, double r, Paint paint) {
    for (var i = 0; i < 3; i++) {
      final a = -math.pi / 2 - 0.6 + i * 0.6;
      canvas.drawLine(
        c + Offset(math.cos(a), math.sin(a)) * r * 0.55,
        c + Offset(math.cos(a), math.sin(a)) * r,
        paint,
      );
    }
  }
}
