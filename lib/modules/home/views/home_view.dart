import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_icons.dart';
import '../../../app/constants/app_sizes.dart';
import '../../../app/constants/app_strings.dart';
import '../../../shared/widgets/background_waves.dart';
import '../../../shared/widgets/curved_header.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../../shared/widgets/gradient_fab.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/search_bar_field.dart';
import '../../../shared/widgets/task_card.dart';
import '../../../shared/widgets/task_stats_row.dart';
import '../controllers/home_controller.dart';
import 'widgets/home_header.dart';
import 'widgets/sort_menu_button.dart';
import 'widgets/task_filter_bar.dart';

/// Home tab: curved header with overlapping stats, search, filters and the
/// task list.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // The shell's Scaffold already handles the keyboard.
      resizeToAvoidBottomInset: false,
      floatingActionButton: GradientFab(
        label: AppStrings.addTask,
        icon: AppIcons.add,
        onPressed: controller.openAddTask,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundWaves(),
          CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.gutter,
                  AppSizes.xl,
                  AppSizes.gutter,
                  0,
                ),
                sliver: SliverToBoxAdapter(child: _buildSearchRow()),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  // Extra room below so the chip shadows are not covered.
                  padding: const EdgeInsets.only(
                    top: AppSizes.l,
                    bottom: AppSizes.xl,
                  ),
                  child: Obx(
                    () => TaskFilterBar(
                      selected: controller.filter.value,
                      onSelected: controller.changeFilter,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.gutter,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(_buildTaskSliver),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return CurvedHeader(
      showDecoration: true,
      backgroundBottomInset: AppSizes.statOverlap,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.gutter,
        AppSizes.l,
        AppSizes.gutter,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HomeHeader(
            userName: controller.userName,
            greeting: controller.greetingText,
            dateLabel: controller.todayLabel,
            onLogout: controller.logout,
          ),
          const SizedBox(height: AppSizes.xxl + AppSizes.waveDepth),
          Obx(
            () => TaskStatsRow(
              total: controller.totalCount,
              completed: controller.completedCount,
              pending: controller.pendingCount,
              onTotalTap: () => controller.changeFilter(TaskFilter.all),
              onCompletedTap: () =>
                  controller.changeFilter(TaskFilter.completed),
              onPendingTap: () => controller.changeFilter(TaskFilter.pending),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: SearchBarField(
            controller: controller.searchController,
            hint: AppStrings.searchHint,
            onChanged: controller.onSearchChanged,
            suffix: Obx(
              () => controller.searchQuery.value.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(AppIcons.clear),
                      onPressed: controller.clearSearch,
                    ),
            ),
          ),
        ),
        const SizedBox(width: AppSizes.m),
        Obx(
          () => SortMenuButton(
            selected: controller.sort.value,
            onSelected: controller.changeSort,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSliver() {
    if (controller.isLoading.value) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: LoadingWidget(message: AppStrings.loading),
      );
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateWidget(
          icon: AppIcons.error,
          title: AppStrings.errorTitle,
          message: controller.errorMessage.value,
          color: AppColors.errorDark,
          actionLabel: AppStrings.retry,
          actionIcon: AppIcons.retry,
          onAction: controller.retry,
        ),
      );
    }

    if (controller.hasNoTasks) {
      // No action button here: the FAB already offers "Add Task".
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateWidget(
          icon: AppIcons.empty,
          title: AppStrings.noTasksTitle,
          message: AppStrings.noTasksMessage,
        ),
      );
    }

    final tasks = controller.filteredTasks;
    if (tasks.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyStateWidget(
          icon: AppIcons.noResults,
          title: AppStrings.noResultsTitle,
          message: AppStrings.noResultsMessage,
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.gutter,
        0,
        AppSizes.gutter,
        AppSizes.listBottomForFab,
      ),
      sliver: SliverList.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, _) =>
            const SizedBox(height: AppSizes.cardSpacing),
        itemBuilder: (_, index) {
          final task = tasks[index];
          return TaskCard(
            key: ValueKey(task.id),
            task: task,
            onTap: () => controller.openTaskDetails(task),
            onToggle: () => controller.toggleComplete(task),
            onEdit: () => controller.openEditTask(task),
            onDelete: () => controller.deleteTask(task),
          );
        },
      ),
    );
  }
}
