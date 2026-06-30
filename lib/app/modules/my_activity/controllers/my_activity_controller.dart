import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/localization/language_model.dart';
import '../../../../core/service/language_service.dart';
import '../../../../core/service/theme_change/theme_controller.dart';
import '../../../../core/const/app_colors.dart';
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

  // --- Settings Logic (Migrated from SetDayController) ---

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
