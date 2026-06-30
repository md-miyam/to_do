import 'logger_config.dart';
import 'logger_formatter.dart';
import 'logger_level.dart';
import 'logger_printer.dart';

final class AppLogger {
  AppLogger._();

  static void trace(String message, {Object? data}) {
    _log(level: LoggerLevel.trace, title: 'TRACE', message: message, data: data);
  }

  static void debug(String message, {Object? data}) {
    _log(level: LoggerLevel.debug, title: 'DEBUG', message: message, data: data);
  }

  static void info(String message, {Object? data}) {
    _log(level: LoggerLevel.info, title: 'INFO', message: message, data: data);
  }

  static void success(String message, {Object? data}) {
    _log(level: LoggerLevel.success, title: 'SUCCESS', message: message, data: data);
  }

  static void warning(String message, {Object? data}) {
    _log(level: LoggerLevel.warning, title: 'WARNING', message: message, data: data);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, Object? data}) {
    _log(level: LoggerLevel.error, title: 'ERROR', message: message, error: error, stackTrace: stackTrace, data: data);
  }

  static void critical(String message, {Object? error, StackTrace? stackTrace, Object? data}) {
    _log(level: LoggerLevel.critical, title: 'CRITICAL', message: message, error: error, stackTrace: stackTrace, data: data);
  }

  static void _log({
    required LoggerLevel level,
    required String title,
    required String message,
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    if (!LoggerConfig.enabled) return;
    if (level.index < LoggerConfig.minimumLevel.index) return;

    final formatted = LoggerFormatter.format(
      level: level,
      title: title,
      message: message,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );

    LoggerPrinter.printLog(level, formatted);
  }
}
