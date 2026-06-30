import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'core/const/app_theme.dart';
import 'core/localization/app_translations.dart';
import 'core/service/language_service.dart';
import 'core/service/theme_change/theme_controller.dart';
import 'core/utils/initializer.dart';

void main() async {
  // Centralized Initialization for better maintainability
  await AppInitializer.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final themeController = Get.find<ThemeController>();
          final languageService = Get.find<LanguageService>();

          return GetMaterialApp(
            title: "Focus To-Do",
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
          );
        });
      },
    );
  }
}
