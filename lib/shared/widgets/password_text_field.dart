import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/constants/app_icons.dart';
import 'custom_text_field.dart';

/// Password field with a show/hide toggle, driven by an [RxBool] owned by
/// the controller. Rebuilds itself with Obx when [isObscured] changes.
class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final RxBool isObscured;
  final VoidCallback onToggleVisibility;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.isObscured,
    required this.onToggleVisibility,
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomTextField(
        controller: controller,
        label: label,
        hint: hint,
        prefixIcon: AppIcons.password,
        obscureText: isObscured.value,
        textInputAction: textInputAction,
        validator: validator,
        onSubmitted: onSubmitted,
        suffixIcon: IconButton(
          icon: Icon(
            isObscured.value ? AppIcons.visibility : AppIcons.visibilityOff,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
