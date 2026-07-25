import 'package:entao_bora/shared/enum/ticket_type_enum.dart';

import '../../domain/entities/event_ticket_entity.dart';

class EventTicketDto {
  final String type;
  final String? ticketUrl;

  const EventTicketDto({
    required this.type,
    this.ticketUrl,
  });

  factory EventTicketDto.fromMap(
    Map<String, dynamic> map,
  ) {
    return EventTicketDto(
      type: map['type'] ?? TicketType.free.slug,
      ticketUrl: map['ticketUrl'],
    );
  }

  factory EventTicketDto.fromEntity(
    EventTicketEntity entity,
  ) {
    return EventTicketDto(
      type: entity.type.slug,
      ticketUrl: entity.ticketUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'ticketUrl': ticketUrl,
    };
  }

  EventTicketEntity toEntity() {
    return EventTicketEntity(
      type: TicketType.fromSlug(type),
      ticketUrl: ticketUrl,
    );
  }

  EventTicketDto copyWith({
    String? type,
    String? ticketUrl,
  }) {
    return EventTicketDto(
      type: type ?? this.type,
      ticketUrl: ticketUrl ?? this.ticketUrl,
    );
  }
}