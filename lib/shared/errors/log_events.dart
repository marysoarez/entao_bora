import 'package:entao_bora/shared/errors/base_error.dart';

abstract class LogEventsClient {
  Future<void> logError({
    required BaseError error,
    required Object? originalError,
    required StackTrace stackTrace,
    int? statusCode,
    String? errorMessage,
  });
}