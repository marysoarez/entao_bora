import 'package:entao_bora/shared/errors/base_error.dart';

class UnexpectedError extends BaseError {
  UnexpectedError({
    super.stackTrace,
    super.exception,
    super.message = 'Ocorreu um erro inesperado!',
  });
}
