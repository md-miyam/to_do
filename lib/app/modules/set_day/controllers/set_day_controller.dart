import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import '../../../../core/service/storage/hive_service.dart';
import '../../../../core/service/theme_change/theme_controller.dart';
import '../../../../core/service/language_service.dart';
import '../../../../core/localization/language_model.dart';
import '../../../../core/const/app_colors.dart';

class SetDayController extends GetxController {
  // --- State Variables: Sleep Tracker ---
  final selectedDate = DateTime.now().obs;
  final startTime = DateTime(2024, 1, 1, 22, 0).obs; // Default 10:00 PM
  final duration = 8.0.obs;
  final wakeUpTime = "".obs;
  final isSleepInfoSet = false.obs;

  // --- State Variables: Routine Builder ---
  final isRoutineBuilderVisible = false.obs;
  final routineStartTime = DateTime.now().obs;
  final routineEndTime = DateTime.now().add(const Duration(minutes: 30)).obs;
  final selectedCategory = "".obs; 
  final links = <String>[].obs;
  
  final cycleInitialStartTime = DateTime.now().obs;
  final isDayComplete = false.obs;

  // Validation State
  final taskNameError = RxnString();
  final categoryError = RxnString();

  // Controllers
  late TextEditingController taskNameController;
  late TextEditingController descriptionController;
  late TextEditingController linkInputController;

  final categories = [
    'self_care', 'routine', 'university_studies', 'outside_work', 
    'programming', 'course_list', 'deep_work', 'health_fitness'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    taskNameController = TextEditingController();
    descriptionController = TextEditingController();
    linkInputController = TextEditingController();
    wakeUpTime.value = "--:--";

    taskNameController.addListener(() {
      if (taskNameError.value != null && taskNameController.text.isNotEmpty) {
        taskNameError.value = null;
      }
    });
  }

  @override
  void onClose() {
    taskNameController.dispose();
    descriptionController.dispose();
    linkInputController.dispose();
    super.onClose();
  }

  // --- Sleep Tracker Methods ---

  void pickStartTime(BuildContext context) {
    if (isRoutineBuilderVisible.value) return;

    picker.DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      currentTime: startTime.value,
      onConfirm: (time) {
        startTime.value = time;
        if (duration.value > 0) isSleepInfoSet.value = true;
        _calculateWakeUpTime();
      },
      locale: Get.locale?.languageCode == 'bn' ? picker.LocaleType.bn : picker.LocaleType.en,
      theme: _pickerTheme(context),
    );
  }

  void updateDuration(String value) {
    if (isRoutineBuilderVisible.value) return;

    if (value.trim().isEmpty) {
      isSleepInfoSet.value = false;
      wakeUpTime.value = "--:--";
      return;
    }
    final parsed = double.tryParse(value);
    if (parsed != null && parsed >= 0 && parsed <= 24) {
      duration.value = parsed;
      isSleepInfoSet.value = true;
      _calculateWakeUpTime();
    } else {
      isSleepInfoSet.value = false;
      wakeUpTime.value = "--:--";
    }
  }

  void _calculateWakeUpTime() {
    final wakeUp = startTime.value.add(Duration(minutes: (duration.value * 60).toInt()));
    wakeUpTime.value = DateFormat('hh:mm a').format(wakeUp);
  }

  void resetAllData() {
    isSleepInfoSet.value = false;
    isRoutineBuilderVisible.value = false;
    wakeUpTime.value = "--:--";
    duration.value = 8.0;
    startTime.value = DateTime(2024, 1, 1, 22, 0);
    _prepareNextTask();
  }

  void onAfterWakingUp() {
    // Before starting a new day plan, clear previous data for this specific date
    // as per user request: "remove previous data and make new day"
    _clearExistingTasksForSelectedDate();

    final wakeUp = startTime.value.add(Duration(minutes: (duration.value * 60).toInt()));
    routineStartTime.value = wakeUp;
    cycleInitialStartTime.value = wakeUp;
    routineEndTime.value = wakeUp.add(const Duration(minutes: 30));
    isRoutineBuilderVisible.value = true;
    isDayComplete.value = false;
    _checkDayCompletion();
  }

  void _clearExistingTasksForSelectedDate() {
    final box = HiveService.to.read('tasks_box', 'all_tasks') ?? [];
    final allTasks = (box as List).map((task) => Map<String, dynamic>.from(task)).toList();
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    
    // Remove all tasks matching the selected date
    allTasks.removeWhere((task) => task['date'] == dateStr);
    
    HiveService.to.write('tasks_box', 'all_tasks', allTasks);
  }

  // --- Routine Builder Methods ---

  void pickRoutineTime(BuildContext context, bool isStart) {
    if (isStart) return;
    
    picker.DatePicker.showTime12hPicker(
      context,
      showTitleActions: true,
      currentTime: routineEndTime.value,
      onConfirm: (time) {
        if (time.isAfter(routineStartTime.value)) {
          routineEndTime.value = time;
          _checkDayCompletion();
        } else {
          Get.snackbar("invalid_time".tr, "end_time_error".tr);
        }
      },
      locale: Get.locale?.languageCode == 'bn' ? picker.LocaleType.bn : picker.LocaleType.en,
      theme: _pickerTheme(context),
    );
  }

  void _checkDayCompletion() {
    final availableHours = 24.0 - duration.value;
    final dayLimit = cycleInitialStartTime.value.add(Duration(minutes: (availableHours * 60).toInt()));
    
    if (routineEndTime.value.isAtSameMomentAs(dayLimit) || routineEndTime.value.isAfter(dayLimit)) {
      isDayComplete.value = true;
    } else {
      isDayComplete.value = false;
    }
  }

  void addLink(String url) => links.add(url);
  void removeLink(int index) => links.removeAt(index);

  void setCategory(String category) {
    selectedCategory.value = category;
    categoryError.value = null;
  }

  void addCustomCategory(String category) {
    if (category.trim().isNotEmpty && !categories.contains(category.trim())) {
      categories.add(category.trim());
      setCategory(category.trim());
    }
  }

  Future<void> addTask() async {
    if (isDayComplete.value) return;

    bool hasError = false;

    if (taskNameController.text.trim().isEmpty) {
      taskNameError.value = "task_name_required".tr;
      hasError = true;
    }
    
    if (selectedCategory.value.isEmpty) {
      categoryError.value = "category_required".tr;
      hasError = true;
    }

    if (hasError) return;

    final taskData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': taskNameController.text.trim(),
      'start_time': DateFormat('hh:mm a').format(routineStartTime.value),
      'end_time': DateFormat('hh:mm a').format(routineEndTime.value),
      'date': DateFormat('yyyy-MM-dd').format(selectedDate.value), // ADDED DATE
      'category': selectedCategory.value,
      'description': descriptionController.text.trim(),
      'links': links.toList(),
      'type': routineTypeTitle,
      'is_done': false,
    };

    // Store in a centralized list for easier filtering
    final box = HiveService.to.read('tasks_box', 'all_tasks') ?? [];
    final allTasks = (box as List).map((task) => Map<String, dynamic>.from(task)).toList();
    allTasks.add(taskData);
    await HiveService.to.write('tasks_box', 'all_tasks', allTasks);

    Get.snackbar("success".tr, "task_added".tr);
    _prepareNextTask();
  }

  void _prepareNextTask() {
    taskNameController.clear();
    descriptionController.clear();
    links.clear();
    selectedCategory.value = "";
    taskNameError.value = null;
    categoryError.value = null;
    
    routineStartTime.value = routineEndTime.value;
    _checkDayCompletion();
    
    if (!isDayComplete.value) {
      routineEndTime.value = routineStartTime.value.add(const Duration(minutes: 30));
      _checkDayCompletion();
    }
  }

  // --- Getters ---
  String get formattedStartTime => DateFormat('hh:mm a').format(startTime.value);
  String get formattedRoutineStart => DateFormat('hh:mm a').format(routineStartTime.value);
  String get formattedRoutineEnd => DateFormat('hh:mm a').format(routineEndTime.value);

  String get routineTypeTitle {
    final hour = routineStartTime.value.hour;
    if (hour >= 5 && hour < 12) return 'morning_routine'.tr;
    if (hour >= 12 && hour < 17) return 'afternoon_routine'.tr;
    if (hour >= 17 && hour < 21) return 'evening_routine'.tr;
    return 'night_routine'.tr;
  }

  IconData get routineHeaderIcon {
    final hour = routineStartTime.value.hour;
    if (hour >= 5 && hour < 12) return Icons.wb_sunny_outlined;
    if (hour >= 12 && hour < 17) return Icons.light_mode_outlined;
    if (hour >= 17 && hour < 21) return Icons.wb_twilight;
    return Icons.nightlight_round;
  }

  // --- General Logic ---

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.brand(context),
            primary: AppColors.brand(context),
            onPrimary: AppColors.isDark(context) ? Colors.black : Colors.white,
            surface: AppColors.surface(context),
            onSurface: AppColors.text(context),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      selectedDate.value = picked;
      // When date changes, reset the builder to show data for that specific day
      isRoutineBuilderVisible.value = false;
      isSleepInfoSet.value = false;
    }
  }

  void showSettings(BuildContext context) {
    Get.bottomSheet(
      Obx(() {
        final theme = Get.find<ThemeController>();
        final lang = Get.find<LanguageService>();
        final isDark = theme.themeMode.value == 'dark' || (theme.themeMode.value == 'system' && Get.isDarkMode);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(isDark),
              Text('settings'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkText : AppColors.lightText)),
              const SizedBox(height: 15),
              _buildSettingRow(icon: Icons.brightness_6_outlined, title: 'theme'.tr, isDark: isDark, 
                trailing: _buildDropdown(value: theme.themeMode.value, items: ['light', 'dark', 'system'], onChanged: (v) => v != null ? theme.setThemeMode(v) : null, isDark: isDark, itemLabel: (v) => v.tr.capitalizeFirst!)),
              _buildSettingRow(icon: Icons.language_outlined, title: 'language'.tr, isDark: isDark, 
                trailing: _buildDropdown(value: lang.currentLanguage, items: LanguageModel.languages, onChanged: (v) => v != null ? lang.updateLocale(v) : null, isDark: isDark, itemLabel: (v) => v.name)),
            ],
          ),
        );
      }),
      backgroundColor: Colors.transparent,
    );
  }

  // --- Helper UI Components ---

  picker.DatePickerTheme _pickerTheme(BuildContext context) => picker.DatePickerTheme(
    containerHeight: 250,
    backgroundColor: AppColors.surface(context),
    itemStyle: TextStyle(color: AppColors.text(context), fontSize: 18),
    doneStyle: TextStyle(color: AppColors.brand(context), fontSize: 16, fontWeight: FontWeight.bold),
    cancelStyle: TextStyle(color: AppColors.subText(context), fontSize: 16),
  );

  Widget _buildHandle(bool isDark) => Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: isDark ? AppColors.darkDivider : AppColors.lightDivider, borderRadius: BorderRadius.circular(2)));

  Widget _buildSettingRow({required IconData icon, required String title, required bool isDark, required Widget trailing}) {
    final color = isDark ? AppColors.primaryDark : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        CircleAvatar(backgroundColor: color.withAlpha(isDark ? 40 : 25), radius: 18, child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 15),
        Expanded(child: Text(title, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 15, fontWeight: FontWeight.w500))),
        trailing,
      ]),
    );
  }

  Widget _buildDropdown<T>({required T value, required List<T> items, required Function(T?) onChanged, required bool isDark, required String Function(T) itemLabel}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: isDark ? AppColors.darkBackground : AppColors.lightBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
      child: DropdownButtonHideUnderline(child: DropdownButton<T>(
        value: value, dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface, borderRadius: BorderRadius.circular(12),
        icon: Icon(Icons.keyboard_arrow_down, size: 18, color: isDark ? AppColors.primaryDark : AppColors.primary),
        style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText, fontSize: 13, fontWeight: FontWeight.w500),
        items: items.map((T item) => DropdownMenuItem<T>(value: item, child: Text(itemLabel(item)))).toList(),
        onChanged: onChanged,
      )),
    );
  }
}
