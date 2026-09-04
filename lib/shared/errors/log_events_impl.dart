import 'package:entao_bora/shared/errors/base_error.dart';
import 'package:entao_bora/shared/errors/log_events.dart';

class LogEventsClientImpl implements LogEventsClient {
  @override
  Future<void> logError({
    required BaseError error,
    required Object? originalError,
    required StackTrace stackTrace,
    int? statusCode,
    String? errorMessage,
  }) async {}
}
