import 'package:get/get.dart';
import '../../../../core/service/app_blocker/focus_shield_service.dart';
import '../models/app_usage_model.dart';
import '../repositories/usage_repository.dart';

class DigitalWellbeingController extends GetxController {
  final UsageRepository _repository = UsageRepository();
  final FocusShieldService _focusShield = FocusShieldService.to;

  final hasPermission = false.obs;
  final isLoading = false.obs;
  final usageList = <AppUsageModel>[].obs;
  final totalScreenTime = Duration.zero.obs;

  // App Blocker Integration
  final blockedAppsCount = 0.obs;
  final isShieldEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    blockedAppsCount.value = _focusShield.blockedPackageNames.length;
    isShieldEnabled.value = _focusShield.isEnabled.value;
    
    // Listen to changes in focus shield
    ever(_focusShield.blockedPackageNames, (List<String> apps) {
      blockedAppsCount.value = apps.length;
    });
    ever(_focusShield.isEnabled, (bool enabled) {
      isShieldEnabled.value = enabled;
    });

    checkPermissionAndFetch();
  }

  Future<void> checkPermissionAndFetch() async {
    isLoading.value = true;
    hasPermission.value = await _repository.hasPermission();
    if (hasPermission.value) {
      await fetchUsage();
    }
    isLoading.value = false;
  }

  Future<void> requestPermission() async {
    await _repository.requestPermission();
    // After returning from settings, the user might need to pull to refresh or we can poll
    // For now, we'll let the user click a refresh button or re-check on app resume
  }

  Future<void> fetchUsage() async {
    isLoading.value = true;
    final stats = await _repository.getTodayUsage();
    
    // Filter out apps with negligible usage (e.g., < 1 minute) if there are many
    usageList.assignAll(stats);
    
    final totalMs = stats.fold(0, (sum, item) => sum + item.usageTime.inMilliseconds);
    totalScreenTime.value = Duration(milliseconds: totalMs);
    
    isLoading.value = false;
  }

  String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return "${duration.inHours} hr ${duration.inMinutes % 60} min";
    } else {
      return "${duration.inMinutes} min";
    }
  }
}
