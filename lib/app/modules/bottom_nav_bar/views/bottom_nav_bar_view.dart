import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/const/app_colors.dart';
import '../../../../core/const/icons_path.dart';
import '../../set_day/views/set_day_view.dart';
import '../../to_day/views/to_day_view.dart';
import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarView extends GetView<BottomNavBarController> {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex,
          children: const [
            ToDayView(),
            SetDayView(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow(context),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Obx(
            () => NavigationBar(
              height: 65, // Smaller height for a sleeker look
              selectedIndex: controller.currentIndex,
              onDestinationSelected: controller.changeIndex,
              backgroundColor: AppColors.surface(context),
              indicatorColor: AppColors.brand(context).withAlpha(30), // Using withAlpha for modern color handling
              surfaceTintColor: Colors.transparent, // Prevents tinting issues in dark mode
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: Image.asset(
                    IconsPath.toDay,
                    height: 22,
                    color: AppColors.subText(context), // Adaptive inactive color
                  ),
                  selectedIcon: Image.asset(
                    IconsPath.toDay,
                    height: 22,
                    color: AppColors.brand(context), // Adaptive active color
                  ),
                  label: "to_day".tr,
                ),
                NavigationDestination(
                  icon: Image.asset(
                    IconsPath.setDay,
                    height: 22,
                    color: AppColors.subText(context),
                  ),
                  selectedIcon: Image.asset(
                    IconsPath.setDay,
                    height: 22,
                    color: AppColors.brand(context),
                  ),
                  label: "set_day".tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
