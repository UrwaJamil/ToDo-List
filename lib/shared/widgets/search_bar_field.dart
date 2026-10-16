import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_text_styles.dart';

/// White, fully rounded search field with a soft shadow.
class SearchBarField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  /// e.g. a clear button, shown at the end of the field.
  final Widget? suffix;

  const SearchBarField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.searchHeight,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.searchRadius),
        boxShadow: AppShadows.soft,
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: const Icon(AppIcons.search, color: AppColors.primary),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
