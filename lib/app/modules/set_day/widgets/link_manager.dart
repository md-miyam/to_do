import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/global/custom_text.dart';

class LinkManager extends StatelessWidget {
  final List<String> links;
  final Function(String) onAddLink;
  final Function(int) onRemoveLink;
  final TextEditingController controller;

  const LinkManager({
    super.key,
    required this.links,
    required this.onAddLink,
    required this.onRemoveLink,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Column(
              children: links.asMap().entries.map((entry) => _buildLinkTile(context, entry.key, entry.value)).toList(),
            )),
        if (links.isNotEmpty) SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align to top for consistency
          children: [
            Expanded(
              child: SizedBox(
                height: 38.h, // Increased to standard compact height
                child: TextField(
                  controller: controller,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.text(context), fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    hintText: 'add_link_hint'.tr,
                    hintStyle: TextStyle(fontSize: 11.sp, color: AppColors.subText(context).withAlpha(80)),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.border(context).withAlpha(80)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.border(context).withAlpha(80)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: AppColors.brand(context), width: 1),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (controller.text.trim().isNotEmpty) {
                    onAddLink(controller.text.trim());
                    controller.clear();
                  }
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  height: 38.h, // Perfectly matches TextField height
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.brand(context).withAlpha(30),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.brand(context).withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.save_outlined, size: 14.sp, color: AppColors.brand(context)),
                      SizedBox(width: 4.w),
                      mediumText(context: context, text: 'save'.tr, fontSize: 11, color: AppColors.brand(context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLinkTile(BuildContext context, int index, String url) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.input(context).withAlpha(30),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border(context).withAlpha(40)),
      ),
      child: Row(
        children: [
          Icon(Icons.link, size: 12.sp, color: AppColors.brand(context)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              url,
              style: TextStyle(fontSize: 12.sp, color: AppColors.subText(context), fontFamily: 'monospace'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          InkWell(
            onTap: () => onRemoveLink(index),
            child: Icon(Icons.close, size: 14.sp, color: AppColors.error.withAlpha(180)),
          ),
        ],
      ),
    );
  }
}
