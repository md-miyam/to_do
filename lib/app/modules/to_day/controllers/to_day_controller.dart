import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/timeline_task_card.dart';

class ToDayController extends GetxController {
  final tasks = <Map<String, dynamic>>[].obs;
  
  final doneCount = 0.obs;
  final notDoneCount = 0.obs;
  final completionRate = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    Hive.box('tasks_box').listenable().addListener(loadTasks);
  }

  void loadTasks() {
    final box = Hive.box('tasks_box');
    final List<dynamic> allRawTasks = box.get('all_tasks', defaultValue: []);
    
    // Filter by TODAY'S date
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    final List<Map<String, dynamic>> filteredTasks = allRawTasks
        .map((t) => Map<String, dynamic>.from(t))
        .where((t) => t['date'] == todayStr)
        .toList();
    
    // Sort tasks by start time
    filteredTasks.sort((a, b) => (a['start_time'] as String).compareTo(b['start_time'] as String));
    
    tasks.value = filteredTasks;
    _calculateStats();
  }

  void _calculateStats() {
    if (tasks.isEmpty) {
      doneCount.value = 0;
      notDoneCount.value = 0;
      completionRate.value = 0;
      return;
    }

    int done = 0;
    for (var task in tasks) {
      if (task['is_done'] == true) done++;
    }

    doneCount.value = done;
    notDoneCount.value = tasks.length - done;
    completionRate.value = ((done / tasks.length) * 100).toInt();
  }

  TaskStatus getTaskStatus(Map<String, dynamic> task) {
    if (task['is_done'] == true) return TaskStatus.done;
    
    final index = tasks.indexOf(task);
    // Logic for "Current": It's the first non-done task
    if (index == tasks.indexWhere((t) => t['is_done'] != true)) {
      return TaskStatus.current;
    }

    return TaskStatus.upcoming;
  }

  void markTaskAsDone(int index) {
    final box = Hive.box('tasks_box');
    final List<dynamic> allRawTasks = box.get('all_tasks', defaultValue: []);
    final allTasks = allRawTasks.map((t) => Map<String, dynamic>.from(t)).toList();
    
    // Find the task by unique ID
    final taskId = tasks[index]['id'];
    final globalIndex = allTasks.indexWhere((t) => t['id'] == taskId);
    
    if (globalIndex != -1) {
      allTasks[globalIndex]['is_done'] = true;
      box.put('all_tasks', allTasks);
      loadTasks(); // This will trigger Obx update
    }
  }

  void planTomorrow() {
    Get.snackbar("Action", "Navigating to Tomorrow's Planning");
  }

  void viewPastSummaries() {
    Get.snackbar("Action", "Opening Past Summaries");
  }
}
