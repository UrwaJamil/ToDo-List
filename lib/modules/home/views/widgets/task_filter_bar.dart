import 'package:flutter/material.dart';

import '../../../../app/constants/app_sizes.dart';
import '../../../../shared/widgets/app_choice_chip.dart';
import '../../controllers/home_controller.dart';

/// Horizontally scrollable All / Pending / Completed chips (never clipped).
class TaskFilterBar extends StatelessWidget {
  final TaskFilter selected;
  final ValueChanged<TaskFilter> onSelected;
  final EdgeInsetsGeometry padding;

  const TaskFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      // Let the chip shadows spill outside the scroll area.
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (final filter in TaskFilter.values) ...[
            if (filter != TaskFilter.values.first)
              const SizedBox(width: AppSizes.s),
            AppChoiceChip(
              label: filter.label,
              isSelected: filter == selected,
              onTap: () => onSelected(filter),
            ),
          ],
        ],
      ),
    );
  }
}
