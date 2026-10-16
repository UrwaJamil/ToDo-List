import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import 'field_label.dart';

/// Labelled text field used by every form and by the Home search bar.
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  /// Message shown under the field when there is no error (e.g. "Email is
  /// available"), drawn in [helperColor].
  final String? helperText;
  final Color helperColor;
  final bool obscureText;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.hint,
    this.controller,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.helperColor = AppColors.textSecondary,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          FieldLabel(label!),
          const SizedBox(height: AppSizes.s),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLines: obscureText ? 1 : maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
            suffixIcon: suffixIcon,
            helperText: helperText,
            helperStyle: AppTextStyles.secondary.copyWith(color: helperColor),
            helperMaxLines: 2,
            errorMaxLines: 2,
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
