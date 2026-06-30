import 'package:get/get.dart';
import '../controllers/focus_shield_controller.dart';

class FocusShieldBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FocusShieldController>(
      () => FocusShieldController(),
    );
  }
}
