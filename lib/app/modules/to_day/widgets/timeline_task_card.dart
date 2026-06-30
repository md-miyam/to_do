import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/const/app_colors.dart';

enum TaskStatus { done, current, upcoming, missed, pending }

class TimelineTaskCard extends StatelessWidget {
  final String title;
  final String timeRange;
  final String category;
  final String? description;
  final List<String> links;
  final TaskStatus status;
  final String? timerText;
  final VoidCallback? onDoneTap;
  final VoidCallback? onDenyTap;

  const TimelineTaskCard({
    super.key,
    required this.title,
    required this.timeRange,
    required this.category,
    this.description,
    this.links = const [],
    required this.status,
    this.timerText,
    this.onDoneTap,
    this.onDenyTap,
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
      case TaskStatus.pending:
        indicatorColor = AppColors.warning;
        icon = Icons.pending_actions;
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
    final isMissed = status == TaskStatus.missed;
    final isPending = status == TaskStatus.pending;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12.r),
        border: isCurrent 
          ? Border.all(color: AppColors.brand(context).withAlpha(150), width: 1.5)
          : isMissed
            ? Border.all(color: AppColors.error.withAlpha(100), width: 1.2)
            : isPending
              ? Border.all(color: AppColors.warning.withAlpha(100), width: 1.2)
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
                    color: isCurrent 
                      ? AppColors.brand(context) 
                      : isMissed 
                        ? AppColors.error 
                        : isPending
                          ? AppColors.warning
                          : AppColors.text(context),
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
              color: isMissed 
                ? AppColors.error.withAlpha(15) 
                : isPending
                  ? AppColors.warning.withAlpha(15)
                  : AppColors.brand(context).withAlpha(15),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: isMissed 
                  ? AppColors.error.withAlpha(30) 
                  : isPending
                    ? AppColors.warning.withAlpha(30)
                    : AppColors.brand(context).withAlpha(30)
              ),
            ),
            child: Text(
              category.tr,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isMissed ? AppColors.error : isPending ? AppColors.warning : AppColors.brand(context),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              if (isCurrent && timerText != null && timerText!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.brand(context).withAlpha(20),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    timerText!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brand(context),
                      fontFamily: 'monospace',
                    ),
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
                fontStyle: (isMissed || isPending) ? FontStyle.italic : FontStyle.normal,
                color: isMissed 
                  ? AppColors.error.withAlpha(150) 
                  : isPending
                    ? AppColors.warning.withAlpha(200)
                    : AppColors.subText(context).withAlpha(200),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // Links Section
          if (links.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ...links.map((url) => _buildLinkItem(context, url)),
          ],

          if (isCurrent || isPending) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onDenyTap != null)
                  _buildActionButton(
                    context, 
                    label: 'deny'.tr, 
                    onTap: onDenyTap!, 
                    isPrimary: false
                  ),
                if (onDenyTap != null && onDoneTap != null) SizedBox(width: 10.w),
                if (onDoneTap != null)
                  _buildActionButton(
                    context, 
                    label: 'done'.tr, 
                    onTap: onDoneTap!, 
                    isPrimary: true
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String url) {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.input(context).withAlpha(30),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.border(context).withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(Icons.link, size: 12.sp, color: AppColors.brand(context)),
          SizedBox(width: 6.w),
          Expanded(
            child: InkWell(
              onTap: () => _launchURL(url),
              child: Text(
                url,
                style: TextStyle(
                  fontSize: 11.sp, 
                  color: AppColors.brand(context), 
                  fontFamily: 'monospace',
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          InkWell(
            onTap: () => _copyToClipboard(context, url),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Icon(Icons.copy, size: 12.sp, color: AppColors.subText(context)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not launch $url");
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar("Success", "Link copied to clipboard", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
  }

  Widget _buildActionButton(BuildContext context, {required String label, required VoidCallback onTap, required bool isPrimary}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isPrimary 
            ? AppColors.brand(context).withAlpha(30) 
            : AppColors.error.withAlpha(20),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isPrimary 
              ? AppColors.brand(context).withAlpha(50) 
              : AppColors.error.withAlpha(40)
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: isPrimary ? AppColors.brand(context) : AppColors.error,
          ),
        ),
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
      case TaskStatus.pending:
        label = 'pending'.tr;
        color = AppColors.warning;
        break;
      case TaskStatus.upcoming:
      default:
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
