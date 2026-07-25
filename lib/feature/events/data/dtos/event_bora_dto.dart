import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/feature/auth/data/dtos/auth_user_dto.dart';
import 'package:entao_bora/feature/events/domain/entities/event_bora_entity.dart';

class EventBoraDto extends EventBoraEntity {
  const EventBoraDto({
    required super.id,
    required super.eventId,
    required super.user,
    required super.createdAt,
  });

  factory EventBoraDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data()!;

    return EventBoraDto(
      id: doc.id,
      eventId: map['eventId'] ?? '',
      user: UserSummaryDto.fromMap(
        Map<String, dynamic>.from(map['user']),
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  factory EventBoraDto.fromEntity(EventBoraEntity entity) {
    return EventBoraDto(
      id: entity.id,
      eventId: entity.eventId,
      user: entity.user,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'user': UserSummaryDto.fromEntity(user).toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}