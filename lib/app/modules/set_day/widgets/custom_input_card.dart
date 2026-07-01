import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/const/app_colors.dart';

enum InputFieldType { text, display }

class InputFieldData {
  final String label;
  final String value;
  final InputFieldType type;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final TextInputType keyboardType;

  InputFieldData({
    required this.label,
    required this.value,
    this.type = InputFieldType.display,
    this.onTap,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });
}

class CustomInputCard extends StatelessWidget {
  final IconData? titleIcon;
  final String title;
  final List<InputFieldData> inputFields;
  final String? footerLabel;
  final String? footerValue;
  final Widget? bottomAction;
  final Widget? trailingHeader;

  const CustomInputCard({
    super.key,
    required this.title,
    this.titleIcon,
    required this.inputFields,
    this.footerLabel,
    this.footerValue,
    this.bottomAction,
    this.trailingHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context).withAlpha(100), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Minimalist
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (titleIcon != null) ...[
                      Icon(titleIcon, color: AppColors.brand(context), size: 18.sp),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text(context),
                      ),
                    ),
                  ],
                ),
                ?trailingHeader,
              ],
            ),
          ),

          // Fields
          ...inputFields.map((field) => _buildField(context, field)),

          // Footer
          if (footerLabel != null && footerValue != null)
            Container(
              margin: EdgeInsets.all(10.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.brand(context).withAlpha(15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    footerLabel!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.subText(context),
                    ),
                  ),
                  Text(
                    footerValue!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.brand(context),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          
          if (bottomAction != null)
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
              child: bottomAction!,
            ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, InputFieldData field) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.subText(context),
            ),
          ),
          SizedBox(height: 4.h),
          if (field.type == InputFieldType.display)
            InkWell(
              onTap: field.onTap,
              borderRadius: BorderRadius.circular(6.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.border(context).withAlpha(150)),
                ),
                child: Text(
                  field.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.text(context),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 38.h, // Compact height
              child: TextField(
                onChanged: field.onChanged,
                keyboardType: field.keyboardType,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text(context),
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: field.value,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppColors.border(context).withAlpha(150)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppColors.border(context).withAlpha(150)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppColors.brand(context), width: 1),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
