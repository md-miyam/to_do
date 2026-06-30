import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:to_do/core/global/app_btn.dart';
import 'package:to_do/core/global/spacing.dart';
import '../../../../core/const/app_colors.dart';
import '../controllers/set_day_controller.dart';
import '../widgets/custom_input_card.dart';
import '../widgets/routine_builder_card.dart';

class SetDayView extends GetView<SetDayController> {
  const SetDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'set_day'.tr,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                  verticalSpacing(16),
                  
                  // 1. Sleep Tracker Card
                  Obx(() => CustomInputCard(
                        title: 'tonights_sleep'.tr,
                        titleIcon: Icons.nightlight_outlined,
                        trailingHeader: controller.isSleepInfoSet.value 
                          ? InkWell(
                              onTap: controller.resetAllData,
                              child: Icon(Icons.delete_outline, color: AppColors.error, size: 20.sp),
                            )
                          : null,
                        inputFields: [
                          InputFieldData(
                            label: 'start_time'.tr,
                            value: controller.formattedStartTime,
                            type: InputFieldType.display,
                            onTap: () => controller.pickStartTime(context),
                          ),
                          InputFieldData(
                            label: 'duration_hours'.tr,
                            value: controller.duration.value.toString(),
                            type: InputFieldType.text,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => controller.updateDuration(v),
                          ),
                        ],
                        footerLabel: 'wake_up_time'.tr,
                        footerValue: controller.wakeUpTime.value,
                        bottomAction: GlobalAppButton(
                          text: 'after_waking_up'.tr,
                          onTap: controller.onAfterWakingUp,
                          // Lock button if routine started
                          isEnabled: controller.isSleepInfoSet.value && !controller.isRoutineBuilderVisible.value,
                          height: 40.h,
                          borderRadius: 8.r,
                          backgroundColor: AppColors.brand(context),
                          textColor: AppColors.isDark(context) ? Colors.black : Colors.white,
                          fontSize: 14.sp,
                        ),
                      )),
                  
                  // 2. Dynamic Routine Builder (Shows after sleep is set)
                  Obx(() => controller.isRoutineBuilderVisible.value
                      ? Column(
                          children: [
                            verticalSpacing(20),
                            RoutineBuilderCard(
                              routineTypeTitle: controller.routineTypeTitle,
                              headerIcon: controller.routineHeaderIcon,
                              taskNameController: controller.taskNameController,
                              startTime: controller.formattedRoutineStart,
                              endTime: controller.formattedRoutineEnd,
                              onPickEndTime: () => controller.pickRoutineTime(context, false),
                              categories: controller.categories,
                              selectedCategory: controller.selectedCategory.value,
                              onCategorySelected: controller.setCategory,
                              onAddCustomCategory: controller.addCustomCategory,
                              descriptionController: controller.descriptionController,
                              links: controller.links,
                              onAddLink: controller.addLink,
                              onRemoveLink: controller.removeLink,
                              linkInputController: controller.linkInputController,
                              onAddTask: controller.addTask,
                              isCycleComplete: controller.isDayComplete.value,
                              taskNameError: controller.taskNameError.value,
                              categoryError: controller.categoryError.value,
                            ),
                          ],
                        )
                      : const SizedBox.shrink()),
                  
                  verticalSpacing(30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 15.w,
        right: 15.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.selectDate(context),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border(context)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.brand(context),
                  size: 18.sp,
                ),
              ),
            ),
          ),
          Text(
            'app_name'.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.brand(context),
              letterSpacing: 0.5,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.showSettings(context),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border(context)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  color: AppColors.brand(context),
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
