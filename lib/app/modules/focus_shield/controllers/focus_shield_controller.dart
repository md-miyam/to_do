import 'dart:async';
import 'package:app_blocker/app_blocker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/service/app_blocker/focus_shield_service.dart';
import '../../../../core/logger/app_logger.dart';

class FocusShieldController extends GetxController with WidgetsBindingObserver {
  final _service = FocusShieldService.to;
  
  // State
  final allApps = <AppInfo>[].obs;
  final filteredApps = <AppInfo>[].obs;
  final isLoading = false.obs;
  final searchQuery = "".obs;
  final showOnlyBlocked = false.obs;

  // Computed Properties
  bool get isShieldEnabled => _service.isEnabled.value;
  List<String> get blockedPackages => _service.blockedPackageNames;
  bool get hasPermission => _service.isPermissionGranted.value;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchApps();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  // Handle app resume to re-check permissions (User might have granted them in settings)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _service.checkPermissions();
    }
  }

  Future<void> fetchApps() async {
    try {
      isLoading.value = true;
      final apps = await _service.getInstalledApps();
      
      // Filter out system apps that might be critical or non-blockable 
      // (Optional logic, usually based on package name or AppInfo flags if available)
      
      apps.sort((a, b) => (a.appName ?? "").toLowerCase().compareTo((b.appName ?? "").toLowerCase()));
      allApps.assignAll(apps);
      _applyFilter();
    } catch (e) {
      AppLogger.error("Controller: Failed to fetch apps", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void toggleFilterBlocked() {
    showOnlyBlocked.value = !showOnlyBlocked.value;
    _applyFilter();
  }

  void _applyFilter() {
    var list = allApps.where((app) {
      final nameMatches = (app.appName ?? "").toLowerCase().contains(searchQuery.value.toLowerCase());
      final isBlocked = blockedPackages.contains(app.packageName);
      
      if (showOnlyBlocked.value) {
        return nameMatches && isBlocked;
      }
      return nameMatches;
    }).toList();
    
    filteredApps.assignAll(list);
  }

  void toggleAppSelection(String packageName) {
    final newList = List<String>.from(blockedPackages);
    if (newList.contains(packageName)) {
      newList.remove(packageName);
    } else {
      newList.add(packageName);
    }
    _service.updateBlockedApps(newList);
    
    // If we are in "Only Blocked" view and we unselect, refresh the view
    if (showOnlyBlocked.value) {
      _applyFilter();
    }
  }

  Future<void> toggleShield(bool value) async {
    await _service.toggleShield(value);
  }

  Future<void> requestPermission() async {
    await _service.requestPermissions();
  }
}
