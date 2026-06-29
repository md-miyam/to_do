import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localization/language_model.dart';

class LanguageService extends GetxService {
  static LanguageService get to => Get.find();
  
  static const String _storageKey = 'selected_language_code';
  static const String _storageCountryKey = 'selected_language_country';
  
  final _selectedLocale = const Locale('en', 'US').obs;
  Locale get currentLocale => _selectedLocale.value;

  @override
  void onInit() {
    super.onInit();
    _initLocale();
  }

  void _initLocale() {
    final prefs = Get.find<SharedPreferences>();
    String? langCode = prefs.getString(_storageKey);
    String? countryCode = prefs.getString(_storageCountryKey);

    if (langCode != null && countryCode != null) {
      _selectedLocale.value = Locale(langCode, countryCode);
    } else {
      // Fallback to device locale if supported, otherwise default to English
      Locale? deviceLocale = Get.deviceLocale;
      if (deviceLocale != null && _isSupported(deviceLocale)) {
        _selectedLocale.value = deviceLocale;
      } else {
        _selectedLocale.value = const Locale('en', 'US');
      }
    }
  }

  bool _isSupported(Locale locale) {
    return LanguageModel.languages.any(
      (element) => element.code == locale.languageCode
    );
  }

  Future<void> updateLocale(LanguageModel language) async {
    final prefs = Get.find<SharedPreferences>();
    
    _selectedLocale.value = language.locale;
    
    await prefs.setString(_storageKey, language.code);
    await prefs.setString(_storageCountryKey, language.countryCode);
    
    Get.updateLocale(language.locale);
  }

  LanguageModel get currentLanguage {
    return LanguageModel.languages.firstWhere(
      (element) => element.code == _selectedLocale.value.languageCode,
      orElse: () => LanguageModel.languages.first,
    );
  }
}
