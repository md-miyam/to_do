import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../const/app_colors.dart';

Widget loading({double size = 40}) {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: AppColors.primary,
      size: size.h,
    ),
  );
}

Widget loadingSmall() {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: AppColors.primary,
      size: 24.h,
    ),
  );
}

Widget btnLoading() {
  return Center(
    child: LoadingAnimationWidget.fallingDot(
      color: AppColors.primary,
      size: 24.h,
    ),
  );
}