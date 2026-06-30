import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:animated_analog_clock/animated_analog_clock.dart';
import '../../../../core/const/app_colors.dart';
import '../controllers/to_day_controller.dart';
import '../widgets/timeline_task_card.dart';
import '../widgets/day_summary_card.dart';
import '../widgets/daily_progress_heatmap.dart';
import '../models/daily_progress_model.dart';

class ToDayView extends GetView<ToDayController> {
  const ToDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Obx(() => controller.tasks.isEmpty 
              ? _buildEmptyState(context)
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressSection(context),
                      SizedBox(height: 24.h),
                      
                      // Timeline List
                      ...controller.tasks.asMap().entries.map((entry) {
                        final index = entry.key;
                        final task = entry.value;
                        final status = controller.getTaskStatus(task);
                        
                        return TimelineTaskCard(
                          title: task['name'] ?? 'Untitled',
                          timeRange: '${task['start_time']} - ${task['end_time']}',
                          category: task['category'] ?? 'routine',
                          description: task['description'],
                          links: (task['links'] as List?)?.map((e) => e.toString()).toList() ?? [],
                          status: status,
                          timerText: status == TaskStatus.current ? controller.currentTaskTimeLeft.value : null,
                          onDoneTap: () => controller.markTaskAsDone(index),
                          onDenyTap: () => controller.markTaskAsDenied(index),
                        );
                      }),
                      
                      SizedBox(height: 30.h),
                      
                      // Day Summary Section
                      DaySummaryCard(
                        doneCount: controller.doneCount.value,
                        notDoneCount: controller.totalCount.value - controller.doneCount.value,
                        completionRate: controller.completionRate.value,
                      ),
                      
                      SizedBox(height: 40.h),
                    ],
                  ),
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
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 16.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Time/Clock
          Row(
            children: [
              SizedBox(
                width: 45.w,
                height: 45.w,
                child: AnimatedAnalogClock(
                  location: 'Asia/Dhaka',
                  hourHandColor: AppColors.brand(context),
                  minuteHandColor: AppColors.brand(context),
                  secondHandColor: AppColors.error,
                  centerDotColor: AppColors.brand(context),
                  backgroundColor: AppColors.background(context),
                  dialType: DialType.none,
                  size: 45.w,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('hh:mm').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text(context),
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    DateFormat('a').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brand(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Center/Title
          Expanded(
            child: Text(
              'do_or_die'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.brand(context),
                letterSpacing: 1.0,
              ),
            ),
          ),

          // Right: Date Block
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.brand(context),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.brand(context).withAlpha(60),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('dd').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.isDark(context) ? Colors.black : Colors.white,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(DateTime.now()).toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.isDark(context) ? Colors.black.withAlpha(180) : Colors.white.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'daily_progress'.tr,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.text(context),
              ),
            ),
            Text(
              '${controller.completionRate.value}% ${'completed'.tr}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.brand(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: controller.completionRate.value / 100,
            minHeight: 10.h,
            backgroundColor: AppColors.brand(context).withAlpha(30),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand(context)),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '${controller.doneCount.value}/${controller.tasks.length} ${'tasks_finished_today'.tr}',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.subText(context),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note_outlined, size: 64.sp, color: AppColors.subText(context).withAlpha(100)),
          SizedBox(height: 16.h),
          Text(
            'no_tasks_yet'.tr,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.subText(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
