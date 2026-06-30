import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../controllers/digital_wellbeing_controller.dart';
import 'usage_donut_chart.dart';

class DigitalWellbeingSection extends StatelessWidget {
  const DigitalWellbeingSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Put the controller here or ensure it's initialized in the parent
    final controller = Get.put(DigitalWellbeingController());

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context).withAlpha(40)),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return SizedBox(
            height: 150.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!controller.hasPermission.value) {
          return _buildPermissionState(context, controller);
        }

        if (controller.usageList.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart, size: 20.sp, color: AppColors.brand(context)),
                SizedBox(width: 10.w),
                Text(
                  'digital_wellbeing'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text(context),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.fetchUsage,
                  icon: Icon(Icons.refresh, size: 18.sp, color: AppColors.subText(context)),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            UsageDonutChart(
              usageList: controller.usageList,
              totalTime: controller.totalScreenTime.value,
              centerText: controller.formatDuration(controller.totalScreenTime.value),
            ),
            SizedBox(height: 24.h),
            _buildBlockerSummary(context, controller),
            SizedBox(height: 24.h),
            Text(
              'most_used_apps'.tr,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.subText(context),
              ),
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.usageList.take(5).length,
              separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.border(context).withAlpha(20)),
              itemBuilder: (context, index) {
                final item = controller.usageList[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.background(context),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: item.icon != null 
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.memory(item.icon!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.android, size: 20.sp, color: AppColors.subText(context)),
                  ),
                  title: Text(
                    item.appLabel,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    controller.formatDuration(item.usageTime),
                    style: TextStyle(
                      fontSize: 13.sp, 
                      fontWeight: FontWeight.bold,
                      color: AppColors.brand(context),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBlockerSummary(BuildContext context, DigitalWellbeingController controller) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: controller.isShieldEnabled.value 
                ? AppColors.brand(context).withAlpha(30)
                : Colors.grey.withAlpha(30),
            child: Icon(
              Icons.security, 
              color: controller.isShieldEnabled.value ? AppColors.brand(context) : Colors.grey,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'focus_shield_status'.tr,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.isShieldEnabled.value ? 'shield_active'.tr : 'shield_inactive'.tr,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.subText(context)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.brand(context).withAlpha(20),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${controller.blockedAppsCount.value} ${'apps_blocked'.tr}',
              style: TextStyle(
                fontSize: 10.sp, 
                fontWeight: FontWeight.bold, 
                color: AppColors.brand(context)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionState(BuildContext context, DigitalWellbeingController controller) {
    return Column(
      children: [
        Icon(Icons.lock_outline, size: 40.sp, color: AppColors.brand(context).withAlpha(100)),
        SizedBox(height: 12.h),
        Text(
          'permission_required'.tr,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'usage_access_desc'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.sp, color: AppColors.subText(context)),
        ),
        SizedBox(height: 16.h),
        ElevatedButton(
          onPressed: controller.requestPermission,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand(context),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ),
          child: Text('grant_permission'.tr),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, size: 40.sp, color: AppColors.subText(context).withAlpha(100)),
          SizedBox(height: 12.h),
          Text(
            'no_usage_data'.tr,
            style: TextStyle(fontSize: 14.sp, color: AppColors.subText(context)),
          ),
        ],
      ),
    );
  }
}
