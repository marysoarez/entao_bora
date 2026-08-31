import 'package:entao_bora/shared/errors/base_error.dart';

class FailureGetCurrentLocation extends BaseError {
  FailureGetCurrentLocation({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class FailureSearchAddress extends BaseError {
  FailureSearchAddress({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class FailureReverseGeocode extends BaseError {
  FailureReverseGeocode({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class FailureGeocodeAddress extends BaseError {
  FailureGeocodeAddress({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}

class FailureIsNear extends BaseError {
  FailureIsNear({required super.message, super.exception, super.stackTrace});
}

class FailureGetCurrentLocationIfNear extends BaseError {
  FailureGetCurrentLocationIfNear({
    required super.message,
    super.exception,
    super.stackTrace,
  });
}
