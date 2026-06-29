import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

/// Centralized Hive Storage Service for the To-Do project.
/// Handles persistent data storage for various modules.
class HiveService extends GetxService {
  static HiveService get to => Get.find();

  // --- Box Names ---
  static const String _settingsBox = 'settings_box';
  static const String _sleepTrackerBox = 'sleep_tracker_box';
  static const String _tasksBox = 'tasks_box';

  // --- Initialize Hive ---
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Open standard boxes
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_sleepTrackerBox);
    await Hive.openBox(_tasksBox);
  }

  // ===========================================================================
  // Generic Methods
  // ===========================================================================

  /// Save data to a specific box
  Future<void> write(String boxName, String key, dynamic value) async {
    final box = Hive.box(boxName);
    await box.put(key, value);
  }

  /// Read data from a specific box
  dynamic read(String boxName, String key, {dynamic defaultValue}) {
    final box = Hive.box(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  /// Delete data from a specific box
  Future<void> delete(String boxName, String key) async {
    final box = Hive.box(boxName);
    await box.delete(key);
  }

  /// Clear an entire box
  Future<void> clearBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  // ===========================================================================
  // Module Specific Helpers (Example usage)
  // ===========================================================================

  // Settings
  Future<void> saveTheme(String mode) => write(_settingsBox, 'theme_mode', mode);
  String getTheme() => read(_settingsBox, 'theme_mode', defaultValue: 'system');

  // Sleep Tracker
  Future<void> saveSleepData(Map<String, dynamic> data) => write(_sleepTrackerBox, 'last_sleep', data);
  Map<String, dynamic>? getSleepData() {
    final data = read(_sleepTrackerBox, 'last_sleep');
    return data != null ? Map<String, dynamic>.from(data) : null;
  }
}
