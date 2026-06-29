import 'logger_config.dart';
import 'logger_level.dart';
import 'logger_utils.dart';

final class LoggerFormatter {
  LoggerFormatter._();

  static String format({
    required LoggerLevel level,
    required String title,
    required String message,
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    final buffer = StringBuffer();

    buffer.writeln(LoggerUtils.horizontal);
    buffer.writeln(_header(level, title));
    buffer.writeln(LoggerUtils.horizontal);

    if (LoggerConfig.showTime) {
      buffer.writeln(
        LoggerUtils.value(
          'Time',
          LoggerUtils.formatTime(DateTime.now()),
        ),
      );
      buffer.writeln();
    }

    buffer.writeln(
      LoggerUtils.value(
        'Message',
        LoggerUtils.normalize(message),
      ),
    );

    if (data != null) {
      buffer.writeln();
      buffer.writeln(
        LoggerUtils.value(
          'Data',
          LoggerUtils.normalize(data),
        ),
      );
    }

    if (error != null) {
      buffer.writeln();
      buffer.writeln(
        LoggerUtils.value(
          'Error',
          LoggerUtils.normalize(error),
        ),
      );
    }

    if (stackTrace != null && LoggerConfig.showStackTrace) {
      buffer.writeln();
      buffer.writeln(
        LoggerUtils.section(
          'Stack Trace',
          stackTrace,
        ),
      );
    }

    buffer.writeln(LoggerUtils.horizontal);

    return buffer.toString();
  }

  static String _header(
    LoggerLevel level,
    String title,
  ) {
    return '${_icon(level)} $title';
  }

  static String _icon(LoggerLevel level) {
    if (!LoggerConfig.showIcon) {
      return '';
    }

    switch (level) {
      case LoggerLevel.trace:
        return '⚪';
      case LoggerLevel.debug:
        return '🔍';
      case LoggerLevel.info:
        return 'ℹ️';
      case LoggerLevel.success:
        return '✅';
      case LoggerLevel.warning:
        return '⚠️';
      case LoggerLevel.error:
        return '❌';
      case LoggerLevel.critical:
        return '🔥';
    }
  }
}
