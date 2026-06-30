import 'package:flutter/services.dart';

class UsageStatsService {
  static const MethodChannel _channel = MethodChannel('com.todo.to_do/usage_stats');

  Future<bool> checkUsagePermission() async {
    try {
      return await _channel.invokeMethod('checkUsagePermission') ?? false;
    } on PlatformException catch (e) {
      print("Error checking usage permission: ${e.message}");
      return false;
    }
  }

  Future<void> grantUsagePermission() async {
    try {
      await _channel.invokeMethod('grantUsagePermission');
    } on PlatformException catch (e) {
      print("Error granting usage permission: ${e.message}");
    }
  }

  Future<List<Map<String, dynamic>>> getUsageStats(DateTime start, DateTime end) async {
    try {
      final List<dynamic> stats = await _channel.invokeMethod('getUsageStats', {
        'startTime': start.millisecondsSinceEpoch,
        'endTime': end.millisecondsSinceEpoch,
      });
      return stats.map((e) => Map<String, dynamic>.from(e)).toList();
    } on PlatformException catch (e) {
      print("Error getting usage stats: ${e.message}");
      return [];
    }
  }

  Future<Uint8List?> getAppIcon(String packageName) async {
    try {
      return await _channel.invokeMethod('getAppIcon', {'packageName': packageName});
    } on PlatformException catch (e) {
      print("Error getting app icon for $packageName: ${e.message}");
      return null;
    }
  }

  Future<String> getAppLabel(String packageName) async {
    try {
      return await _channel.invokeMethod('getAppLabel', {'packageName': packageName}) ?? packageName;
    } on PlatformException catch (e) {
      print("Error getting app label for $packageName: ${e.message}");
      return packageName;
    }
  }
}
