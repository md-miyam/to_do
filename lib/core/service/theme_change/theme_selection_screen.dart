import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../const/app_colors.dart';
import '../../global/custom_text.dart';
import '../../global/spacing.dart';
import 'theme_ui.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColors.surface(context),
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: AppColors.border(context),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back,
                        size: 20.sp,
                        color: AppColors.text(context),
                      ),
                    ),
                  ),
                  betweenSection(),
                  headingText(
                    context: context,
                    text: 'Change Theme',
                    fontWeight: FontWeight.bold,
                  ),
                  betweenSection(),
                  normalText(
                    context: context,
                    text: 'Select your preferred theme',
                    color: AppColors.subText(context),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: ThemeUi(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}