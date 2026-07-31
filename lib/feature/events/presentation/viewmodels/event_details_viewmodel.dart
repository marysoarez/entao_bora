import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:mobx/mobx.dart';

part 'event_details_viewmodel.g.dart';

class EventDetailsViewModel = _EventDetailsViewModelBase
    with _$EventDetailsViewModel;

abstract class _EventDetailsViewModelBase with Store {
  final IEventRepository eventRepository;
  final IPlaceRepository placeRepository;
  final IAuthRepository _authRepository;

  _EventDetailsViewModelBase(
    this.eventRepository,
    this.placeRepository,
    this._authRepository,
  );

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  EventEntity? event;

  @observable
  PlaceEntity? place;

  @action
  Future<void> load(String id) async {
    loading = true;
    error = null;

    final userId = _authRepository.currentUser?.id;

    final result = await eventRepository.getEventById(
      eventId: id,
      userId: userId,
    );

    await result.fold(
      (failure) async {
        error = 'Erro ao carregar o evento.';
      },
      (loadedEvent) async {
        if (loadedEvent == null) {
          error = 'Evento não encontrado.';
          return;
        }

        event = loadedEvent;

        if (loadedEvent.placeId != null) {
          final placeResult = await placeRepository.getPlaceById(
            loadedEvent.placeId!,
          );

          placeResult.fold(
            (failure) {
              error = 'Não foi possível carregar o estabelecimento.';
            },
            (loadedPlace) {
              place = loadedPlace;
            },
          );
        }
      },
    );

    loading = false;
  }
}
