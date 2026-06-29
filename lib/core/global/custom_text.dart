import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_colors.dart';

Widget _appText({
  required BuildContext context,
  required String text,
  required double fontSize,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: const TextScaler.linear(1),
    ),
    child: Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.spaceGrotesk(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color ?? AppColors.text(context),
      ),
    ),
  );
}

// Heading 22
Widget headingText({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.bold,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: 22,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

// Heading 18
Widget headingTextV2({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.w600,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: 18,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

// Body 16
Widget normalText({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: 16,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

// Body Small 13
Widget normalTextV2({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: 13,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

// Medium
Widget mediumText({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.w500,
  Color? color,
  double fontSize = 14,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

// Small
Widget smallText({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
  double fontSize = 12,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

// Smaller
Widget smallerText({
  required BuildContext context,
  required String text,
  FontWeight fontWeight = FontWeight.w500,
  Color? color,
  TextAlign textAlign = TextAlign.start,
  int maxLines = 1,
  TextOverflow overflow = TextOverflow.ellipsis,
}) =>
    _appText(
      context: context,
      text: text,
      fontSize: 10,
      fontWeight: fontWeight,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );