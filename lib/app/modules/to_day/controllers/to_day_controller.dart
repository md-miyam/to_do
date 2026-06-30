import 'dart:async';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time/time.dart';
import '../widgets/timeline_task_card.dart';
import '../models/daily_progress_model.dart';

class ToDayController extends GetxController {
  final tasks = <Map<String, dynamic>>[].obs;
  
  final doneCount = 0.obs;
  final totalCount = 0.obs;
  final completionRate = 0.obs;

  // Heatmap State
  final history = <String, DailyProgressModel>{}.obs;

  // Timer State
  final currentTaskTimeLeft = "".obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    loadHistory();
    Hive.box('tasks_box').listenable().addListener(loadTasks);
    Hive.box('sleep_tracker_box').listenable().addListener(loadTasks);
    Hive.box('history_box').listenable().addListener(loadHistory);
    _startTimer();
    
    // Auto refresh status every minute to switch active tasks
    _statusRefreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      tasks.refresh();
      _calculateStats();
    });
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
    history.value = historyMap;
  }

  void _updateHistory() {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    int denied = 0;
    int pending = 0;
    for (var task in tasks) {
      final status = getTaskStatus(task);
      if (status == TaskStatus.missed) denied++;
      if (status == TaskStatus.pending) pending++;
    }

    final progress = DailyProgressModel(
      date: todayStr,
      totalTasks: tasks.length,
      completedTasks: doneCount.value,
      deniedTasks: denied,
      pendingTasks: pending,
      completionRate: completionRate.value,
    );

    Hive.box('history_box').put(todayStr, progress.toJson());
  }

  Timer? _statusRefreshTimer;

  @override
  void onClose() {
    _timer?.cancel();
    _statusRefreshTimer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  DateTime _parseTime(String timeStr) {
    try {
      final now = DateTime.now();
      final DateFormat format = DateFormat("hh:mm a");
      final parsed = format.parse(timeStr);
      return DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
    } catch (e) {
      return DateTime.now();
    }
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    
    // Find the task that is currently active based on time
    int currentIndex = -1;
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      if (task['is_done'] == true || task['is_denied'] == true) continue;
      
      final start = _parseTime(task['start_time']);
      final end = _parseTime(task['end_time']);
      
      // Handle midnight crossing for sleep tasks
      var adjustedEnd = end;
      if (end.isBefore(start)) {
        if (now.isAfter(start)) {
          adjustedEnd = end + 1.days;
        } else if (now.isBefore(end)) {
          // We are in the early morning part of a task that started yesterday
        }
      }

      if (now.isAfter(start) && now.isBefore(adjustedEnd)) {
        currentIndex = i;
        break;
      }
    }

    if (currentIndex != -1) {
      final currentTask = tasks[currentIndex];
      try {
        final end = _parseTime(currentTask['end_time']);
        var adjustedEnd = end;
        final start = _parseTime(currentTask['start_time']);
        if (end.isBefore(start)) {
          if (now.isAfter(start)) {
            adjustedEnd = end + 1.days;
          }
        }

        final difference = adjustedEnd.difference(now);
        if (difference.isNegative) {
          currentTaskTimeLeft.value = "00:00:00";
        } else {
          final hours = difference.inHours.toString().padLeft(2, '0');
          final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
          currentTaskTimeLeft.value = "$hours:$minutes:$seconds";
        }
      } catch (e) {
        currentTaskTimeLeft.value = "--:--:--";
      }
    } else {
      currentTaskTimeLeft.value = "";
    }
  }

  void loadTasks() {
    final taskBox = Hive.box('tasks_box');
    final sleepBox = Hive.box('sleep_tracker_box');
    
    final List<dynamic> allRawTasks = taskBox.get('all_tasks', defaultValue: []);
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    final List<Map<String, dynamic>> filteredTasks = allRawTasks
        .map((t) => Map<String, dynamic>.from(t))
        .where((t) => t['date'] == todayStr)
        .toList();
    
    final sleepData = sleepBox.get('last_sleep');
    if (sleepData != null) {
      final sleepMap = Map<String, dynamic>.from(sleepData);
      final startTime = sleepMap['start_time'] as DateTime;
      final duration = sleepMap['duration'] as double;
      final wakeUpTime = startTime.add(Duration(minutes: (duration * 60).toInt()));

      final sleepTask = {
        'id': 'sleep_task_foundation',
        'name': 'sleep_wake_up'.tr,
        'start_time': DateFormat('hh:mm a').format(startTime),
        'end_time': DateFormat('hh:mm a').format(wakeUpTime),
        'category': 'routine',
        'description': 'rest_well'.tr,
        'is_done': sleepMap['is_done'] ?? false,
        'is_denied': sleepMap['is_denied'] ?? false,
        'is_foundation': true,
        'links': [],
      };
      filteredTasks.insert(0, sleepTask);
    }
    
    filteredTasks.sort((a, b) {
      // 1. Sleep task (is_foundation) always comes first
      if (a['is_foundation'] == true) return -1;
      if (b['is_foundation'] == true) return 1;

      // 2. Others sorted by start_time chronologically
      final DateTime timeA = _parseTime(a['start_time']);
      final DateTime timeB = _parseTime(b['start_time']);
      
      return timeA.compareTo(timeB);
    });
    
    tasks.value = filteredTasks;
    _calculateStats();
    _calculateTimeLeft(); // Immediate update after load
  }

  void _calculateStats() {
    if (tasks.isEmpty) {
      doneCount.value = 0;
      totalCount.value = 0;
      completionRate.value = 0;
      return;
    }

    int done = 0;
    for (var task in tasks) {
      if (task['is_done'] == true) {
        done++;
      }
    }

    doneCount.value = done;
    totalCount.value = tasks.length;
    completionRate.value = ((done / tasks.length) * 100).toInt();

    _updateHistory();
  }

  TaskStatus getTaskStatus(Map<String, dynamic> task) {
    if (task['is_done'] == true) return TaskStatus.done;
    if (task['is_denied'] == true) return TaskStatus.missed;
    
    final now = DateTime.now();
    final start = _parseTime(task['start_time']);
    final end = _parseTime(task['end_time']);
    
    // Handle midnight crossing
    var adjustedEnd = end;
    if (end.isBefore(start)) {
      if (now.isAfter(start)) {
        adjustedEnd = end + 1.days;
      } else if (now.isBefore(end)) {
        // We are in the morning part of the task
        return TaskStatus.current;
      }
    }

    if (now.isAfter(start) && now.isBefore(adjustedEnd)) {
      return TaskStatus.current;
    }

    if (now.isAfter(adjustedEnd)) {
      return TaskStatus.pending; // Overdue but not marked
    }

    return TaskStatus.upcoming;
  }

  void markTaskAsDone(int index) {
    _updateTaskState(index, isDone: true, isDenied: false);
  }

  void markTaskAsDenied(int index) {
    _updateTaskState(index, isDone: false, isDenied: true);
  }

  void _updateTaskState(int index, {required bool isDone, required bool isDenied}) {
    final task = tasks[index];
    
    if (task['is_foundation'] == true) {
      final box = Hive.box('sleep_tracker_box');
      final sleepData = Map<String, dynamic>.from(box.get('last_sleep'));
      sleepData['is_done'] = isDone;
      sleepData['is_denied'] = isDenied;
      box.put('last_sleep', sleepData);
    } else {
      final box = Hive.box('tasks_box');
      final List<dynamic> allRawTasks = box.get('all_tasks', defaultValue: []);
      final allTasks = allRawTasks.map((t) => Map<String, dynamic>.from(t)).toList();
      
      final taskId = task['id'];
      final globalIndex = allTasks.indexWhere((t) => t['id'] == taskId);
      
      if (globalIndex != -1) {
        allTasks[globalIndex]['is_done'] = isDone;
        allTasks[globalIndex]['is_denied'] = isDenied;
        box.put('all_tasks', allTasks);
      }
    }
    loadTasks();
  }

  void planTomorrow() {
    Get.snackbar("Action", "Navigating to Tomorrow's Planning");
  }

  void viewPastSummaries() {
    Get.snackbar("Action", "Opening Past Summaries");
  }
}
