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

  @computed
  bool get isLogged => user != null;

  @computed
  bool get locationEnabled => currentLocation != null;

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
  Future<void> load() async {
    loading = true;
    error = null;

    try {
      final currentUser = await _authRepository.getCurrentUser();
      user = currentUser;
      loading = false;

      if (currentUser == null) {
        boraEvents = [];
        checkinEvents = [];
        return;
      }

      final eventsResult = await _eventRepository.getEvents(
        userId: currentUser.id,
      );

      eventsResult.fold(
        (failure) {
          error = failure.message;
          boraEvents = [];
          checkinEvents = [];
        },
        (events) {
          boraEvents = events.where((event) => event.isBora).toList();
          checkinEvents = events.where((event) => event.hasCheckedIn).toList();
        },
      );
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
    }
  }

  @action
  Future<bool> enableLocation() async {
    final result = await _locationRepository.getCurrentLocation();

    return result.fold(
      (failure) {
        error = failure.message;
        return false;
      },
      (location) {
        currentLocation = location;
        error = null;
        return true;
      },
    );
  }

  @action
  void disableLocation() {
    currentLocation = null;
  }

  @action
  Future<String> activateNotifications() async {
    final currentUser = user;
    if (currentUser == null) {
      return 'Entre para ativar notificacoes.';
    }

    activatingNotifications = true;

    try {
      var location = currentLocation;

      if (location == null) {
        final enabled = await enableLocation();
        if (!enabled) {
          return error ??
              'Compartilhe sua localizacao para ativar notificacoes.';
        }

        location = currentLocation;
      }

      if (location == null) {
        return 'Nao foi possivel obter sua localizacao.';
      }

      final result = await _notificationService.activate(
        user: currentUser,
        location: location,
      );

      return result.message;
    } finally {
      activatingNotifications = false;
    }
  }
}
