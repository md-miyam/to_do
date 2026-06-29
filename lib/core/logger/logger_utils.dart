import 'dart:convert';

final class LoggerUtils {
  LoggerUtils._();

  static const String horizontal =
      '════════════════════════════════════════════════════════════════════════════════';

  static const String thinHorizontal =
      '────────────────────────────────────────────────────────────────────────────────';

  static String repeat(String value, int count) {
    return List.filled(count, value).join();
  }

  static String center(String text, int width) {
    if (text.length >= width) {
      return text;
    }

    final totalPadding = width - text.length;
    final left = totalPadding ~/ 2;
    final right = totalPadding - left;

    return '${repeat(' ', left)}$text${repeat(' ', right)}';
  }

  static String indent(
    String text, {
    int spaces = 2,
  }) {
    final padding = repeat(' ', spaces);

    return text
        .split('\n')
        .map((line) => '$padding$line')
        .join('\n');
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

    return '${time.year}-'
        '${twoDigits(time.month)}-'
        '${twoDigits(time.day)} '
        '${twoDigits(time.hour)}:'
        '${twoDigits(time.minute)}:'
        '${twoDigits(time.second)}.'
        '${threeDigits(time.millisecond)}';
  }

  static List<String> splitLongText(
    String text, {
    int chunkSize = 1000,
  }) {
    if (text.length <= chunkSize) {
      return [text];
    }

    final chunks = <String>[];

    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length)
          ? i + chunkSize
          : text.length;

      chunks.add(text.substring(i, end));
    }

    return chunks;
  }

  static String value(
    String title,
    Object? value,
  ) {
    return '$title\n  ${value ?? "null"}';
  }

  static String section(
    String title, [
    Object? body,
  ]) {
    final buffer = StringBuffer();

    buffer.writeln(title);

    if (body != null) {
      buffer.writeln(indent(body.toString()));
    }

    return buffer.toString().trimRight();
  }

  static bool isJson(String text) {
    try {
      jsonDecode(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  static String normalize(Object? value) {
    if (value == null) {
      return 'null';
    }

    if (value is Map || value is List) {
      return formatJson(value);
    }

    final text = value.toString();

    if (isJson(text)) {
      return formatJson(jsonDecode(text));
    }

    return text;
  }
}
