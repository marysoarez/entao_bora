import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/notifications/data/notification_service.dart';
import 'package:mobx/mobx.dart';

part 'user_area_viewmodel.g.dart';

class UserAreaViewModel = UserAreaViewModelBase with _$UserAreaViewModel;

abstract class UserAreaViewModelBase with Store {
  UserAreaViewModelBase(
    this._authRepository,
    this._eventRepository,
    this._locationRepository,
    this._notificationService,
  );

  final IAuthRepository _authRepository;
  final IEventRepository _eventRepository;
  final ILocationRepository _locationRepository;
  final NotificationService _notificationService;

  @observable
  bool loading = false;

  @observable
  bool activatingNotifications = false;

  @observable
  String? error;

  @observable
  UserSummaryEntity? user;

  @observable
  List<EventEntity> boraEvents = [];

  @observable
  List<EventEntity> checkinEvents = [];

  @observable
  LocationEntity? currentLocation;

  @observable
  bool locationSharingEnabled = false;

  @observable
  bool notificationsEnabled = false;

  @computed
  bool get isLogged => user != null;

  @computed
  bool get hasCurrentLocation => currentLocation != null;

  @computed
  int get totalPersonalActions => boraEvents.length + checkinEvents.length;

  @computed
  List<EventEntity> get recentActivity {
    final events = <String, EventEntity>{};

    for (final event in [...checkinEvents, ...boraEvents]) {
      events[event.id] = event;
    }

    final activity = events.values.toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return activity.take(5).toList();
  }

  @action
  void clearSessionData() {
    user = null;
    boraEvents = [];
    checkinEvents = [];
    currentLocation = null;
    notificationsEnabled = false;
    locationSharingEnabled = false;
    error = null;
  }

  @action
  Future<void> load() async {
    loading = true;
    error = null;

    try {
      final currentUser = await _authRepository.getCurrentUser(
        forceRefresh: true,
      );

      if (currentUser == null) {
        clearSessionData();
        return;
      }

      final boraResult = await _eventRepository.getBoraEventsByUserId(
        currentUser.id,
      );
      final checkinResult = await _eventRepository.getCheckinEventsByUserId(
        currentUser.id,
      );

      var loadedBoraEvents = <EventEntity>[];
      var loadedCheckinEvents = <EventEntity>[];

      boraResult.fold(
        (failure) {
          error = failure.message;
        },
        (events) {
          loadedBoraEvents = events;
        },
      );

      checkinResult.fold(
        (failure) {
          error = failure.message;
        },
        (events) {
          loadedCheckinEvents = events;
        },
      );

      user = currentUser;
      notificationsEnabled = currentUser.notificationsEnabled;
      locationSharingEnabled = currentUser.locationSharingEnabled;
      currentLocation = currentUser.locationSharingEnabled
          ? currentUser.lastKnownLocation
          : null;
      boraEvents = loadedBoraEvents;
      checkinEvents = loadedCheckinEvents;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
    }
  }

  @action
  Future<bool> enableLocation() async {
    final currentUser = user;

    if (currentUser == null) {
      error = 'Entre para ativar localização.';
      return false;
    }

    final locationResult = await _locationRepository.getCurrentLocation();
    final location = locationResult.fold<LocationEntity?>((failure) {
      error = failure.message;
      return null;
    }, (location) => location);

    if (location == null) {
      return false;
    }

    final saveResult = await _locationRepository.enableLocationSharing(
      userId: currentUser.id,
      location: location,
    );

    return saveResult.fold(
      (failure) {
        error = failure.message;
        return false;
      },
      (_) {
        currentLocation = location;
        locationSharingEnabled = true;
        error = null;
        user = currentUser.copyWith(
          locationSharingEnabled: true,
          lastKnownLocation: location,
        );
        return true;
      },
    );
  }

  @action
  Future<bool> disableLocation() async {
    final currentUser = user;

    if (currentUser == null) {
      error = 'Entre para desativar localização.';
      return false;
    }

    final result = await _locationRepository.disableLocationSharing(
      userId: currentUser.id,
    );

    return result.fold(
      (failure) {
        error = failure.message;
        return false;
      },
      (_) {
        locationSharingEnabled = false;
        currentLocation = null;
        error = null;
        user = currentUser.copyWith(locationSharingEnabled: false);
        return true;
      },
    );
  }

  @action
  Future<String> activateNotifications() async {
    final currentUser = user;

    if (currentUser == null) {
      return 'Entre para ativar notificações.';
    }

    activatingNotifications = true;
    error = null;

    try {
      final result = await _notificationService.activate(user: currentUser);

      if (!result.success) {
        notificationsEnabled = false;
        error = result.message;
        user = currentUser.copyWith(notificationsEnabled: false);
        return result.message;
      }

      notificationsEnabled = true;
      error = null;
      user = currentUser.copyWith(notificationsEnabled: true);
      return result.message;
    } catch (e) {
      notificationsEnabled = false;
      error = e.toString();
      return 'Não foi possível ativar as notificações.';
    } finally {
      activatingNotifications = false;
    }
  }

  @action
  Future<String> deactivateNotifications() async {
    final currentUser = user;

    if (currentUser == null) {
      return 'Entre para desativar notificações.';
    }

    activatingNotifications = true;
    error = null;

    try {
      await _notificationService.deactivate(user: currentUser);

      notificationsEnabled = false;
      error = null;
      user = currentUser.copyWith(notificationsEnabled: false);
      return 'Notificações desativadas com sucesso.';
    } catch (e) {
      error = e.toString();
      return 'Não foi possível desativar as notificações.';
    } finally {
      activatingNotifications = false;
    }
  }
}
