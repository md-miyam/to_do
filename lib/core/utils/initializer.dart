import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../service/storage/hive_service.dart';
import '../service/app_blocker/focus_shield_service.dart';
import '../service/language_service.dart';
import '../service/theme_change/theme_controller.dart';
import '../logger/app_logger.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. Timezone for UI Clock
      tz.initializeTimeZones();

      // 2. Storage Layer (Hive)
      final hiveService = Get.put(HiveService());
      await hiveService.init();

      // 3. System Preferences
      await Get.putAsync(() => SharedPreferences.getInstance());

      // 4. Core Services
      Get.put(LanguageService());
      Get.put(ThemeController());
      Get.put(FocusShieldService());

      AppLogger.success("Application Initialized Successfully");
    } catch (e, s) {
      AppLogger.critical("Initialization Failed", error: e, stackTrace: s);
      rethrow;
    }
  }
}
