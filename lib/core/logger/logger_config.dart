import 'package:flutter/foundation.dart';
import 'logger_level.dart';

final class LoggerConfig {
  LoggerConfig._();

  /// Disable all logs.
  static bool enabled = kDebugMode;

  /// Minimum log level.
  static LoggerLevel minimumLevel = LoggerLevel.trace;

  /// Maximum line length before splitting.
  static int lineWidth = 120;

  /// Show timestamp.
  static bool showTime = true;

  /// Show emoji/icon.
  static bool showIcon = true;

  /// Show stack trace on errors.
  static bool showStackTrace = true;

  /// Pretty print JSON.
  static bool prettyJson = true;

  /// Include caller information (file, method, line).
  static bool showCaller = true;
}
