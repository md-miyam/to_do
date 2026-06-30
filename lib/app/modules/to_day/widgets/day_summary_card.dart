import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';

class DaySummaryCard extends StatelessWidget {
  final int doneCount;
  final int notDoneCount;
  final int completionRate;

  const DaySummaryCard({
    super.key,
    required this.doneCount,
    required this.notDoneCount,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'day_summary'.tr,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.text(context),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildStatBox(context, doneCount.toString(), 'done'.tr, AppColors.success),
              SizedBox(width: 10.w),
              _buildStatBox(context, notDoneCount.toString(), 'not_done'.tr, AppColors.error),
              SizedBox(width: 10.w),
              _buildStatBox(context, '$completionRate%', 'rate'.tr, AppColors.brand(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.background(context),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border(context).withAlpha(50)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.subText(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
