import 'package:get/get.dart';

import '../controllers/bottom_nav_bar_controller.dart';
import '../../to_day/controllers/to_day_controller.dart';
import '../../set_day/controllers/set_day_controller.dart';

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(
      () => BottomNavBarController(),
    );
    Get.lazyPut<ToDayController>(
      () => ToDayController(),
    );
    Get.lazyPut<SetDayController>(
      () => SetDayController(),
    );
  }
}
