import 'package:entao_bora/core/location/domain/entities/adress_entit.dart';
import 'package:entao_bora/feature/events/domain/entities/event_attraction_entit.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/feature/events/domain/entities/event_ticket_entity.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';

class EventEntity {
  final String id;

  /// Informações básicas
  final String title;
  final String description;

  /// Local
  final String? placeId;
  final String locationName;
  final AddressEntity address;

  /// Datas
  final DateTime startDate;
  final DateTime endDate;

  /// Imagens
  final String coverImage;
  final List<String> gallery;

  /// Música
  final List<MusicGenre> musicGenres;

  /// Bandas / DJs / atrações
  final List<EventAttractionEntity> attractions;

  /// Ingresso
  final EventTicketEntity ticket;

  /// Instagram
  final String? instagram;

  /// Estatísticas
  final int boraCount;
  final int checkinCount;
  final int views;
  final int shares;

  /// Estado do usuário
  final bool isBora;
  final bool hasCheckedIn;

  /// Auditoria
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  final EventStatus status;

  const EventEntity({
    required this.id,
    required this.title,
    required this.description,
    this.placeId,
    required this.locationName,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.coverImage,
    required this.gallery,
    required this.musicGenres,
    required this.attractions,
    required this.ticket,
    this.instagram,
    required this.boraCount,
    required this.checkinCount,
    required this.views,
    required this.shares,
    this.isBora = false,
    this.hasCheckedIn = false,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  bool get isFinished => endDate.isBefore(DateTime.now());

  bool get isRunning {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isUpcoming => DateTime.now().isBefore(startDate);

  EventEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? placeId,
    String? locationName,
    AddressEntity? address,
    DateTime? startDate,
    DateTime? endDate,
    String? coverImage,
    List<String>? gallery,
    List<MusicGenre>? musicGenres,
    List<EventAttractionEntity>? attractions,
    EventTicketEntity? ticket,
    String? instagram,
    int? boraCount,
    int? checkinCount,
    int? views,
    int? shares,
    bool? isBora,
    bool? hasCheckedIn,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    EventStatus? status,
  }) {
    return EventEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      placeId: placeId ?? this.placeId,
      locationName: locationName ?? this.locationName,
      address: address ?? this.address,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coverImage: coverImage ?? this.coverImage,
      gallery: gallery ?? this.gallery,
      musicGenres: musicGenres ?? this.musicGenres,
      attractions: attractions ?? this.attractions,
      ticket: ticket ?? this.ticket,
      instagram: instagram ?? this.instagram,
      boraCount: boraCount ?? this.boraCount,
      checkinCount: checkinCount ?? this.checkinCount,
      views: views ?? this.views,
      shares: shares ?? this.shares,
      isBora: isBora ?? this.isBora,
      hasCheckedIn: hasCheckedIn ?? this.hasCheckedIn,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}