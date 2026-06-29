import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../const/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? titleText;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onTap;

  const CustomAppBar({
    super.key,
    this.titleText,
    this.leading,
    this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      toolbarHeight: 56.h,

      leading: leading ?? _defaultLeading(context),

      title: titleText == null
          ? null
          : headingTextV2(
        context: context,
        text: titleText!,
        fontWeight: FontWeight.w600,
      ),

      actions: actions,
    );
  }

  Widget _defaultLeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap ?? Get.back,
          customBorder: const CircleBorder(),
          child: Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface(context),
              border: Border.all(
                color: AppColors.border(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow(context),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 20.sp,
              color: AppColors.text(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}