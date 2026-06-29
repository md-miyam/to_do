import 'package:get/get.dart';
import '../modules/bottom_nav_bar/bindings/bottom_nav_bar_binding.dart';
import '../modules/bottom_nav_bar/views/bottom_nav_bar_view.dart';
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
  ];
}
