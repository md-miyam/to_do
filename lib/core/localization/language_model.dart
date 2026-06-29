import 'package:flutter/material.dart';

class LanguageModel {
  final String name;
  final String code;
  final String countryCode;
  final String? flag;

  LanguageModel({
    required this.name,
    required this.code,
    required this.countryCode,
    this.flag,
  });

  Locale get locale => Locale(code, countryCode);

  static List<LanguageModel> languages = [
    LanguageModel(name: 'English', code: 'en', countryCode: 'US', flag: '🇺🇸'),
    LanguageModel(name: 'বাংলা', code: 'bn', countryCode: 'BD', flag: '🇧🇩'),
  ];
}
