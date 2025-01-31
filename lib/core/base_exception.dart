import 'package:flutter_api_display/utilities/logger.dart';

/// Base exception class for all exceptions in the application
/// Exceptions for different packages must extend this class,
///
/// Example for HTTP errors.
/// ```dart
/// class HttpException extends BaseException {
///  final int statusCode;
///  final String body;
///  HttpException(super.message, super.code, this.statusCode, this.body, [super.innerException, super.stackTrace]);
/// }
/// ```
class BaseException implements Exception {
  final String message;
  final int code;
  final Exception innerException;
  StackTrace? stackTrace;

  BaseException._(this.message, this.code, this.innerException,
      [this.stackTrace]) {
    stackTrace ??= StackTrace.current;
    _logException();
  }

  factory BaseException(String message, int code,
      [dynamic error, StackTrace? stackTrace]) {
    Exception innerException;

    if (error is Exception) {
      innerException = error;
    } else if (error != null) {
      innerException = Exception(error.toString());
    } else {
      innerException = Exception(message);
    }

    return BaseException._(message, code, innerException, stackTrace);
  }

  void _logException() {
    AppLogger.error(
        message: "Exception: $message",
        error: innerException,
        stackTrace: stackTrace);
  }

  @override
  String toString() {
    return 'BaseException(code: $code, message: $message, innerException: $innerException)';
  }
}
