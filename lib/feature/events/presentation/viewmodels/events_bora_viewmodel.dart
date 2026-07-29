import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/shared/enum/checkin_results.dart';
import 'package:mobx/mobx.dart';

part 'events_bora_viewmodel.g.dart';

class EventActionsViewModel = EventActionsViewModelBase
    with _$EventActionsViewModel;

abstract class EventActionsViewModelBase with Store {
  EventActionsViewModelBase(
    this._eventRepository,
    this._locationRepository,
    this._authRepository,
    this.event,
  );

  final IEventRepository _eventRepository;
  final ILocationRepository _locationRepository;

  @observable
  PlaceEntity? place;

  final AuthRepository _authRepository;
  UserSummaryEntity? get currentUser => _authRepository.currentUser;

  @computed
  bool get isLogged => currentUser != null;

  @observable
  EventEntity event;

  @observable
  bool loading = false;

  @observable
  String? error;

  @computed
  bool get canCheckIn =>
      !event.hasCheckedIn &&
      DateTime.now().isAfter(event.startDate) &&
      DateTime.now().isBefore(event.endDate);

  @action
  Future<void> toggleBora() async {
    if (loading) return;
    if (!isLogged) {
      error = 'Faça login para continuar.';
      return;
    }
    loading = true;
    error = null;

    final result = await _eventRepository.toggleBora(
      eventId: event.id,
      user: currentUser!,
      isBora: event.isBora,
    );

    result.fold(
      (failure) {
        error = failure.message;
      },
      (_) {
        event = event.copyWith(
          isBora: !event.isBora,
          boraCount: event.isBora ? event.boraCount - 1 : event.boraCount + 1,
        );
      },
    );

    loading = false;
  }

  @action
  Future<CheckInResult?> checkIn() async {
    if (loading) {
      return CheckInResult.alreadyCheckedIn;
    }

    if (event.hasCheckedIn) {
      return CheckInResult.alreadyCheckedIn;
    }

    final now = DateTime.now();

    if (now.isBefore(event.startDate)) {
      return CheckInResult.eventNotStarted;
    }

    if (now.isAfter(event.endDate)) {
      return CheckInResult.eventFinished;
    }
    if (!isLogged) {
      error = 'Faça login para continuar.';
      return CheckInResult.error;
    }
    loading = true;
    error = null;
    final locationResult = await _locationRepository.getCurrentLocationIfNear(
      event.address.location,
    );

    LocationEntity? location;

    locationResult.fold(
      (failure) {
        error = failure.message;
      },
      (value) {
        location = value;
      },
    );

    if (location == null) {
      loading = false;

      if (error != null) {
        return null;
      }

      return CheckInResult.tooFar;
    }

    final checkInResult = await _eventRepository.checkIn(
      eventId: event.id,
      user: currentUser!,
      latitude: location!.latitude,
      longitude: location!.longitude,
    );

    final result = checkInResult.fold<CheckInResult?>(
      (failure) {
        error = failure.message;
        return null;
      },
      (_) {
        event = event.copyWith(
          hasCheckedIn: true,
          checkinCount: event.checkinCount + 1,
        );

        return CheckInResult.success;
      },
    );

    loading = false;

    return result;
  }
}
