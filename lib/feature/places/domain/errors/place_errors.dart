import 'package:entao_bora/shared/errors/base_error.dart';

class FailureGetPlaces extends BaseError {
  FailureGetPlaces({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível carregar os locais.',
  });
}
class FailureUpdatePlace extends BaseError {
  FailureUpdatePlace({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível carregar os locais.',
  });
}

class FailureCreatePlace extends BaseError {
  FailureCreatePlace({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível cadastrar o local.',
  });
}
class FailureGetPlaceById extends BaseError {
  FailureGetPlaceById({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível cadastrar o local.',
  });
}