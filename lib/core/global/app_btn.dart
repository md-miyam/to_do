import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const/app_colors.dart';
import '../service/image/app_network_image_v2.dart';
import 'custom_text.dart';
import 'loading.dart';

class GlobalAppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isLoading;

  final Color? backgroundColor;
  final Color? disabledColor;
  final Color textColor;
  final Color? borderColor;

  final double borderRadius;
  final double? width;
  final double? height;

  final Widget? icon;
  final double iconSpacing;

  final String? imagePath;
  final double imageWidth;
  final double imageHeight;

  const GlobalAppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isEnabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.disabledColor,
    this.textColor = Colors.white,
    this.borderColor,
    this.borderRadius = 100,
    this.width = double.infinity,
    this.height,
    this.icon,
    this.iconSpacing = 6,
    this.imagePath,
    this.imageWidth = 16,
    this.imageHeight = 16,
  });

  Color _resolvedBackground(BuildContext context) {
    if (borderColor != null) {
      return AppColors.surface(context);
    }
    return backgroundColor ?? AppColors.primary;
  }

  Color _resolvedDisabledColor(BuildContext context) {
    return disabledColor ?? AppColors.input(context);
  }

  Color _resolvedTextColor(BuildContext context) {
    if (borderColor != null) {
      return AppColors.text(context);
    }
    return textColor;
  }

  Color _resolvedBorderColor(BuildContext context) {
    return borderColor ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final active = isEnabled && !isLoading;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius.r),
      child: Ink(
        decoration: BoxDecoration(
          color: active
              ? _resolvedBackground(context)
              : _resolvedDisabledColor(context),
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: borderColor != null
              ? Border.all(
            color: _resolvedBorderColor(context),
            width: 1.4,
          )
              : null,
        ),
        child: InkWell(
          onTap: active ? onTap : null,
          borderRadius: BorderRadius.circular(borderRadius.r),
          splashColor: borderColor != null
              ? AppColors.primary.withValues(alpha: .10)
              : Colors.white.withValues(alpha: .15),
          highlightColor: borderColor != null
              ? AppColors.primary.withValues(alpha: .06)
              : Colors.white.withValues(alpha: .08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            height: height ?? 52.h,
            alignment: Alignment.center,
            child: isLoading
                ? btnLoading()
                : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (imagePath != null) ...[
                  ResponsiveImage.asset(
                    assetPath: imagePath!,
                    width: imageWidth.w,
                    height: imageHeight.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: iconSpacing.w),
                ],
                if (icon != null) ...[
                  icon!,
                  SizedBox(width: iconSpacing.w),
                ],
                normalText(
                  context: context,
                  text: text,
                  color: _resolvedTextColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}