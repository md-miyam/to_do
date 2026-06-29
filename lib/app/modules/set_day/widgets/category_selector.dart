import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final Function(String) onAddCustomCategory;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddCustomCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6.w,
          runSpacing: 6.h,
          children: [
            ...categories.map((category) {
              final isSelected = selectedCategory == category;
              return InkWell(
                onTap: () => onCategorySelected(category),
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brand(context) : AppColors.surface(context),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: isSelected ? AppColors.brand(context) : AppColors.border(context).withAlpha(60),
                    ),
                  ),
                  child: Text(
                    category.tr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? (AppColors.isDark(context) ? Colors.black : Colors.white)
                          : AppColors.subText(context),
                    ),
                  ),
                ),
              );
            }),
            
            // Add Custom Button
            InkWell(
              onTap: () => _showAddCategoryDialog(context),
              borderRadius: BorderRadius.circular(6.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.brand(context).withAlpha(20),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.brand(context).withAlpha(40), style: BorderStyle.solid),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 12.sp, color: AppColors.brand(context)),
                    SizedBox(width: 4.w),
                    Text(
                      'custom'.tr,
                      style: TextStyle(fontSize: 11.sp, color: AppColors.brand(context), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final controller = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text('add_custom_category'.tr, style: TextStyle(color: AppColors.text(context), fontSize: 16.sp)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: AppColors.text(context)),
          decoration: InputDecoration(
            hintText: 'category_name_hint'.tr,
            hintStyle: TextStyle(color: AppColors.subText(context).withAlpha(100)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.brand(context))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr, style: TextStyle(color: AppColors.subText(context)))),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onAddCustomCategory(controller.text.trim());
                Get.back();
              }
            },
            child: Text('add'.tr, style: TextStyle(color: AppColors.brand(context), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
