import 'package:get/get.dart';

import '../controllers/to_day_controller.dart';

class ToDayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToDayController>(
      () => ToDayController(),
    );
  }
}
