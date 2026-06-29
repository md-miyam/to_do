import 'package:flutter/material.dart';
import '../const/app_colors.dart';
import 'custom_text.dart';

class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final Color? firstTextColor;
  final Color? secondTextColor;
  final VoidCallback? onTap;
  final int firstFlex;
  final int secondFlex;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;

  const CustomRichText({
    super.key,
    required this.firstText,
    required this.secondText,
    this.firstTextColor,
    this.secondTextColor,
    this.onTap,
    this.firstFlex = 2,
    this.secondFlex = 1,
    this.firstTextStyle,
    this.secondTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: firstFlex,
          child: firstTextStyle != null
              ? Text(
            firstText,
            style: firstTextStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
              : mediumText(
            context: context,
            text: firstText,
            fontWeight: FontWeight.w400,
            color: firstTextColor ?? AppColors.subText(context),
          ),
        ),
        Flexible(
          flex: secondFlex,
          child: InkWell(
            onTap: onTap,
            child: secondTextStyle != null
                ? Text(
              secondText,
              style: secondTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
                : mediumText(
              context: context,
              text: secondText,
              fontWeight: FontWeight.w600,
              color: secondTextColor ?? AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}