import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/const/app_colors.dart';
import '../models/daily_progress_model.dart';

class DailyProgressHeatmap extends StatelessWidget {
  final Map<String, DailyProgressModel> history;
  final Function(DailyProgressModel) onDayTap;

  const DailyProgressHeatmap({
    super.key,
    required this.history,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    // We'll show the last 14 weeks (roughly 3-4 months) to keep it compact but scrollable
    const int weeksToShow = 14;
    final now = DateTime.now();
    // Start from the Sunday of the week 'weeksToShow' ago
    final startDate = now.subtract(Duration(days: (weeksToShow * 7) + (now.weekday % 7)));

    return Container(
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // Show most recent on the right
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayLabels(context),
                SizedBox(width: 8.w),
                _buildHeatmapGrid(context, startDate, weeksToShow),
              ],
            ),
          ),
          
          SizedBox(height: 12.h),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildDayLabels(BuildContext context) {
    final labels = ['', 'Mon', '', 'Wed', '', 'Fri', ''];
    return Column(
      children: [
        SizedBox(height: 20.h), // Offset for month labels
        ...labels.map((label) => SizedBox(
              height: 14.h,
              child: Center(
                child: Text(
                  label.tr,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.subText(context).withAlpha(150),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildHeatmapGrid(BuildContext context, DateTime startDate, int weeks) {
    final List<Widget> weekColumns = [];
    DateTime currentDay = startDate;

    for (int w = 0; w <= weeks; w++) {
      final List<Widget> daySquares = [];
      String? monthLabel;

      for (int d = 0; d < 7; d++) {
        final dateKey = DateFormat('yyyy-MM-dd').format(currentDay);
        final progress = history[dateKey];
        
        // Month label logic: if it's the first week or first day of month
        if (d == 0 && (w == 0 || currentDay.day <= 7)) {
           monthLabel = DateFormat('MMM').format(currentDay);
        }

        daySquares.add(_buildSquare(context, progress, currentDay));
        currentDay = currentDay.add(const Duration(days: 1));
      }

      weekColumns.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
            child: monthLabel != null 
              ? Text(
                  monthLabel,
                  style: TextStyle(fontSize: 9.sp, color: AppColors.subText(context), fontWeight: FontWeight.bold),
                )
              : const SizedBox.shrink(),
          ),
          ...daySquares,
        ],
      ));
      weekColumns.add(SizedBox(width: 4.w));
    }

    return Row(children: weekColumns);
  }

  Widget _buildSquare(BuildContext context, DailyProgressModel? progress, DateTime date) {
    final rate = progress?.completionRate ?? 0;
    final color = _getHeatmapColor(context, rate, progress != null);
    final isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == DateFormat('yyyy-MM-dd').format(date);

    return GestureDetector(
      onTap: () {
        if (progress != null) {
          onDayTap(progress);
        } else {
          onDayTap(DailyProgressModel(
            date: DateFormat('yyyy-MM-dd').format(date),
            totalTasks: 0,
            completedTasks: 0,
            deniedTasks: 0,
            pendingTasks: 0,
            completionRate: 0,
          ));
        }
      },
      child: Container(
        width: 12.h,
        height: 12.h,
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2.r),
          border: isToday ? Border.all(color: AppColors.brand(context), width: 1) : null,
        ),
      ),
    );
  }

  Color _getHeatmapColor(BuildContext context, int percentage, bool hasData) {
    if (!hasData || percentage == 0) {
      return AppColors.isDark(context) ? Colors.white10 : Colors.black.withAlpha(20);
    }
    
    final Color brandColor = AppColors.brand(context);
    
    // Scale intensity based on percentage using the app's brand color
    if (percentage <= 25) return brandColor.withAlpha(50);
    if (percentage <= 50) return brandColor.withAlpha(100);
    if (percentage <= 75) return brandColor.withAlpha(180);
    if (percentage <= 99) return brandColor;
    
    // 100% Achievement - Brightest version
    return brandColor.withAlpha(255);
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Less'.tr, style: TextStyle(fontSize: 10.sp, color: AppColors.subText(context))),
        SizedBox(width: 4.w),
        _buildLegendSquare(context, 0),
        _buildLegendSquare(context, 20),
        _buildLegendSquare(context, 45),
        _buildLegendSquare(context, 70),
        _buildLegendSquare(context, 95),
        _buildLegendSquare(context, 100),
        SizedBox(width: 4.w),
        Text('More'.tr, style: TextStyle(fontSize: 10.sp, color: AppColors.subText(context))),
      ],
    );
  }

  Widget _buildLegendSquare(BuildContext context, int percentage) {
    return Container(
      width: 10.h,
      height: 10.h,
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      decoration: BoxDecoration(
        color: _getHeatmapColor(context, percentage, true),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
