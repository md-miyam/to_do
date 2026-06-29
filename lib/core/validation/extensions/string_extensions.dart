extension StringExtensions on String {
  String get trimmed => trim();

  bool get isBlank => trimmed.isEmpty;
}
