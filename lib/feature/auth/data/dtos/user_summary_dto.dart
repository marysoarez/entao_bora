import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/shared/enum/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSummaryDto extends UserSummaryEntity {
  const UserSummaryDto({
    required super.id,
    required super.name,
    super.email,
    super.photoUrl,
    super.isAnonymous,
    super.role,
    super.partnerId,
    super.active,
    super.notificationsEnabled,
    super.locationSharingEnabled,
    super.lastKnownLocation,
  });

  factory UserSummaryDto.fromEntity(UserSummaryEntity entity) {
    return UserSummaryDto(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      photoUrl: entity.photoUrl,
      isAnonymous: entity.isAnonymous,
      role: entity.role,
      partnerId: entity.partnerId,
      active: entity.active,
      notificationsEnabled: entity.notificationsEnabled,
      locationSharingEnabled: entity.locationSharingEnabled,
      lastKnownLocation: entity.lastKnownLocation,
    );
  }

  factory UserSummaryDto.fromMap(Map<String, dynamic> map) {
    final lastKnownLocation = map['lastKnownLocation'];

    return UserSummaryDto(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
      role: UserRole.fromSlug(map['role']?.toString()),
      partnerId: map['partnerId'] as String?,
      active: map['active'] as bool? ?? true,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? false,
      locationSharingEnabled: map['locationSharingEnabled'] as bool? ?? false,
      lastKnownLocation: lastKnownLocation is GeoPoint
          ? LocationEntity(
              latitude: lastKnownLocation.latitude,
              longitude: lastKnownLocation.longitude,
            )
          : null,
    );
  }

  factory UserSummaryDto.fromUser(User user) {
    return UserSummaryDto(
      id: user.uid,
      name: (user.displayName?.trim().isNotEmpty ?? false)
          ? user.displayName!.trim()
          : 'Usuário',
      email: user.email,
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,

      // Apenas para novos usuários.
      // Usuários existentes preservam os dados do Firestore.
      role: UserRole.user,
      partnerId: null,
      active: true,
      notificationsEnabled: false,
      locationSharingEnabled: false,
      lastKnownLocation: null,
    );
  }

  UserSummaryEntity toEntity() {
    return UserSummaryEntity(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      isAnonymous: isAnonymous,
      role: role,
      partnerId: partnerId,
      active: active,
      notificationsEnabled: notificationsEnabled,
      locationSharingEnabled: locationSharingEnabled,
      lastKnownLocation: lastKnownLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
      'role': role.slug,
      'partnerId': partnerId,
      'active': active,
      'notificationsEnabled': notificationsEnabled,
      'locationSharingEnabled': locationSharingEnabled,
      if (lastKnownLocation != null)
        'lastKnownLocation': GeoPoint(
          lastKnownLocation!.latitude,
          lastKnownLocation!.longitude,
        ),
    };
  }
}
