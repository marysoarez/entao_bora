import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/feature/user/domain/datasource/user_datasource.dart';
import 'package:mobx/mobx.dart';

part 'partner_dashboard_viewmodel.g.dart';

class PartnerDashboardViewModel = PartnerDashboardViewModelBase
    with _$PartnerDashboardViewModel;

abstract class PartnerDashboardViewModelBase with Store {
  PartnerDashboardViewModelBase(
    this._authRepository,
    this._placeRepository,
    this._eventRepository,
    this._userDatasource,
  );

  final IAuthRepository _authRepository;
  final IPlaceRepository _placeRepository;
  final IEventRepository _eventRepository;

  // TODO: substituir o acesso direto ao UserDatasource por uma abstracao de
  // dominio quando a feature tiver contrato apropriado para buscar usuarios.
  final UserDatasource _userDatasource;

  @observable
  bool loading = true;

  @observable
  String? error;

  @observable
  UserSummaryEntity? user;

  @observable
  List<PlaceEntity> places = [];

  @observable
  List<EventEntity> events = [];

  @observable
  List<EventEntity> visibleEvents = [];

  @observable
  PlaceEntity? selectedPlace;

  @computed
  int get totalViews =>
      visibleEvents.fold(0, (total, event) => total + event.views);

  @computed
  int get totalBoras =>
      visibleEvents.fold(0, (total, event) => total + event.boraCount);

  @computed
  int get totalCheckins =>
      visibleEvents.fold(0, (total, event) => total + event.checkinCount);

  @action
  void setInitialPlace(PlaceEntity? place) {
    selectedPlace = place;
  }

  @action
  Future<void> loadDashboard() async {
    loading = true;
    error = null;

    final currentUser = await _authRepository.getCurrentUser();

    if (currentUser == null) {
      user = null;
      loading = false;
      error = 'Faca login para acessar a area do parceiro.';
      return;
    }

    if (!currentUser.isPartner) {
      user = currentUser;
      loading = false;
      error = 'Voce precisa ser parceiro para acessar esta area.';
      return;
    }

    final ownerIds = _ownerIdsFor(currentUser);
    final partnerPlaces = <PlaceEntity>[];

    for (final ownerId in ownerIds) {
      final result = await _placeRepository.getPlacesByOwnerId(ownerId);

      final failed = result.fold(
        (failure) {
          user = currentUser;
          loading = false;
          error = failure.message;
          return true;
        },
        (places) {
          partnerPlaces.addAll(places);
          return false;
        },
      );

      if (failed) return;
    }

    final partnerEvents = <EventEntity>[];

    for (final ownerId in ownerIds) {
      partnerEvents.addAll(await _loadEventsByCreatorId(ownerId));
    }

    final uniquePlaces = _uniquePlaces(partnerPlaces);
    final uniqueEvents = _uniqueEvents(partnerEvents);

    user = currentUser;
    places = uniquePlaces;
    selectedPlace = _resolveSelectedPlace(uniquePlaces);
    events = uniqueEvents;
    visibleEvents = uniqueEvents;
    loading = false;
  }

  @action
  Future<void> selectPlace(PlaceEntity place) async {
    selectedPlace = place;
    visibleEvents = events;
    error = null;
  }

  Future<String?> transferEvent(EventEntity event, String targetUserId) async {
    final users = await _userDatasource.getUsersByIds([targetUserId]);

    if (users.isEmpty) {
      error = 'Usuario de destino nao encontrado.';
      return null;
    }

    final result = await _eventRepository.updateEvent(
      event.copyWith(createdBy: users.first, updatedAt: DateTime.now()),
    );

    final transferred = result.fold((failure) {
      error = failure.message;
      return false;
    }, (_) => true);

    if (!transferred) return null;

    await loadDashboard();
    return users.first.name;
  }

  List<String> _ownerIdsFor(UserSummaryEntity user) {
    return {
      user.id,
      if (user.partnerId != null && user.partnerId!.trim().isNotEmpty)
        user.partnerId!,
    }.toList();
  }

  List<PlaceEntity> _uniquePlaces(List<PlaceEntity> places) {
    return {for (final place in places) place.id: place}.values.toList();
  }

  List<EventEntity> _uniqueEvents(List<EventEntity> events) {
    return {for (final event in events) event.id: event}.values.toList();
  }

  PlaceEntity? _resolveSelectedPlace(List<PlaceEntity> partnerPlaces) {
    if (partnerPlaces.isEmpty) return null;

    final currentSelected = selectedPlace;
    if (currentSelected != null) {
      for (final place in partnerPlaces) {
        if (place.id == currentSelected.id) return place;
      }
    }

    return partnerPlaces.first;
  }

  Future<List<EventEntity>> _loadEventsByCreatorId(String creatorId) async {
    final result = await _eventRepository.getEventsByCreatorId(creatorId);

    return result.fold((failure) {
      error = failure.message;
      return <EventEntity>[];
    }, (events) => events);
  }
}
