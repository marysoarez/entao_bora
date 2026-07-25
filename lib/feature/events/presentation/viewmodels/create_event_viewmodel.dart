import 'package:entao_bora/feature/events/domain/entities/event_attraction_entit.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/feature/events/domain/entities/event_ticket_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/ticket_type_enum.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'create_event_viewmodel.g.dart';

class CreateEventViewModel = CreateEventViewModelBase
    with _$CreateEventViewModel;

abstract class CreateEventViewModelBase with Store {
  CreateEventViewModelBase(this._eventRepository, this._placeRepository);

  final IEventRepository _eventRepository;
  final IPlaceRepository _placeRepository;

  //==========================================================
  // Estado
  //==========================================================

  @observable
  bool loading = false;

  @observable
  String? error;

  //==========================================================
  // Campos
  //==========================================================

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  String instagram = '';

  @observable
  PlaceEntity? place;

  @observable
  DateTime? startDate;

  @observable
  DateTime? endDate;

  @observable
  ObservableList<MusicGenre> musicGenres = ObservableList();

  @observable
  ObservableList<EventAttractionEntity> attractions = ObservableList();

  @observable
  ObservableList<XFile> photos = ObservableList();

  @observable
  EventTicketEntity ticket = const EventTicketEntity(type: TicketType.free);

  //==========================================================
  // Actions
  //==========================================================

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setInstagram(String value) => instagram = value;

  @action
  void setPlace(PlaceEntity value) => place = value;

  @action
  void setStartDate(DateTime value) => startDate = value;

  @action
  void setEndDate(DateTime value) => endDate = value;

  @action
  void setTicketType(TicketType type) {
    ticket = ticket.copyWith(
      type: type,
      ticketUrl: type == TicketType.free ? null : ticket.ticketUrl,
    );
  }

  @action
  void setTicketUrl(String value) {
    ticket = ticket.copyWith(ticketUrl: value);
  }

  @action
  void toggleGenre(MusicGenre genre) {
    if (musicGenres.contains(genre)) {
      musicGenres.remove(genre);
    } else {
      musicGenres.add(genre);
    }
  }

  @action
  void addAttraction(EventAttractionEntity attraction) {
    attractions.add(attraction);
  }

  @action
  void removeAttraction(EventAttractionEntity attraction) {
    attractions.remove(attraction);
  }

  @action
  void addPhoto(XFile photo) {
    photos.add(photo);
  }

  @action
  void removePhoto(XFile photo) {
    photos.remove(photo);
  }

  @action
  Future<List<PlaceEntity>> loadPlaces() async {
    final result = await _placeRepository.getPlaces();

    return result.fold((failure) {
      error = failure.message;
      return [];
    }, (places) => places);
  }

  //==========================================================
  // Save
  //==========================================================

  @action
  Future<bool> save() async {
    error = null;

    final validation = _validate();

    if (validation != null) {
      error = validation;
      return false;
    }

    loading = true;

    final event = await _buildEvent();

    final result = await _eventRepository.createEvent(event);

    loading = false;

    return result.fold((failure) {
      error = failure.message;
      return false;
    }, (_) => true);
  }

  //==========================================================
  // Helpers
  //==========================================================
Future<EventEntity> _buildEvent() async {
  final now = DateTime.now();

  final gallery = <String>[];

  for (final photo in photos) {
    gallery.add(
      await ImageHelper.fileToBase64(photo),
    );
  }

  return EventEntity(
    id: '',
    title: title.trim(),
    description: description.trim(),
    placeId: place!.id,
    placeName: place!.name,
    startDate: startDate!,
    endDate: endDate!,
    coverImage: gallery.isNotEmpty ? gallery.first : '',
    gallery: gallery,
    musicGenres: musicGenres.toList(),
    attractions: attractions.toList(),
    ticket: ticket,
    instagram: instagram.trim().isEmpty ? null : instagram.trim(),
    boraCount: 0,
    checkinCount: 0,
    views: 0,
    shares: 0,
    isBora: false,
    hasCheckedIn: false,
    createdBy: '',
    createdAt: now,
    updatedAt: now,
    status: EventStatus.published,
  );
}
  // EventEntity _buildEvent() {
  //   final now = DateTime.now();

  //   return EventEntity(
  //     id: '',
  //     title: title.trim(),
  //     description: description.trim(),
  //     placeId: place!.id,
  //     placeName: place!.name,
  //     startDate: startDate!,
  //     endDate: endDate!,
  //     coverImage: '',
  //     gallery: const [],
  //     musicGenres: musicGenres.toList(),
  //     attractions: attractions.toList(),
  //     ticket: ticket,
  //     instagram: instagram.trim().isEmpty ? null : instagram.trim(),
  //     boraCount: 0,
  //     checkinCount: 0,
  //     views: 0,
  //     shares: 0,
  //     isBora: false,
  //     hasCheckedIn: false,
  //     createdBy: '',
  //     createdAt: now,
  //     updatedAt: now,
  //     status: EventStatus.published,
  //   );
  // }

  String? _validate() {
    if (title.trim().isEmpty) {
      return 'Informe o nome do evento.';
    }

    if (description.trim().isEmpty) {
      return 'Informe uma descrição.';
    }

    if (place == null) {
      return 'Selecione um local.';
    }

    if (startDate == null) {
      return 'Informe a data de início.';
    }

    if (endDate == null) {
      return 'Informe a data de término.';
    }

    if (endDate!.isBefore(startDate!)) {
      return 'A data final deve ser maior que a inicial.';
    }

    if (ticket.type == TicketType.external) {
      final url = ticket.ticketUrl?.trim() ?? '';

      if (url.isEmpty) {
        return 'Informe o link para compra do ingresso.';
      }

      final uri = Uri.tryParse(url);

      if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
        return 'Informe um link válido.';
      }
    }

    return null;
  }

  //==========================================================
  // Validators
  //==========================================================

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome do evento.';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe uma descrição.';
    }

    return null;
  }

  String? validateInstagram(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (value.contains('http') ||
        value.contains('www.') ||
        value.contains('instagram.com')) {
      return 'Informe apenas o usuário do Instagram.';
    }

    return null;
  }

  bool get isValid =>
      title.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      place != null &&
      startDate != null &&
      endDate != null;

  bool get hasExternalTicket => ticket.type == TicketType.external;

  bool get hasPhotos => photos.isNotEmpty;

  bool get hasGenres => musicGenres.isNotEmpty;

  bool get hasAttractions => attractions.isNotEmpty;
}
