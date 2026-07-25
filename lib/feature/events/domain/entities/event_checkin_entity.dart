import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';

class EventCheckinEntity {
  final String id;

  /// Evento
  final String eventId;

  /// Usuário
  final UserSummaryEntity user;

  /// Data e hora do check-in
  final DateTime checkedInAt;

  /// Localização do check-in
  final double latitude;
  final double longitude;

  const EventCheckinEntity({
    required this.id,
    required this.eventId,
    required this.user,
    required this.checkedInAt,
    required this.latitude,
    required this.longitude,
  });

  EventCheckinEntity copyWith({
    String? id,
    String? eventId,
    UserSummaryEntity? user,
    DateTime? checkedInAt,
    double? latitude,
    double? longitude,
  }) {
    return EventCheckinEntity(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      user: user ?? this.user,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}