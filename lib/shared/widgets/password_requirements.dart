import 'package:flutter/material.dart';

import '../../app/constants/app_colors.dart';
import '../../app/constants/app_icons.dart';
import '../../app/constants/app_sizes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/utils/validators.dart';

/// Live checklist of every [PasswordRule]. Each line turns green with a
/// check icon once [password] satisfies it. Wrap it in Obx and pass the
/// controller's RxString value so it updates while the user types.
class PasswordRequirements extends StatelessWidget {
  final String password;

  const PasswordRequirements({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final rule in PasswordRule.values)
          _RequirementRow(label: rule.label, isMet: rule.isMetBy(password)),
      ],
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementRow({required this.label, required this.isMet});

  @override
  Widget build(BuildContext context) {
    final color = isMet ? AppColors.ruleMet : AppColors.ruleUnmet;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xxs),
      child: Row(
        children: [
          Icon(
            isMet ? AppIcons.ruleMet : AppIcons.ruleUnmet,
            size: AppSizes.iconS,
            color: color,
          ),
          const SizedBox(width: AppSizes.s),
          Expanded(
            child: Text(
              label,
              style:
                  (isMet
                          ? AppTextStyles.secondarySemi
                          : AppTextStyles.secondary)
                      .copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
