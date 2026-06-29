import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_colors.dart';
import 'custom_text.dart';

class GlobalTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  // Label
  final String? labelText;
  final bool isMandatory;

  // Input
  final TextInputType keyboardType;
  final bool isDigitOnly;
  final bool noSpecialCharacters;

  // Password
  final bool isHidden;
  final Widget? customVisibilityOnIcon;
  final Widget? customVisibilityOffIcon;

  // Icons
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  // Validation
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  // Others
  final bool readOnly;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? fillColor;
  final double borderRadius;
  final Color? borderColor;
  final int maxLines;

  const GlobalTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isMandatory = false,
    this.keyboardType = TextInputType.text,
    this.isDigitOnly = false,
    this.noSpecialCharacters = false,
    this.isHidden = false,
    this.customVisibilityOnIcon,
    this.customVisibilityOffIcon,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.autovalidateMode,
    this.readOnly = false,
    this.activeColor,
    this.inactiveColor,
    this.fillColor,
    this.borderRadius = 100,
    this.borderColor,
    this.maxLines = 1,
  });

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  late bool _obscureText;

  Color _resolvedActiveColor(BuildContext context) =>
      widget.activeColor ?? AppColors.text(context);

  Color _resolvedInactiveColor(BuildContext context) =>
      widget.inactiveColor ?? AppColors.subText(context);

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isHidden;
  }

  List<TextInputFormatter> get _inputFormatters {
    final formatters = <TextInputFormatter>[];

    if (widget.isDigitOnly) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (widget.noSpecialCharacters) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
      );
    }

    return formatters;
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.suffixIcon != null) return widget.suffixIcon;

    if (widget.isHidden) {
      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: GestureDetector(
          onTap: () => setState(() => _obscureText = !_obscureText),
          child: _obscureText
              ? (widget.customVisibilityOffIcon ??
              Icon(
                Icons.visibility_off_outlined,
                color: _resolvedInactiveColor(context),
                size: 20.sp,
              ))
              : (widget.customVisibilityOnIcon ??
              Icon(
                Icons.visibility_outlined,
                color: _resolvedInactiveColor(context),
                size: 20.sp,
              )),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Row(
            children: [
              normalText(
                context: context,
                text: widget.labelText!,
                fontWeight: FontWeight.w600,
                color: widget.readOnly
                    ? AppColors.subText(context)
                    : AppColors.text(context),
              ),
              if (widget.isMandatory) ...[
                SizedBox(width: 2.w),
                smallText(
                  context: context,
                  text: '*',
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ],
          ),
          SizedBox(height: 10.h),
        ],
        TextFormField(
          controller: widget.controller,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: widget.isHidden ? 1 : widget.maxLines,
          inputFormatters: _inputFormatters,
          cursorColor: AppColors.primary,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: widget.readOnly
                ? AppColors.subText(context)
                : AppColors.text(context),
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(context),
            filled: true,
            fillColor: widget.readOnly
                ? AppColors.input(context).withValues(alpha: .6)
                : (widget.fillColor ?? AppColors.input(context)),
            hintStyle: GoogleFonts.spaceGrotesk(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: _resolvedInactiveColor(context),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 18.w,
              vertical: 12.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.border(context),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius.r),
              borderSide: BorderSide(
                color: AppColors.border(context),
                width: 1,
              ),
            ),
          ),
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
        ),
      ],
    );
  }
}