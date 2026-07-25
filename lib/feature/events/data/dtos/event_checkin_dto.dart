import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/feature/auth/data/dtos/auth_user_dto.dart';
import 'package:entao_bora/feature/events/domain/entities/event_checkin_entity.dart';

class EventCheckinDto extends EventCheckinEntity {
  const EventCheckinDto({
    required super.id,
    required super.eventId,
    required super.user,
    required super.checkedInAt,
    required super.latitude,
    required super.longitude,
  });

  factory EventCheckinDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data()!;

    return EventCheckinDto(
      id: doc.id,
      eventId: map['eventId'] ?? '',
      user: UserSummaryDto.fromMap(
        Map<String, dynamic>.from(map['user']),
      ),
      checkedInAt: (map['checkedInAt'] as Timestamp).toDate(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  factory EventCheckinDto.fromEntity(EventCheckinEntity entity) {
    return EventCheckinDto(
      id: entity.id,
      eventId: entity.eventId,
      user: entity.user,
      checkedInAt: entity.checkedInAt,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'user': UserSummaryDto.fromEntity(user).toMap(),
      'checkedInAt': Timestamp.fromDate(checkedInAt),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}