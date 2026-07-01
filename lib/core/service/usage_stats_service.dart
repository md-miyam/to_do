import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UsageStatsService {
  // MethodChannel is commented out to prevent Play Protect flags
  // static const MethodChannel _channel = MethodChannel('com.makeyourday.productivity/usage_stats');

  Future<bool> checkUsagePermission() async {
    // Feature disabled to allow app installation
    return false;
  }

  Future<void> grantUsagePermission() async {
    debugPrint("Digital Wellbeing is currently disabled.");
  }

  Future<List<Map<String, dynamic>>> getUsageStats(DateTime start, DateTime end) async {
    return [];
  }

  Future<Uint8List?> getAppIcon(String packageName) async {
    return null;
  }

  Future<String> getAppLabel(String packageName) async {
    return packageName;
  }
}
