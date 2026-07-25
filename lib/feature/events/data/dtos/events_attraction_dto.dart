import 'package:entao_bora/feature/events/domain/entities/event_attraction_entit.dart';

class EventAttractionDto {
  final String id;
  final String name;
  final String? instagram;
  final String? image;
  final bool isHeadliner;

  const EventAttractionDto({
    required this.id,
    required this.name,
    this.instagram,
    this.image,
    required this.isHeadliner,
  });

  factory EventAttractionDto.fromMap(
    Map<String, dynamic> map,
  ) {
    return EventAttractionDto(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      instagram: map['instagram'],
      image: map['image'],
      isHeadliner: map['isHeadliner'] ?? false,
    );
  }

  factory EventAttractionDto.fromEntity(
    EventAttractionEntity entity,
  ) {
    return EventAttractionDto(
      id: entity.id,
      name: entity.name,
      instagram: entity.instagram,
      image: entity.image,
      isHeadliner: entity.isHeadliner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'instagram': instagram,
      'image': image,
      'isHeadliner': isHeadliner,
    };
  }

  EventAttractionEntity toEntity() {
    return EventAttractionEntity(
      id: id,
      name: name,
      instagram: instagram,
      image: image,
      isHeadliner: isHeadliner,
    );
  }

  EventAttractionDto copyWith({
    String? id,
    String? name,
    String? instagram,
    String? image,
    bool? isHeadliner,
  }) {
    return EventAttractionDto(
      id: id ?? this.id,
      name: name ?? this.name,
      instagram: instagram ?? this.instagram,
      image: image ?? this.image,
      isHeadliner: isHeadliner ?? this.isHeadliner,
    );
  }
}