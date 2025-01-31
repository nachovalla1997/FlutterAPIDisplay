import 'package:flutter_api_display/core/base_exception.dart';
import 'package:multiple_result/multiple_result.dart' as multiple_result;

/// A wrapper for operation results that can be either successful or contain an error.
/// ```dart
/// // Return a success result
/// Result<String> getMessage() {
///    return const Result.success("Success message");
/// }
///
/// // Return an error result
/// Result<String> getErrorMessage() {
///    return Result.error(BaseException('Operation failed', 1000));
/// }
///
/// // Handle a result
/// Result<int> processMessage() {
///    final result = getMessage();
///
///    if (result.isError()) {
///      final error = result.tryGetError();
///      return Result.error(BaseException("Processing failed", 1001, error));
///    }
///
///    final message = result.getOrThrow();
///    return Result.success(message.length);
/// }
/// ```
typedef Result<S> = multiple_result.Result<S, BaseException>;
typedef Success<S, E> = multiple_result.Success<S, E>;
typedef Error<S, E> = multiple_result.Error<S, E>;
