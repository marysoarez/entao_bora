import 'package:entao_bora/shared/errors/base_error.dart';

class FailureGetEvents extends BaseError {
  FailureGetEvents({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível carregar os eventos.',
  });
}

class FailureGetEventById extends BaseError {
  FailureGetEventById({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível carregar o evento.',
  });
}

class FailureCreateEvent extends BaseError {
  FailureCreateEvent({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível criar o evento.',
  });
}

class FailureUpdateEvent extends BaseError {
  FailureUpdateEvent({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível atualizar o evento.',
  });
}

class FailureDeleteEvent extends BaseError {
  FailureDeleteEvent({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível remover o evento.',
  });
}

class FailureIncrementEventViews extends BaseError {
  FailureIncrementEventViews({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível registrar a visualização do evento.',
  });
}

class FailureIncrementEventShares extends BaseError {
  FailureIncrementEventShares({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível registrar o compartilhamento do evento.',
  });
}

class FailureGetUpcomingEventsByPlace extends BaseError {
  FailureGetUpcomingEventsByPlace({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível carregar os próximos eventos do local.',
  });
}

class FailureIsUserGoing extends BaseError {
  FailureIsUserGoing({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível verificar se você marcou "Então Bora".',
  });
}

class FailureToggleBora extends BaseError {
  FailureToggleBora({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível atualizar sua confirmação no evento.',
  });
}

class FailureCheckIn extends BaseError {
  FailureCheckIn({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível realizar o check-in.',
  });
}

class FailureHasCheckedIn extends BaseError {
  FailureHasCheckedIn({
    super.stackTrace,
    super.exception,
    super.message = 'Não foi possível verificar o check-in do evento.',
  });
}