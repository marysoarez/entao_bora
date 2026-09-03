import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/core/location/domain/repositories/location_repository.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/auth/domain/repositries/auth_repository.dart';
import 'package:entao_bora/feature/events/domain/entities/event_attraction_entit.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/feature/events/domain/entities/event_ticket_entity.dart';
import 'package:entao_bora/feature/events/domain/repositories/event_repositor.dart';
import 'package:entao_bora/feature/places/domain/entities/place_entity.dart';
import 'package:entao_bora/feature/places/domain/repositories/place_repository.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';
import 'package:entao_bora/shared/enum/ticket_type_enum.dart';
import 'package:entao_bora/shared/errors/image_exception.dart';
import 'package:entao_bora/shared/helpers/image_helper.dart';
import 'package:entao_bora/shared/helpers/slug_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

part 'create_event_viewmodel.g.dart';

class CreateEventViewModel = CreateEventViewModelBase
    with _$CreateEventViewModel;

abstract class CreateEventViewModelBase with Store {
  CreateEventViewModelBase(
    this._eventRepository,
    this._placeRepository,
    this._locationRepository,
    this._authRepository,
  );

  final ILocationRepository _locationRepository;
  final IEventRepository _eventRepository;
  final IPlaceRepository _placeRepository;
  final IAuthRepository _authRepository;

  @observable
  bool loading = false;

  @observable
  String? error;

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
  XFile? coverPhoto;

  @observable
  ObservableList<MusicGenre> musicGenres = ObservableList();

  @observable
  ObservableList<EventAttractionEntity> attractions = ObservableList();

  @observable
  ObservableList<XFile> photos = ObservableList();

  @observable
  EventTicketEntity ticket = const EventTicketEntity(type: TicketType.free);

  @observable
  AddressEntity? address;

  String? coverImage;

  EventEntity? editingEvent;

  @computed
  bool get isValid =>
      title.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      (place != null || address != null) &&
      startDate != null &&
      endDate != null;

  @computed
  bool get hasExternalTicket => ticket.type == TicketType.external;

  @computed
  bool get hasPhotos => photos.isNotEmpty;

  @computed
  bool get hasGenres => musicGenres.isNotEmpty;

  @computed
  bool get hasAttractions => attractions.isNotEmpty;

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) => description = value;

  @action
  void setInstagram(String value) => instagram = value;

  @action
  void setPlace(PlaceEntity value) {
    place = value;
    address = null;
  }

  @action
  void setStartDate(DateTime value) => startDate = value;

  @action
  void setEndDate(DateTime value) => endDate = value;

  @action
  void setCoverPhoto(XFile file) {
    coverPhoto = file;
    coverImage = null;
  }

  @action
  void removeCoverPhoto() {
    coverPhoto = null;
    if (editingEvent == null) {
      coverImage = null;
    }
  }

  @action
  void editEvent(EventEntity event) {
    editingEvent = event;
    title = event.title;
    description = event.description;
    instagram = event.instagram ?? '';
    place = null;
    address = event.address;
    startDate = event.startDate;
    endDate = event.endDate;
    coverPhoto = null;
    coverImage = event.coverImage;
    musicGenres = ObservableList.of(event.musicGenres);
    attractions = ObservableList.of(event.attractions);
    photos = ObservableList();
    ticket = event.ticket;
  }

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
  void setAddress(AddressEntity value) {
    address = value;
    place = null;
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
    error = null;

    try {
      final currentUser = await _authRepository.getCurrentUser();

      if (currentUser == null) {
        error = 'Faca login para criar um evento.';
        return [];
      }

      final ownerIds = {
        currentUser.id,
        if (currentUser.partnerId != null &&
            currentUser.partnerId!.trim().isNotEmpty)
          currentUser.partnerId!,
      };

      final partnerPlaces = <PlaceEntity>[];

      for (final ownerId in ownerIds) {
        final result = await _placeRepository.getPlacesByOwnerId(ownerId);

        final failed = result.fold(
          (failure) {
            error = failure.message;
            return true;
          },
          (places) {
            partnerPlaces.addAll(places);
            return false;
          },
        );

        if (failed) return [];
      }

      return {
        for (final place in partnerPlaces) place.id: place,
      }.values.toList();
    } catch (e) {
      error = 'Nao foi possivel carregar seus estabelecimentos.';
      return [];
    }
  }

  @action
  Future<bool> save() async {
    if (loading) return false;

    loading = true;
    error = null;

    try {
      final validation = _validate();

      if (validation != null) {
        error = validation;
        return false;
      }

      final processedCover = await _processCoverImage();
      if (processedCover == null) return false;

      coverImage = processedCover;

      await resolveAddressLocation();
      if (error != null) return false;

      final slug = SlugHelper.fromTitle(title);
      final slugValidation = await _validateUniqueSlug(slug);

      if (slugValidation != null) {
        error = slugValidation;
        return false;
      }

      final currentUser = await _authRepository.getCurrentUser();

      if (currentUser == null) {
        error = 'Faca login para criar um evento.';
        return false;
      }

      final event = await _buildEvent(currentUser, slug);
      final editing = editingEvent;
      final result = editing == null
          ? await _eventRepository.createEvent(event)
          : await _eventRepository.updateEvent(event);

      return result.fold((failure) {
        error = failure.message;
        return false;
      }, (_) => true);
    } catch (e) {
      error ??= 'Nao foi possivel criar o evento.';
      return false;
    } finally {
      loading = false;
    }
  }

  Future<String?> _processCoverImage() async {
    final photo = coverPhoto;

    if (photo == null) {
      final currentCover = coverImage;
      if (currentCover != null && currentCover.isNotEmpty) {
        return currentCover;
      }

      error = 'Adicione uma imagem de capa para o evento.';
      return null;
    }

    try {
      return await ImageHelper.fileToBase64(photo);
    } on ImageTooLargeException catch (e) {
      error = e.message;
      return null;
    } catch (_) {
      error = 'Nao foi possivel processar a imagem de capa.';
      return null;
    }
  }

  Future<EventEntity> _buildEvent(
    UserSummaryEntity currentUser,
    String slug,
  ) async {
    final now = DateTime.now();
    final gallery = await _processGalleryImages();
    final editing = editingEvent;
    final selectedPlace = place;
    final selectedAddress = address;

    if (selectedPlace == null && selectedAddress == null) {
      throw Exception('Selecione um local para o evento.');
    }

    return EventEntity(
      id: editing?.id ?? '',
      slug: slug,
      title: title.trim(),
      description: description.trim(),
      placeId: selectedPlace?.id,
      locationName: selectedPlace?.name ?? selectedAddress!.displayName,
      address: selectedPlace?.address ?? selectedAddress!,
      startDate: startDate!,
      endDate: endDate!,
      coverImage: coverImage!,
      gallery: gallery.isEmpty ? editing?.gallery ?? [] : gallery,
      musicGenres: musicGenres.toList(),
      attractions: attractions.toList(),
      ticket: ticket,
      instagram: instagram.trim().isEmpty ? null : instagram.trim(),
      boraCount: editing?.boraCount ?? 0,
      checkinCount: editing?.checkinCount ?? 0,
      views: editing?.views ?? 0,
      shares: editing?.shares ?? 0,
      isBora: editing?.isBora ?? false,
      hasCheckedIn: editing?.hasCheckedIn ?? false,
      createdBy: editing?.createdBy ?? currentUser,
      createdAt: editing?.createdAt ?? now,
      updatedAt: now,
      status: editing?.status ?? EventStatus.published,
    );
  }

  Future<List<String>> _processGalleryImages() async {
    final gallery = <String>[];

    for (final photo in photos) {
      try {
        gallery.add(await ImageHelper.fileToBase64(photo));
      } on ImageTooLargeException catch (e) {
        error = e.message;
        throw Exception(e.message);
      } catch (_) {
        const message = 'Nao foi possivel processar uma imagem da galeria.';
        error = message;
        throw Exception(message);
      }
    }

    return gallery;
  }

  String? _validate() {
    if (title.trim().isEmpty) {
      return 'Informe o nome do evento.';
    }

    if (description.trim().isEmpty) {
      return 'Informe uma descricao.';
    }

    if (coverPhoto == null && coverImage == null) {
      return 'Adicione uma imagem de capa para o evento.';
    }

    if (place == null && address == null) {
      return 'Selecione um local.';
    }

    if (startDate == null) {
      return 'Informe a data de inicio.';
    }

    if (endDate == null) {
      return 'Informe a data de termino.';
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
        return 'Informe um link valido.';
      }
    }

    return null;
  }

  Future<String?> _validateUniqueSlug(String slug) async {
    if (slug.isEmpty) {
      return 'Informe um titulo valido para gerar o link.';
    }

    final result = await _eventRepository.slugExists(
      slug,
      exceptId: editingEvent?.id,
    );

    return result.fold((failure) => failure.message, (exists) {
      if (!exists) return null;

      return 'Ja existe um evento com esse titulo.';
    });
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o nome do evento.';
    }

    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe uma descricao.';
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
      return 'Informe apenas o usuario do Instagram.';
    }

    return null;
  }

  Future<List<AddressEntity>> searchAddress(String query) async {
    try {
      final result = await _locationRepository.searchAddress(query);

      return result.fold((failure) {
        error = failure.message;
        return [];
      }, (addresses) => addresses);
    } catch (_) {
      error = 'Nao foi possivel buscar o endereco.';
      return [];
    }
  }

  Future<void> resolveAddressLocation() async {
    final currentAddress = address;
    final number = currentAddress?.number?.trim();

    if (currentAddress == null || number == null || number.isEmpty) {
      return;
    }

    final result = await _locationRepository.geocodeAddress(currentAddress);

    result.fold(
      (failure) {
        error = failure.message;
      },
      (resolvedAddress) {
        if (resolvedAddress == null) return;

        address = currentAddress.copyWith(
          location: resolvedAddress.location,
          displayName: resolvedAddress.displayName,
        );
      },
    );
  }
}
