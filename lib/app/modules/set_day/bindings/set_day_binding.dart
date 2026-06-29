import 'package:get/get.dart';

import '../controllers/set_day_controller.dart';

class SetDayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetDayController>(
      () => SetDayController(),
    );
  }
}
