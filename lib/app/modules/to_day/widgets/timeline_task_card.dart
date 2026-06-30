import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';

enum TaskStatus { done, current, upcoming, missed }

class TimelineTaskCard extends StatelessWidget {
  final String title;
  final String timeRange;
  final String category;
  final String? description;
  final TaskStatus status;
  final VoidCallback? onDoneTap;

  const TimelineTaskCard({
    super.key,
    required this.title,
    required this.timeRange,
    required this.category,
    this.description,
    required this.status,
    this.onDoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTimelineIndicator(context),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildCardContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator(BuildContext context) {
    Color indicatorColor;
    IconData? icon;
    
    switch (status) {
      case TaskStatus.done:
        indicatorColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      case TaskStatus.current:
        indicatorColor = AppColors.brand(context);
        icon = Icons.play_circle_filled;
        break;
      case TaskStatus.missed:
        indicatorColor = AppColors.error;
        icon = Icons.cancel;
        break;
      case TaskStatus.upcoming:
        indicatorColor = AppColors.subText(context).withAlpha(100);
        icon = Icons.radio_button_unchecked;
        break;
    }

    return Column(
      children: [
        Icon(icon, color: indicatorColor, size: 24.sp),
        Expanded(
          child: Container(
            width: 2.w,
            color: AppColors.border(context).withAlpha(50),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent(BuildContext context) {
    final isCurrent = status == TaskStatus.current;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12.r),
        border: isCurrent 
          ? Border.all(color: AppColors.brand(context).withAlpha(150), width: 1.5)
          : Border.all(color: AppColors.border(context).withAlpha(50)),
        boxShadow: [
          if (isCurrent)
            BoxShadow(
              color: AppColors.brand(context).withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? AppColors.brand(context) : AppColors.text(context),
                  ),
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          SizedBox(height: 6.h),
          
          // Category Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.brand(context).withAlpha(15),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.brand(context).withAlpha(30)),
            ),
            child: Text(
              category.tr,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.brand(context),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(Icons.access_time, size: 12.sp, color: AppColors.subText(context)),
              SizedBox(width: 4.w),
              Text(
                timeRange,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.subText(context),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          if (description != null && description!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              description!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.subText(context).withAlpha(200),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (isCurrent && onDoneTap != null) ...[
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onDoneTap,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.brand(context).withAlpha(30),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'done'.tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brand(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    String label;
    Color color;
    
    switch (status) {
      case TaskStatus.done:
        label = 'done'.tr;
        color = AppColors.success;
        break;
      case TaskStatus.current:
        label = 'current'.tr;
        color = AppColors.brand(context);
        break;
      case TaskStatus.missed:
        label = 'not_done'.tr;
        color = AppColors.error;
        break;
      case TaskStatus.upcoming:
        label = 'upcoming'.tr;
        color = AppColors.subText(context);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
