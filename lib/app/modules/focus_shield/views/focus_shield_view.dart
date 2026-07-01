import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/const/app_colors.dart';
import '../../../../core/localization/keys/app_keys.dart';
import '../controllers/focus_shield_controller.dart';

class FocusShieldView extends GetView<FocusShieldController> {
  const FocusShieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          AppKeys.focusShield.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surface(context),
        foregroundColor: AppColors.text(context),
        elevation: 0,
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildStatusCard(context),
            SizedBox(height: 16.h),
            _buildDisabledNotice(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final isEnabled = controller.isShieldEnabled;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isEnabled
              ? AppColors.brand(context).withAlpha(100)
              : AppColors.border(context).withAlpha(50),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: isEnabled
                          ? AppColors.brand(context).withAlpha(30)
                          : AppColors.subText(context).withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEnabled ? Icons.security : Icons.security_outlined,
                      color: isEnabled
                          ? AppColors.brand(context)
                          : AppColors.subText(context),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppKeys.shieldStatus.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text(context),
                        ),
                      ),
                      Text(
                        isEnabled ? AppKeys.enabled.tr : AppKeys.disabled.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? AppColors.success
                              : AppColors.subText(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CupertinoSwitch(
                value: isEnabled,
                activeTrackColor: AppColors.brand(context),
                onChanged: null,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.border(context).withAlpha(30)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppKeys.blockedAppsCount.tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.subText(context),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.brand(context).withAlpha(20),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${controller.blockedPackages.length}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brand(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisabledNotice(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.brand(context).withAlpha(12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.brand(context).withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.brand(context),
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Focus Shield is disabled in this release build to avoid sensitive permission prompts during installation.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'The rest of the app remains fully usable.',
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.subText(context),
            ),
          ),
        ],
      ),
    );
  }
}
