import 'package:app_blocker/app_blocker.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../logger/app_logger.dart';

class FocusShieldService extends GetxService {
  static FocusShieldService get to => Get.find();
  
  final _appBlocker = AppBlocker.instance;
  final _storageKey = 'blocked_apps';
  final _statusKey = 'is_shield_enabled';
  
  final isEnabled = false.obs;
  final blockedPackageNames = <String>[].obs;
  final isPermissionGranted = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadState();
    checkPermissions();
  }

  Future<void> _loadState() async {
    final box = Hive.box('settings_box');
    isEnabled.value = box.get(_statusKey, defaultValue: false);
    final savedApps = box.get(_storageKey, defaultValue: <String>[]);
    blockedPackageNames.assignAll(List<String>.from(savedApps));
    
    if (isEnabled.value) {
      _startBlocking();
    }
  }

  Future<void> checkPermissions() async {
    try {
      final status = await _appBlocker.checkPermission();
      // In 2.1.0 it returns BlockerPermissionStatus
      isPermissionGranted.value = status == BlockerPermissionStatus.granted;
    } catch (_) {
      isPermissionGranted.value = false;
    }
  }

  Future<void> requestPermissions() async {
    try {
      await _appBlocker.requestPermission();
      await checkPermissions();
    } catch (e) {
      AppLogger.error("Failed to request permissions", error: e);
    }
  }

  Future<void> toggleShield(bool value) async {
    if (value && !isPermissionGranted.value) {
      await requestPermissions();
      if (!isPermissionGranted.value) return;
    }

    isEnabled.value = value;
    final box = Hive.box('settings_box');
    await box.put(_statusKey, value);

    if (value) {
      _startBlocking();
    } else {
      _stopBlocking();
    }
  }

  Future<void> updateBlockedApps(List<String> packages) async {
    blockedPackageNames.assignAll(packages);
    final box = Hive.box('settings_box');
    await box.put(_storageKey, packages);
    
    if (isEnabled.value) {
      _startBlocking();
    }
  }

  void _startBlocking() {
    if (blockedPackageNames.isEmpty) return;
    try {
      _appBlocker.blockApps(blockedPackageNames);
      AppLogger.info("Focus Shield Started: Blocking ${blockedPackageNames.length} apps");
    } catch (e) {
      AppLogger.error("Failed to start blocking", error: e);
    }
  }

  void _stopBlocking() {
    try {
      _appBlocker.unblockAll();
      AppLogger.info("Focus Shield Stopped");
    } catch (e) {
      AppLogger.error("Failed to stop blocking", error: e);
    }
  }

  Future<List<AppInfo>> getInstalledApps() async {
    try {
      return await _appBlocker.getApps();
    } catch (e) {
      AppLogger.error("Failed to fetch installed apps", error: e);
      return [];
    }
  }
}
