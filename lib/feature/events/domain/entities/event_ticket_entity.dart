import 'package:entao_bora/shared/enum/ticket_type_enum.dart';

class EventTicketEntity {
  final TicketType type;

  /// Apenas quando type == external
  final String? ticketUrl;

  const EventTicketEntity({
    required this.type,
    this.ticketUrl,
  });

  bool get isFree => type == TicketType.free;

  bool get hasExternalLink =>
      type == TicketType.external;

  EventTicketEntity copyWith({
    TicketType? type,
    String? ticketUrl,
  }) {
    return EventTicketEntity(
      type: type ?? this.type,
      ticketUrl: ticketUrl ?? this.ticketUrl,
    );
  }
}