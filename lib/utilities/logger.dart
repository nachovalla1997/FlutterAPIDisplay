import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart'; // For date and time formatting
import 'package:logger/logger.dart';

/// Custom LogPrinter for clean Flutter console output
class CleanPrinter extends LogPrinter {
  final String className;

  CleanPrinter({this.className = ''});

  @override
  List<String> log(LogEvent event) {
    final emoji = _getEmoji(event.level);
    final time = _formattedDateTime();
    final message = event.message;
    final levelName = event.level.toString().split('.').last.toUpperCase();

    final output = StringBuffer()
      ..write('[$time] $emoji [$levelName] ')
      ..write(className.isNotEmpty ? '$className: ' : '')
      ..write('$message');

    if (event.stackTrace != null) {
      output.write('\nStack Trace:\n${event.stackTrace}');
    }

    return [output.toString()];
  }

  String _formattedDateTime() {
    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd').format(now); // Example: 2025-01-07
    final time =
        DateFormat('HH:mm:ss.SSS').format(now); // Example: 02:09:08.718

    return '$date - $time';
  }

  String _getEmoji(Level level) {
    switch (level) {
      case Level.debug:
        return '🐞';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.fatal:
        return '💀';
      default:
        return '🔍';
    }
  }
}

/// AppLogger: Singleton Logger with environment-aware configuration
class AppLogger {
  static final Logger _logger = Logger(
    printer: kDebugMode
        ? CleanPrinter(className: 'AppLogger')
        : PrettyPrinter(
            methodCount: 0, // No stack trace in production
            errorMethodCount: 5,
            lineLength: 120,
            colors: false, // Colors disabled in production
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.dateAndTime,
          ),
    level: kDebugMode ? Level.debug : Level.error,
  );

  static Logger get instance => _logger;

  /// Logs debug messages
  static void debug({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Logs info messages
  static void info({
    required String message,
  }) {
    if (kDebugMode) _logger.i(message);
  }

  /// Logs warning messages
  static void warning({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Logs error messages
  static void error({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Logs fatal messages
  static void fatal({
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
