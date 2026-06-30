import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'app/routes/app_pages.dart';
import 'core/const/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'core/service/storage/hive_service.dart';
import 'core/service/language_service.dart';
import 'core/service/theme_change/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Timezone
  tz.initializeTimeZones();

  // Initialize Hive
  final hiveService = Get.put(HiveService());
  await hiveService.init();
  await Hive.openBox('history_box');

  // Initialize SharedPreferences and LanguageService
  await Get.putAsync(() => SharedPreferences.getInstance());
  Get.put(LanguageService());

  // Global Controllers
  Get.put(ThemeController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final LanguageService languageService = Get.find<LanguageService>();

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return Obx(() => GetMaterialApp(
            title: "Application",
            debugShowCheckedModeBanner: false,

            // Localization
            translations: AppTranslations(),
            locale: languageService.currentLocale,
            fallbackLocale: const Locale('en', 'US'),

            // Routes
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.currentTheme,
          ),
        );
      },
    );
  }
}
