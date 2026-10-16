import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../data/models/task_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/field_label.dart';
import '../../../shared/widgets/header_card_layout.dart';
import '../../../shared/widgets/page_header.dart';
import '../../../shared/widgets/priority_chip.dart';
import '../controllers/task_controller.dart';

/// One screen for both adding and editing; the controller decides the mode.
class AddEditTaskView extends GetView<TaskController> {
  const AddEditTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: HeaderCardLayout(
        header: PageHeader(title: controller.pageTitle, onBack: Get.back),
        body: AppCard(
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  controller: controller.titleController,
                  label: AppStrings.taskTitleLabel,
                  hint: AppStrings.taskTitleHint,
                  prefixIcon: AppIcons.title,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: controller.validateTitle,
                ),
                const SizedBox(height: AppSizes.xl),
                CustomTextField(
                  controller: controller.descriptionController,
                  label: AppStrings.descriptionLabel,
                  hint: AppStrings.descriptionHint,
                  prefixIcon: AppIcons.description,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSizes.xl),
                CustomTextField(
                  controller: controller.dueDateController,
                  label: AppStrings.dueDateLabel,
                  hint: AppStrings.dueDateHint,
                  prefixIcon: AppIcons.calendar,
                  readOnly: true,
                  onTap: controller.pickDueDate,
                  validator: controller.validateDueDate,
                ),
                const SizedBox(height: AppSizes.xl),
                const FieldLabel(AppStrings.priorityLabel),
                const SizedBox(height: AppSizes.m),
                Obx(
                  () => Wrap(
                    spacing: AppSizes.s,
                    runSpacing: AppSizes.s,
                    children: TaskPriority.values
                        .map(
                          (priority) => PriorityChip(
                            priority: priority,
                            isSelected: controller.priority.value == priority,
                            onTap: () => controller.selectPriority(priority),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: AppSizes.xxxl),
                Obx(
                  () => CustomButton.gradient(
                    label: controller.saveButtonLabel,
                    icon: AppIcons.save,
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveTask,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
