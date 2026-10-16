import 'package:flutter/material.dart';

import '../../app/constants/app_sizes.dart';

/// Scrollable page: a [header] (usually a [CurvedHeader]) with [body] pulled
/// up by [overlap] so its first card sits on the curve. Tapping outside a
/// field closes the keyboard.
class HeaderCardLayout extends StatelessWidget {
  final Widget header;
  final Widget body;
  final double overlap;
  final double bottomPadding;

  const HeaderCardLayout({
    super.key,
    required this.header,
    required this.body,
    this.overlap = AppSizes.cardOverlap,
    this.bottomPadding = AppSizes.xxl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            // The space freed by the shift ends up at the bottom, which only
            // adds a little scroll room.
            Transform.translate(
              offset: Offset(0, -overlap),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
