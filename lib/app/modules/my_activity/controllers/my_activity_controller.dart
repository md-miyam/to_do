import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../to_day/models/daily_progress_model.dart';

class MyActivityController extends GetxController {
  final history = <String, DailyProgressModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    // Listen for history box changes
    Hive.box('history_box').listenable().addListener(loadHistory);
  }

  void loadHistory() {
    final box = Hive.box('history_box');
    final Map<String, DailyProgressModel> historyMap = {};
    
    for (var key in box.keys) {
      final data = box.get(key);
      if (data != null) {
        historyMap[key.toString()] = DailyProgressModel.fromJson(Map<String, dynamic>.from(data));
      }
    }
    history.assignAll(historyMap);
  }
}
