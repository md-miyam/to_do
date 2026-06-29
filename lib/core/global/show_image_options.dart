import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_colors.dart';

void showImageOptions({
  required BuildContext context,
  required VoidCallback onCamera,
  required VoidCallback onGallery,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface(context),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20.r),
      ),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.border(context),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Select Profile Picture',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.text(context),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildImageOption(
                context,
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                onTap: onCamera,
              ),
              _buildImageOption(
                context,
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                onTap: onGallery,
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    ),
  );
}

Widget _buildImageOption(
    BuildContext context, {
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color? color,
    }) {
  final optionColor = color ?? AppColors.primary;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: optionColor.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: optionColor.withValues(alpha: .30),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30.sp,
            color: optionColor,
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.text(context),
            ),
          ),
        ],
      ),
    ),
  );
}