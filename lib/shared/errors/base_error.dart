abstract class BaseError {

  final Object? exception;

  final StackTrace? stackTrace;

  final String message;

  const BaseError({
      this.exception,
      this.stackTrace,
      required this.message,
  });
}