import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget deviceTopSpace() {
  return SizedBox(height: 50.h);
}

Widget betweenAttached() {
  return SizedBox(height: 5.h);
}

Widget betweenComponent() {
  return SizedBox(height: 8.h);
}

Widget betweenSection() {
  return SizedBox(height: 16.h);
}

Widget betweenSectionV2() {
  return SizedBox(height: 8.h);
}

// Generic spacing utilities
Widget verticalSpacing(double height) {
  return SizedBox(height: height.h);
}

Widget horizontalSpacing(double width) {
  return SizedBox(width: width.w);
}
