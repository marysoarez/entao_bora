import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';

class EventBoraEntity {
  final String id;

  /// Evento
  final String eventId;

  /// Usuário
  final UserSummaryEntity user;

  /// Data em que marcou "Então Bora"
  final DateTime createdAt;

  const EventBoraEntity({
    required this.id,
    required this.eventId,
    required this.user,
    required this.createdAt,
  });

  EventBoraEntity copyWith({
    String? id,
    String? eventId,
    UserSummaryEntity? user,
    DateTime? createdAt,
  }) {
    return EventBoraEntity(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}