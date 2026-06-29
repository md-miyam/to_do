import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'logger_colors.dart';
import 'logger_level.dart';
import 'logger_utils.dart';

final class LoggerPrinter {
  LoggerPrinter._();

  static void printLog(
    LoggerLevel level,
    String message,
  ) {
    final color = _color(level);

    final chunks = LoggerUtils.splitLongText(message);

    for (final chunk in chunks) {
      final output = LoggerColors.wrap(
        chunk,
        color,
        boldText: true,
      );

      developer.log(
        output,
        name: 'AppLogger',
      );

      if (kDebugMode) {
        debugPrint(output);
      }
    }
  }

  static String _color(LoggerLevel level) {
    switch (level) {
      case LoggerLevel.trace:
        return LoggerColors.brightBlack;
      case LoggerLevel.debug:
        return LoggerColors.cyan;
      case LoggerLevel.info:
        return LoggerColors.blue;
      case LoggerLevel.success:
        return LoggerColors.green;
      case LoggerLevel.warning:
        return LoggerColors.yellow;
      case LoggerLevel.error:
        return LoggerColors.red;
      case LoggerLevel.critical:
        return LoggerColors.brightRed;
    }
  }
}
