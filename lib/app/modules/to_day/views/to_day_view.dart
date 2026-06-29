import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../controllers/to_day_controller.dart';

class ToDayView extends GetView<ToDayController> {
  const ToDayView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        backgroundColor: AppColors.surface(context),
        title: Text(
          'to_day'.tr,
          style: TextStyle(color: AppColors.text(context)),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'to_day_view_working'.tr,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.text(context),
          ),
        ),
      ),
    );
  }
}
