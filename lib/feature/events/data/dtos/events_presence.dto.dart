// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:entao_bora/feature/events/domain/entities/event_presence_entit.dart';

// class EventPresenceDto {
//   final String eventId;
//   final String userId;
//   final Timestamp createdAt;

//   const EventPresenceDto({
//     required this.eventId,
//     required this.userId,
//     required this.createdAt,
//   });

//   factory EventPresenceDto.fromMap(
//     Map<String, dynamic> map,
//   ) {
//     return EventPresenceDto(
//       eventId: map['eventId'] ?? '',
//       userId: map['userId'] ?? '',
//       createdAt: map['createdAt'] ?? Timestamp.now(),
//     );
//   }

//   factory EventPresenceDto.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final map = doc.data()!;

//     return EventPresenceDto(
//       eventId: map['eventId'] ?? '',
//       userId: map['userId'] ?? doc.id,
//       createdAt: map['createdAt'] ?? Timestamp.now(),
//     );
//   }

//   factory EventPresenceDto.fromEntity(
//     EventPresenceEntity entity,
//   ) {
//     return EventPresenceDto(
//       eventId: entity.eventId,
//       userId: entity.userId,
//       createdAt: Timestamp.fromDate(entity.createdAt),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'eventId': eventId,
//       'userId': userId,
//       'createdAt': createdAt,
//     };
//   }

//   EventPresenceEntity toEntity() {
//     return EventPresenceEntity(
//       eventId: eventId,
//       userId: userId,
//       createdAt: createdAt.toDate(),
//     );
//   }

//   EventPresenceDto copyWith({
//     String? eventId,
//     String? userId,
//     Timestamp? createdAt,
//   }) {
//     return EventPresenceDto(
//       eventId: eventId ?? this.eventId,
//       userId: userId ?? this.userId,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }