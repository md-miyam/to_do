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

    // Top Border
    buffer.writeln(LoggerUtils.topBorder);
    
    // Header Section
    buffer.writeln('${LoggerUtils.vertical} ${_header(level, title)}');
    buffer.writeln(LoggerUtils.middleDivider);

    // Meta Information
    if (LoggerConfig.showTime) {
      buffer.writeln('${LoggerUtils.vertical} 🕒 TIME    : ${LoggerUtils.formatTime(DateTime.now())}');
    }

    // Message Section
    buffer.writeln('${LoggerUtils.vertical} 📝 MESSAGE :');
    buffer.writeln(LoggerUtils.indent(LoggerUtils.normalize(message), spaces: 2));

    // Data Section
    if (data != null) {
      buffer.writeln(LoggerUtils.middleDivider);
      buffer.writeln('${LoggerUtils.vertical} 📦 DATA    :');
      buffer.writeln(LoggerUtils.indent(LoggerUtils.normalize(data), spaces: 2));
    }

    // Error Section
    if (error != null) {
      buffer.writeln(LoggerUtils.middleDivider);
      buffer.writeln('${LoggerUtils.vertical} 🚨 ERROR   :');
      buffer.writeln(LoggerUtils.indent(LoggerUtils.normalize(error), spaces: 2));
    }

    // Stack Trace Section
    if (stackTrace != null && LoggerConfig.showStackTrace) {
      buffer.writeln(LoggerUtils.middleDivider);
      buffer.writeln('${LoggerUtils.vertical} 👣 TRACE   :');
      buffer.writeln(LoggerUtils.indent(stackTrace.toString(), spaces: 2));
    }

    // Bottom Border
    buffer.writeln(LoggerUtils.bottomBorder);

    return buffer.toString();
  }

  static String _header(LoggerLevel level, String title) {
    final icon = _icon(level);
    final label = level.name.toUpperCase();
    return '$icon [$label] - $title';
  }

  static String _icon(LoggerLevel level) {
    if (!LoggerConfig.showIcon) return '';
    switch (level) {
      case LoggerLevel.trace: return '🔍';
      case LoggerLevel.debug: return '🛠️';
      case LoggerLevel.info: return '💡';
      case LoggerLevel.success: return '✅';
      case LoggerLevel.warning: return '⚠️';
      case LoggerLevel.error: return '❌';
      case LoggerLevel.critical: return '🔥';
    }
  }
}
