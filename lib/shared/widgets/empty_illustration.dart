import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';
import 'header_decoration.dart';

/// Clipboard inside a soft lavender circle, with leaves, sparkle lines and a
/// small round badge ([badgeIcon], e.g. "+") on the clipboard.
class EmptyIllustration extends StatelessWidget {
  final IconData badgeIcon;
  final Color badgeColor;
  final double size;

  const EmptyIllustration({
    super.key,
    required this.badgeIcon,
    this.badgeColor = AppColors.primary,
    this.size = AppSizes.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final badge = size * 0.2;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _ClipboardPainter())),
          Positioned(
            right: size * 0.24,
            bottom: size * 0.17,
            child: Container(
              width: badge,
              height: badge,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: AppShadows.glow,
              ),
              child: Icon(badgeIcon, color: AppColors.white, size: badge * 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClipboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final center = Offset(s / 2, s / 2);

    // Soft lavender circle.
    canvas.drawCircle(
      center,
      s * 0.42,
      Paint()..color = AppColors.primaryLight,
    );

    // Leaves peeking out behind the clipboard.
    PainterShapes.leaf(
      canvas,
      Offset(s * 0.3, s * 0.82),
      s * 0.3,
      -0.7,
      AppColors.mint.withValues(alpha: 0.7),
    );
    PainterShapes.leaf(
      canvas,
      Offset(s * 0.27, s * 0.82),
      s * 0.22,
      -1.3,
      AppColors.lavenderSoft,
    );
    PainterShapes.leaf(
      canvas,
      Offset(s * 0.72, s * 0.84),
      s * 0.24,
      0.9,
      AppColors.lavenderSoft,
    );

    // Clipboard body.
    final board = RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.31, s * 0.24, s * 0.38, s * 0.5),
      Radius.circular(s * 0.06),
    );
    canvas
      ..drawRRect(
        board.shift(Offset(0, s * 0.02)),
        Paint()..color = AppColors.shadowCard,
      )
      ..drawRRect(board, Paint()..color = AppColors.white)
      ..drawRRect(
        board,
        Paint()
          ..color = AppColors.lavender
          ..style = PaintingStyle.stroke
          ..strokeWidth = s * 0.012,
      );

    // Clip at the top.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(s * 0.42, s * 0.2, s * 0.16, s * 0.08),
        Radius.circular(s * 0.03),
      ),
      Paint()..color = AppColors.primary,
    );

    // Checklist rows: a small box and a line each.
    final line = Paint()
      ..color = AppColors.lavenderPale
      ..strokeWidth = s * 0.024
      ..strokeCap = StrokeCap.round;
    final box = Paint()..color = AppColors.lavenderSoft;
    for (var i = 0; i < 3; i++) {
      final y = s * (0.37 + i * 0.1);
      canvas
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(s * 0.39, y),
              width: s * 0.045,
              height: s * 0.045,
            ),
            Radius.circular(s * 0.01),
          ),
          box,
        )
        ..drawLine(Offset(s * 0.45, y), Offset(s * (0.62 - i * 0.04), y), line);
    }

    // Sparkle lines and stars around the circle.
    final shine = Paint()
      ..color = AppColors.lavender
      ..strokeWidth = s * 0.014
      ..strokeCap = StrokeCap.round;
    PainterShapes.shine(canvas, Offset(s * 0.2, s * 0.24), s * 0.12, shine);
    PainterShapes.shine(canvas, Offset(s * 0.84, s * 0.22), s * 0.1, shine);
    final star = Paint()..color = AppColors.lavenderSoft;
    PainterShapes.sparkle(canvas, Offset(s * 0.88, s * 0.5), s * 0.05, star);
    PainterShapes.sparkle(canvas, Offset(s * 0.1, s * 0.56), s * 0.035, star);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
