import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../../../../core/service/usage_stats_service.dart';
import '../../../../core/service/storage/hive_service.dart';
import '../models/app_usage_model.dart';

class UsageRepository {
  final UsageStatsService _service = UsageStatsService();
  
  // Simple in-memory cache for app info to improve performance
  final Map<String, String> _labelCache = {};
  final Map<String, Uint8List?> _iconCache = {};

  Future<bool> hasPermission() => _service.checkUsagePermission();
  Future<void> requestPermission() => _service.grantUsagePermission();

  Future<List<AppUsageModel>> getTodayUsage() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final stats = await _service.getUsageStats(startOfDay, now);
    final List<AppUsageModel> models = [];

    for (var stat in stats) {
      final String pkg = stat['packageName'];
      
      // Get label
      if (!_labelCache.containsKey(pkg)) {
        _labelCache[pkg] = await _service.getAppLabel(pkg);
      }
      
      // Get icon
      if (!_iconCache.containsKey(pkg)) {
        _iconCache[pkg] = await _service.getAppIcon(pkg);
      }

      models.add(AppUsageModel.fromJson(
        stat, 
        icon: _iconCache[pkg],
        label: _labelCache[pkg]
      )); 
    }

    // Sort by usage time descending
    models.sort((a, b) => b.usageTime.compareTo(a.usageTime));
    
    // Save total daily usage to Hive for historical data
    _saveDailyTotal(models);

    return models;
  }

  void _saveDailyTotal(List<AppUsageModel> models) {
    if (models.isEmpty) return;
    
    final totalMs = models.fold(0, (sum, item) => sum + item.usageTime.inMilliseconds);
    final dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    HiveService.to.write('wellbeing_box', dateKey, {
      'totalUsageMs': totalMs,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<Map<String, int>> getHistoricalUsage(int days) async {
    final Map<String, int> history = {};
    final now = DateTime.now();
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final data = HiveService.to.read('wellbeing_box', dateKey);
      if (data != null) {
        history[dateKey] = data['totalUsageMs'] as int;
      }
    }
    return history;
  }
}
