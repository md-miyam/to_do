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

    // Split long messages to prevent truncation in some consoles
    final lines = message.split('\n');
    
    for (final line in lines) {
      final chunks = LoggerUtils.splitLongText(line, chunkSize: 800);
      for (final chunk in chunks) {
        final output = LoggerColors.wrap(
          chunk,
          color,
          boldText: level.index >= LoggerLevel.warning.index,
        );

        // developer.log works well in Android Studio with proper names
        developer.log(
          output,
          name: 'APP_LOGGER',
          level: _developerLogLevel(level),
        );

        // debugPrint for standard console output
        if (kDebugMode) {
          debugPrint(output);
        }
      }
    }
  }

  static int _developerLogLevel(LoggerLevel level) {
    switch (level) {
      case LoggerLevel.trace: return 0;
      case LoggerLevel.debug: return 500;
      case LoggerLevel.info: return 800;
      case LoggerLevel.success: return 800;
      case LoggerLevel.warning: return 900;
      case LoggerLevel.error: return 1000;
      case LoggerLevel.critical: return 2000;
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
        return LoggerColors.brightGreen;
      case LoggerLevel.warning:
        return LoggerColors.yellow;
      case LoggerLevel.error:
        return LoggerColors.red;
      case LoggerLevel.critical:
        return LoggerColors.brightRed;
    }
  }
}
