import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/app_colors.dart';
import 'theme_controller.dart';

class ThemeUi extends StatelessWidget {
  const ThemeUi({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Obx(
          () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            context,
            controller,
            Icons.light_mode_rounded,
            'Light',
            'light',
          ),
          SizedBox(width: 8.w),
          _buildOption(
            context,
            controller,
            Icons.dark_mode_rounded,
            'Dark',
            'dark',
          ),
          SizedBox(width: 8.w),
          _buildOption(
            context,
            controller,
            Icons.settings_suggest_rounded,
            'System',
            'system',
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context,
      ThemeController controller,
      IconData icon,
      String label,
      String value,
      ) {
    final isSelected = controller.themeMode.value == value;

    return GestureDetector(
      onTap: () => controller.setThemeMode(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .12)
              : AppColors.input(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border(context),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.subText(context),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11.sp,
                fontWeight:
                isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.text(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}