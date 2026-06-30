import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/const/app_colors.dart';
import '../models/app_usage_model.dart';

class UsageDonutChart extends StatelessWidget {
  final List<AppUsageModel> usageList;
  final Duration totalTime;
  final String centerText;

  const UsageDonutChart({
    super.key,
    required this.usageList,
    required this.totalTime,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    // Only show top 5-6 apps in the chart, group others
    final topApps = usageList.take(6).toList();
    final otherUsage = usageList.length > 6 
      ? usageList.skip(6).fold(Duration.zero, (sum, item) => sum + item.usageTime)
      : Duration.zero;

    final List<PieChartSectionData> sections = [];
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
    ];

    for (int i = 0; i < topApps.length; i++) {
      sections.add(PieChartSectionData(
        value: topApps[i].usageTime.inMinutes.toDouble(),
        color: colors[i % colors.length],
        title: '', // Don't show text on slices to keep it clean
        radius: 12.r,
        showTitle: false,
      ));
    }

    if (otherUsage.inMinutes > 0) {
      sections.add(PieChartSectionData(
        value: otherUsage.inMinutes.toDouble(),
        color: Colors.grey.withAlpha(100),
        title: '',
        radius: 10.r,
        showTitle: false,
      ));
    }

    // Fallback for empty state
    if (sections.isEmpty) {
      sections.add(PieChartSectionData(
        value: 1,
        color: AppColors.border(context).withAlpha(40),
        radius: 10.r,
        showTitle: false,
      ));
    }

    return SizedBox(
      height: 180.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 65.r,
              sectionsSpace: 4,
              startDegreeOffset: 270,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TODAY',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.subText(context).withAlpha(150),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                centerText,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
