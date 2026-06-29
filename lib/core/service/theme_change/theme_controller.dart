import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static const String _themeKey = 'theme_mode';

  /// Possible values: 'light', 'dark', 'system'
  RxString themeMode = 'system'.obs;

  ThemeMode get currentTheme {
    switch (themeMode.value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey) ?? 'system';
    themeMode.value = saved;
    Get.changeThemeMode(currentTheme);
  }

  Future<void> setThemeMode(String mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(currentTheme);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }
}