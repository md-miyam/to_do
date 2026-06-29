import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/global/app_btn.dart';
import 'category_selector.dart';
import 'link_manager.dart';

class RoutineBuilderCard extends StatelessWidget {
  final String routineTypeTitle;
  final IconData headerIcon;
  
  final TextEditingController taskNameController;
  final String startTime;
  final String endTime;
  final VoidCallback onPickEndTime;
  
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final Function(String) onAddCustomCategory;
  
  final TextEditingController descriptionController;
  
  final List<String> links;
  final Function(String) onAddLink;
  final Function(int) onRemoveLink;
  final TextEditingController linkInputController;
  
  final VoidCallback onAddTask;
  final bool isCycleComplete;

  final String? taskNameError;
  final String? categoryError;

  const RoutineBuilderCard({
    super.key,
    required this.routineTypeTitle,
    required this.headerIcon,
    required this.taskNameController,
    required this.startTime,
    required this.endTime,
    required this.onPickEndTime,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddCustomCategory,
    required this.descriptionController,
    required this.links,
    required this.onAddLink,
    required this.onRemoveLink,
    required this.linkInputController,
    required this.onAddTask,
    required this.isCycleComplete,
    this.taskNameError,
    this.categoryError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context).withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(headerIcon, color: AppColors.brand(context), size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    routineTypeTitle,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.brand(context).withAlpha(25),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'auto_filled'.tr.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brand(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Task Name
          _buildLabel(context, 'task_name'.tr),
          _buildTextField(context, taskNameController, 'task_name_hint'.tr, errorText: taskNameError),
          SizedBox(height: 10.h),

          // Time Range
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'start_time'.tr),
                    _buildTimeDisplay(context, startTime, null, isPrimaryBorder: true), // Primary border for read-only
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'end_time'.tr),
                    _buildTimeDisplay(context, endTime, onPickEndTime),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Category
          _buildLabel(context, 'category'.tr),
          CategorySelector(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected,
            onAddCustomCategory: onAddCustomCategory,
          ),
          if (categoryError != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 2.w),
              child: Text(
                categoryError!,
                style: TextStyle(color: AppColors.error, fontSize: 10.sp),
              ),
            ),
          SizedBox(height: 10.h),

          // Description
          _buildLabel(context, 'description'.tr),
          _buildTextField(context, descriptionController, 'description_hint'.tr, maxLines: 2),
          SizedBox(height: 10.h),

          // Links
          _buildLabel(context, 'notes_link'.tr),
          LinkManager(
            links: links,
            onAddLink: onAddLink,
            onRemoveLink: onRemoveLink,
            controller: linkInputController,
          ),
          SizedBox(height: 16.h),

          // Dynamic Button (State changes when cycle is complete)
          GlobalAppButton(
            text: isCycleComplete ? 'day_complete'.tr : 'add_task'.tr,
            onTap: onAddTask,
            isEnabled: !isCycleComplete,
            height: 40.h,
            borderRadius: 8.r,
            backgroundColor: isCycleComplete ? AppColors.input(context) : AppColors.brand(context),
            textColor: isCycleComplete 
              ? AppColors.subText(context) 
              : (AppColors.isDark(context) ? Colors.black : Colors.white),
            fontSize: 14.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.subText(context).withAlpha(150),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String hint, {int maxLines = 1, String? errorText}) {
    return SizedBox(
      height: maxLines == 1 ? (errorText != null ? 52.h : 38.h) : null,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontSize: 13.sp, color: AppColors.text(context), fontFamily: 'monospace'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.subText(context).withAlpha(80)),
          isDense: true,
          errorText: errorText,
          errorStyle: TextStyle(fontSize: 10.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.border(context).withAlpha(80)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.border(context).withAlpha(80)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.brand(context), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.error, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context, String time, VoidCallback? onTap, {bool isPrimaryBorder = false}) {
    final bool isReadOnly = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isReadOnly ? AppColors.input(context).withAlpha(40) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isPrimaryBorder ? AppColors.brand(context) : AppColors.border(context).withAlpha(80),
            width: isPrimaryBorder ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 13.sp,
                color: isPrimaryBorder ? AppColors.brand(context) : (isReadOnly ? AppColors.subText(context) : AppColors.text(context)),
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.access_time, size: 12.sp, color: isPrimaryBorder ? AppColors.brand(context) : AppColors.subText(context).withAlpha(150)),
          ],
        ),
      ),
    );
  }
}
