import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import 'header_decoration.dart';

/// Full-width purple gradient header with a wavy bottom edge. It extends under
/// a transparent status bar (light icons) and pads [child] below it.
///
/// [backgroundBottomInset] lets the bottom of [child] hang below the purple
/// area, e.g. the Home stat cards that overlap the curve. Everything stays
/// inside this widget's bounds, so the overlapping part is still tappable.
class CurvedHeader extends StatelessWidget {
  final Widget child;
  final double backgroundBottomInset;
  final EdgeInsetsGeometry padding;
  final bool showDecoration;

  /// Put the decoration in the top-right corner instead of just above the
  /// wave. Use it for centred content (auth, profile) so it never sits
  /// behind text.
  final bool decorationAtTop;

  const CurvedHeader({
    super.key,
    required this.child,
    this.backgroundBottomInset = 0,
    this.padding = const EdgeInsets.fromLTRB(
      AppSizes.gutter,
      AppSizes.l,
      AppSizes.gutter,
      AppSizes.waveDepth + AppSizes.l,
    ),
    this.showDecoration = false,
    this.decorationAtTop = false,
  });

  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: backgroundBottomInset,
            child: ClipPath(
              clipper: const HeaderWaveClipper(),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: AppColors.headerGradient,
                ),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: const [
                    Positioned(
                      top: -AppSizes.huge,
                      left: -AppSizes.huge,
                      child: _Circle(size: AppSizes.backgroundWaveHeight),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showDecoration)
            Positioned(
              right: AppSizes.s,
              top: decorationAtTop ? topInset + AppSizes.s : null,
              bottom: decorationAtTop
                  ? null
                  : backgroundBottomInset + AppSizes.waveDepth,
              child: const IgnorePointer(child: HeaderDecoration()),
            ),
          // Content layer. Full width so centred content is centred on the
          // screen: a non-positioned Stack child only gets loose
          // constraints and would otherwise shrink and sit at the left.
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(top: topInset).add(padding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom edge of [CurvedHeader]: a soft double wave, [AppSizes.waveDepth]
/// deep.
class HeaderWaveClipper extends CustomClipper<Path> {
  const HeaderWaveClipper();

  @override
  Path getClip(Size size) {
    const depth = AppSizes.waveDepth;
    final w = size.width;
    final h = size.height;
    return Path()
      ..lineTo(0, h - depth * 0.35)
      ..cubicTo(
        w * 0.18,
        h + depth * 0.05,
        w * 0.36,
        h,
        w * 0.52,
        h - depth * 0.45,
      )
      ..cubicTo(
        w * 0.70,
        h - depth * 0.95,
        w * 0.86,
        h - depth * 0.9,
        w,
        h - depth * 0.55,
      )
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _Circle extends StatelessWidget {
  final double size;

  const _Circle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.decorativeCircle,
        shape: BoxShape.circle,
      ),
    );
  }
}
