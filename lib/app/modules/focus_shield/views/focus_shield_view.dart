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
        title: Text(AppKeys.focusShield.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface(context),
        foregroundColor: AppColors.text(context),
        elevation: 0,
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              controller.showOnlyBlocked.value ? Icons.filter_alt : Icons.filter_alt_off_outlined,
              color: controller.showOnlyBlocked.value ? AppColors.brand(context) : AppColors.subText(context),
            ),
            onPressed: controller.toggleFilterBlocked,
            tooltip: "Show Blocked Only",
          )),
        ],
      ),
      body: Obx(() => Column(
            children: [
              _buildStatusCard(context),
              _buildSearchBar(context),
              Expanded(
                child: controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : _buildAppList(context),
              ),
            ],
          )),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final isEnabled = controller.isShieldEnabled;
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isEnabled ? AppColors.brand(context).withAlpha(100) : AppColors.border(context).withAlpha(50)),
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
                      color: isEnabled ? AppColors.brand(context).withAlpha(30) : AppColors.subText(context).withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isEnabled ? Icons.security : Icons.security_outlined,
                      color: isEnabled ? AppColors.brand(context) : AppColors.subText(context),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppKeys.shieldStatus.tr,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.text(context)),
                      ),
                      Text(
                        isEnabled ? AppKeys.enabled.tr : AppKeys.disabled.tr,
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: isEnabled ? AppColors.success : AppColors.subText(context)),
                      ),
                    ],
                  ),
                ],
              ),
              CupertinoSwitch(
                value: isEnabled,
                activeColor: AppColors.brand(context),
                onChanged: (v) => controller.toggleShield(v),
              ),
            ],
          ),
          if (!controller.hasPermission) ...[
            SizedBox(height: 16.h),
            _buildPermissionWarning(context),
          ],
          SizedBox(height: 12.h),
          Divider(color: AppColors.border(context).withAlpha(30)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppKeys.blockedAppsCount.tr,
                style: TextStyle(fontSize: 13.sp, color: AppColors.subText(context)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.brand(context).withAlpha(20),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${controller.blockedPackages.length}',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.brand(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionWarning(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withAlpha(15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withAlpha(30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.lock_open_outlined, color: AppColors.error, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  AppKeys.permissionRequiredDesc.tr,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.error, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.requestPermission(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                elevation: 0,
              ),
              child: Text(AppKeys.grantPermission.tr, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        onChanged: controller.onSearch,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: AppKeys.searchApps.tr,
          prefixIcon: Icon(Icons.search, size: 20.sp, color: AppColors.subText(context)),
          filled: true,
          fillColor: AppColors.surface(context),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.brand(context).withAlpha(50), width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildAppList(BuildContext context) {
    if (controller.filteredApps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 48.sp, color: AppColors.subText(context).withAlpha(50)),
            SizedBox(height: 12.h),
            Text(
              "No apps found",
              style: TextStyle(fontSize: 14.sp, color: AppColors.subText(context)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.filteredApps.length,
      itemBuilder: (context, index) {
        final app = controller.filteredApps[index];
        final isSelected = controller.blockedPackages.contains(app.packageName);

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.brand(context).withAlpha(100) : Colors.transparent,
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: app.icon != null
                  ? Image.memory(app.icon!, width: 34.w, height: 34.w, fit: BoxFit.cover)
                  : Icon(Icons.apps, size: 30.sp, color: AppColors.subText(context).withAlpha(100)),
            ),
            title: Text(
              app.appName ?? 'unknown'.tr,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.text(context)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              app.packageName ?? "",
              style: TextStyle(fontSize: 10.sp, color: AppColors.subText(context), fontFamily: 'monospace'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Checkbox(
              value: isSelected,
              activeColor: AppColors.brand(context),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
              onChanged: (_) => controller.toggleAppSelection(app.packageName ?? ""),
            ),
            onTap: () => controller.toggleAppSelection(app.packageName ?? ""),
          ),
        );
      },
    );
  }
}
