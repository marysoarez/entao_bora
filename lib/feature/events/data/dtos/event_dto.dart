import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/feature/events/data/dtos/events_attraction_dto.dart';
import 'package:entao_bora/feature/events/data/dtos/events_ticket_dto.dart';
import 'package:entao_bora/feature/events/domain/entities/event_entity.dart';
import 'package:entao_bora/feature/events/domain/entities/event_status_enum.dart';
import 'package:entao_bora/shared/enum/music_genre.dart';

class EventDto {
  final String id;

  final String title;
  final String description;

  final String placeId;
  final String placeName;

  final Timestamp startDate;
  final Timestamp endDate;

  final String coverImage;
  final List<String> gallery;

  final List<String> musicGenres;

  final List<EventAttractionDto> attractions;

  final EventTicketDto ticket;

  final String? instagram;

  /// Estatísticas
  final int boraCount;
  final int checkinCount;
  final int views;
  final int shares;

  /// Auditoria
  final String createdBy;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  final String status;

  const EventDto({
    required this.id,
    required this.title,
    required this.description,
    required this.placeId,
    required this.placeName,
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
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory EventDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return EventDto.fromMap(doc.id, doc.data()!);
  }

  factory EventDto.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return EventDto(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      placeId: map['placeId'] ?? '',
      placeName: map['placeName'] ?? '',
      startDate: map['startDate'] ?? Timestamp.now(),
      endDate: map['endDate'] ?? Timestamp.now(),
      coverImage: map['coverImage'] ?? '',
      gallery: List<String>.from(map['gallery'] ?? []),
      musicGenres: List<String>.from(map['musicGenres'] ?? []),
      attractions: (map['attractions'] as List? ?? [])
          .map(
            (e) => EventAttractionDto.fromMap(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      ticket: EventTicketDto.fromMap(
        Map<String, dynamic>.from(map['ticket'] ?? {}),
      ),
      instagram: map['instagram'],
      boraCount: map['boraCount'] ?? 0,
      checkinCount: map['checkinCount'] ?? 0,
      views: map['views'] ?? 0,
      shares: map['shares'] ?? 0,
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
      status: map['status'] ?? EventStatus.draft.slug,
    );
  }

  factory EventDto.fromEntity(EventEntity entity) {
    return EventDto(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      placeId: entity.placeId,
      placeName: entity.placeName,
      startDate: Timestamp.fromDate(entity.startDate),
      endDate: Timestamp.fromDate(entity.endDate),
      coverImage: entity.coverImage,
      gallery: entity.gallery,
      musicGenres: entity.musicGenres
          .map((e) => e.slug)
          .toList(),
      attractions: entity.attractions
          .map(EventAttractionDto.fromEntity)
          .toList(),
      ticket: EventTicketDto.fromEntity(entity.ticket),
      instagram: entity.instagram,
      boraCount: entity.boraCount,
      checkinCount: entity.checkinCount,
      views: entity.views,
      shares: entity.shares,
      createdBy: entity.createdBy,
      createdAt: Timestamp.fromDate(entity.createdAt),
      updatedAt: Timestamp.fromDate(entity.updatedAt),
      status: entity.status.slug,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'placeId': placeId,
      'placeName': placeName,
      'startDate': startDate,
      'endDate': endDate,
      'coverImage': coverImage,
      'gallery': gallery,
      'musicGenres': musicGenres,
      'attractions': attractions
          .map((e) => e.toMap())
          .toList(),
      'ticket': ticket.toMap(),
      'instagram': instagram,
      'boraCount': boraCount,
      'checkinCount': checkinCount,
      'views': views,
      'shares': shares,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  EventEntity toEntity({
    bool isBora = false,
    bool hasCheckedIn = false,
  }) {
    return EventEntity(
      id: id,
      title: title,
      description: description,
      placeId: placeId,
      placeName: placeName,
      startDate: startDate.toDate(),
      endDate: endDate.toDate(),
      coverImage: coverImage,
      gallery: gallery,
      musicGenres: musicGenres
          .map(MusicGenre.fromSlug)
          .toList(),
      attractions: attractions
          .map((e) => e.toEntity())
          .toList(),
      ticket: ticket.toEntity(),
      instagram: instagram,
      boraCount: boraCount,
      checkinCount: checkinCount,
      views: views,
      shares: shares,
      isBora: isBora,
      hasCheckedIn: hasCheckedIn,
      createdBy: createdBy,
      createdAt: createdAt.toDate(),
      updatedAt: updatedAt.toDate(),
      status: EventStatus.fromSlug(status),
    );
  }

  EventDto copyWith({
    String? id,
    String? title,
    String? description,
    String? placeId,
    String? placeName,
    Timestamp? startDate,
    Timestamp? endDate,
    String? coverImage,
    List<String>? gallery,
    List<String>? musicGenres,
    List<EventAttractionDto>? attractions,
    EventTicketDto? ticket,
    String? instagram,
    int? boraCount,
    int? checkinCount,
    int? views,
    int? shares,
    String? createdBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    String? status,
  }) {
    return EventDto(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
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
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}