import 'package:get/get.dart';

import '../modules/bottom_nav_bar/bindings/bottom_nav_bar_binding.dart';
import '../modules/bottom_nav_bar/views/bottom_nav_bar_view.dart';
import '../modules/focus_shield/bindings/focus_shield_binding.dart';
import '../modules/focus_shield/views/focus_shield_view.dart';
import '../modules/my_activity/bindings/my_activity_binding.dart';
import '../modules/my_activity/views/my_activity_view.dart';
import '../modules/set_day/bindings/set_day_binding.dart';
import '../modules/set_day/views/set_day_view.dart';
import '../modules/to_day/bindings/to_day_binding.dart';
import '../modules/to_day/views/to_day_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.BOTTOM_NAV_BAR;

  static final routes = [
    GetPage(
      name: _Paths.BOTTOM_NAV_BAR,
      page: () => const BottomNavBarView(),
      binding: BottomNavBarBinding(),
    ),
    GetPage(
      name: _Paths.SET_DAY,
      page: () => const SetDayView(),
      binding: SetDayBinding(),
    ),
    GetPage(
      name: _Paths.TO_DAY,
      page: () => const ToDayView(),
      binding: ToDayBinding(),
    ),
    GetPage(
      name: _Paths.MY_ACTIVITY,
      page: () => const MyActivityView(),
      binding: MyActivityBinding(),
    ),
    GetPage(
      name: _Paths.FOCUS_SHIELD,
      page: () => const FocusShieldView(),
      binding: FocusShieldBinding(),
    ),
  ];
}
