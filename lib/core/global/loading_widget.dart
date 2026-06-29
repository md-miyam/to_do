import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../const/app_colors.dart';

Widget loading({double size = 30}) {
  return Center(
    child: LoadingAnimationWidget.hexagonDots(
      color: AppColors.primary,
      size: size.h,
    ),
  );
}

Widget appLoading({double size = 30}) {
  return Center(
    child: LoadingAnimationWidget.hexagonDots(
      color: AppColors.primary,
      size: size.h,
    ),
  );
}
