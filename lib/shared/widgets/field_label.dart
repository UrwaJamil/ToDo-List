import 'package:flutter/material.dart';

import '../../app/theme/app_text_styles.dart';

/// Bold label shown above a form input (text fields, priority selector).
class FieldLabel extends StatelessWidget {
  final String text;

  const FieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.label);
  }
}
