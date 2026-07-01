import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../logger/app_logger.dart';

class FocusShieldService extends GetxService {
  static FocusShieldService get to => Get.find();

  final _storageKey = 'blocked_apps';
  final _statusKey = 'is_shield_enabled';

  final isEnabled = false.obs;
  final blockedPackageNames = <String>[].obs;
  final isPermissionGranted = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadState();
    isPermissionGranted.value = false;
  }

  Future<void> _loadState() async {
    final box = Hive.box('settings_box');
    isEnabled.value = box.get(_statusKey, defaultValue: false);
    final savedApps = box.get(_storageKey, defaultValue: <String>[]);
    blockedPackageNames.assignAll(List<String>.from(savedApps));

    // Removed the blocking logic as part of the update
    // if (isEnabled.value) {
    //   _startBlocking();
    // }
  }

  Future<void> checkPermissions() async {
    isPermissionGranted.value = false;
  }

  Future<void> requestPermissions() async {
    AppLogger.info("Focus Shield permissions are disabled in this build.");
    await checkPermissions();
  }

  Future<void> toggleShield(bool value) async {
    isEnabled.value = value;
    final box = Hive.box('settings_box');
    await box.put(_statusKey, value);
    AppLogger.info("Focus Shield toggled: $value");
  }

  Future<void> updateBlockedApps(List<String> packages) async {
    blockedPackageNames.assignAll(packages);
    final box = Hive.box('settings_box');
    await box.put(_storageKey, packages);
  }

  Future<List<String>> getInstalledApps() async {
    return const [];
  }
}
