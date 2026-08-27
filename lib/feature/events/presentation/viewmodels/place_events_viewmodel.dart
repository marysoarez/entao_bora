import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
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
  Future<void> load(String placeId) async {
    loading = true;
    error = null;
   
    final result = await _repository.getUpcomingEventsByPlace(placeId);

    result.fold(
      (failure) {
        error = failure.message;
      },
      (data) {
        events
          ..clear()
          ..addAll(data);

    for (final e in events) {
    }
      },
    );

    loading = false;
  }

  @action
  Future<void> reload(String placeId) {
    return load(placeId);
  }

  
  bool get hasEvents => events.isNotEmpty;

  bool get isEmpty => events.isEmpty;
}
