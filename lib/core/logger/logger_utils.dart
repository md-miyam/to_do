import 'dart:convert';

final class LoggerUtils {
  LoggerUtils._();

  static const String topLeft = '╔';
  static const String topRight = '╗';
  static const String bottomLeft = '╚';
  static const String bottomRight = '╝';
  static const String vertical = '║';
  static const String horizontal = '═';
  static const String dividerLeft = '╟';
  static const String dividerRight = '╢';
  static const String dividerHorizontal = '─';

  static String get topBorder => '$topLeft${repeat(horizontal, 100)}$topRight';
  static String get bottomBorder => '$bottomLeft${repeat(horizontal, 100)}$bottomRight';
  static String get middleDivider => '$dividerLeft${repeat(dividerHorizontal, 100)}$dividerRight';

  static String repeat(String value, int count) {
    return List.filled(count, value).join();
  }

  static String indent(String text, {int spaces = 2}) {
    final padding = repeat(' ', spaces);
    return text.split('\n').map((line) => '$vertical $padding$line').join('\n');
  }

  static String formatJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }

  static String formatTime(DateTime time) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    String threeDigits(int value) => value.toString().padLeft(3, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}:${twoDigits(time.second)}.${threeDigits(time.millisecond)}';
  }

  static List<String> splitLongText(String text, {int chunkSize = 1000}) {
    if (text.length <= chunkSize) return [text];
    final chunks = <String>[];
    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      chunks.add(text.substring(i, end));
    }
    return chunks;
  }

  static String normalize(Object? value) {
    if (value == null) return 'null';
    if (value is Map || value is List) return formatJson(value);
    final text = value.toString();
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map || decoded is List) return formatJson(decoded);
    } catch (_) {}
    return text;
  }
}
