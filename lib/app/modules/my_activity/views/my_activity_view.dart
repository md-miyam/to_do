import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../../focus_shield/views/focus_shield_view.dart';
import '../../to_day/models/daily_progress_model.dart';
import '../../to_day/widgets/daily_progress_heatmap.dart';
import '../controllers/my_activity_controller.dart';

class MyActivityView extends GetView<MyActivityController> {
  const MyActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  
                  // Heatmap Section
                  Obx(() {
                    // Touching .length ensures GetX registers a subscription even if the map is empty.
                    // This prevents the "improper use of GetX" error.
                    final historyMap = controller.history;
                    if (historyMap.isEmpty) {
                      return DailyProgressHeatmap(
                        history: const {},
                        onDayTap: (progress) => _showProgressDetail(context, progress),
                      );
                    }
                    return DailyProgressHeatmap(
                      history: historyMap,
                      onDayTap: (progress) => _showProgressDetail(context, progress),
                    );
                  }),
                  
                  SizedBox(height: 24.h),

                  // Focus Shield Section
                  _buildSectionTitle(context, 'tools'.tr),
                  SizedBox(height: 12.h),
                  _buildToolCard(
                    context,
                    title: 'focus_shield'.tr,
                    subtitle: 'block_distractions_desc'.tr,
                    icon: Icons.security_outlined,
                    onTap: () => Get.toNamed(Routes.FOCUS_SHIELD),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Placeholder for future activities/analytics
                  _buildEmptyStatePlaceholder(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.text(context),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.border(context).withAlpha(40)),
      ),
      color: AppColors.surface(context),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          backgroundColor: AppColors.brand(context).withAlpha(20),
          child: Icon(icon, color: AppColors.brand(context)),
        ),
        title: Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12.sp, color: AppColors.subText(context))),
        trailing: Icon(Icons.arrow_forward_ios, size: 14.sp, color: AppColors.subText(context)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 15.w,
        right: 15.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 40.w), // Placeholder
          Text(
            'activity_history'.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.brand(context),
              letterSpacing: 0.5,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.showSettings(context),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border(context)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.settings_outlined,
                  color: AppColors.brand(context),
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStatePlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context).withAlpha(50),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context).withAlpha(30)),
      ),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined, size: 40.sp, color: AppColors.subText(context).withAlpha(50)),
          SizedBox(height: 12.h),
          Text(
            'more_analytics_coming_soon'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.subText(context).withAlpha(150),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showProgressDetail(BuildContext context, DailyProgressModel progress) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progress.date,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brand(context),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.brand(context).withAlpha(30),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${progress.completionRate}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brand(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildDetailRow(context, 'total_tasks'.tr, progress.totalTasks.toString(), Icons.list_alt),
            _buildDetailRow(context, 'completed_tasks'.tr, progress.completedTasks.toString(), Icons.check_circle_outline, color: AppColors.success),
            _buildDetailRow(context, 'denied_tasks'.tr, progress.deniedTasks.toString(), Icons.cancel_outlined, color: AppColors.error),
            _buildDetailRow(context, 'pending_tasks'.tr, progress.pendingTasks.toString(), Icons.pending_actions_outlined, color: AppColors.warning),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: color ?? AppColors.subText(context)),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.text(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.text(context),
            ),
          ),
        ],
      ),
    );
  }
}
