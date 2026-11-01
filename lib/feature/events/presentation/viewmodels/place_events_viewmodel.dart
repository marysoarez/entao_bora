import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:mobx/mobx.dart';

part 'place_events_viewmodel.g.dart';

class PlaceEventsViewModel = PlaceEventsViewModelBase
    with _$PlaceEventsViewModel;

abstract class PlaceEventsViewModelBase with Store {
  PlaceEventsViewModelBase(this._repository);

  final IEventRepository _repository;

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  ObservableList<EventEntity> events = ObservableList<EventEntity>();

  @action
  Future<void> load(String placeId, {required String creatorId}) async {
    loading = true;
    error = null;

    final linkedResult = await _repository.getUpcomingEventsByPlace(placeId);
    final creatorResult = await _repository.getEventsByCreatorId(creatorId);
    final combined = <String, EventEntity>{};

    linkedResult.fold(
      (failure) {
        error = failure.message;
      },
      (data) {
        for (final event in data) {
          combined[event.id] = event;
        }
      },
    );

    creatorResult.fold(
      (failure) {
        error ??= failure.message;
      },
      (data) {
        for (final event in data) {
          final hasNoPlace =
              event.placeId == null || event.placeId!.trim().isEmpty;
          if (hasNoPlace) combined[event.id] = event;
        }
      },
    );

    final now = DateTime.now();
    final visible =
        combined.values
            .where(
              (event) =>
                  event.status == EventStatus.published &&
                  !event.endDate.isBefore(now),
            )
            .toList()
          ..sort((a, b) => a.endDate.compareTo(b.endDate));
    events
      ..clear()
      ..addAll(visible);

    loading = false;
  }

  @action
  Future<void> reload(String placeId, {required String creatorId}) {
    return load(placeId, creatorId: creatorId);
  }

  bool get hasEvents => events.isNotEmpty;

  bool get isEmpty => events.isEmpty;
}
