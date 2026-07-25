import 'package:entao_bora/shared/errors/base_error.dart';
import 'package:entao_bora/shared/errors/log_events.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class HandleLogError {
  LogEventsClient get logEventsClient => Modular.get();

  void logError({
    required Object error,
    required BaseError failure,
    required StackTrace stackTrace,
  }) {
    logEventsClient.logError(
      error: failure,
      originalError: error,
      stackTrace: stackTrace,
    );
  }
}