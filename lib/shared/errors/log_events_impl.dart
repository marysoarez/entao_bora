import 'package:entao_bora/shared/errors/base_error.dart';
import 'package:entao_bora/shared/errors/log_events.dart';
import 'package:flutter/foundation.dart';

class LogEventsClientImpl implements LogEventsClient {
  @override
  Future<void> logError({
    required BaseError error,
    required Object? originalError,
    required StackTrace stackTrace,
    int? statusCode,
    String? errorMessage,
  }) async {
    debugPrint('================ ERROR ================');
    debugPrint('Failure: ${error.runtimeType}');
    debugPrint('Message: ${error.message}');
    debugPrint('Original: $originalError');
    debugPrint('Status: $statusCode');
    debugPrint('ErrorMessage: $errorMessage');
    debugPrint(stackTrace.toString());
    debugPrint('=======================================');
  }
}