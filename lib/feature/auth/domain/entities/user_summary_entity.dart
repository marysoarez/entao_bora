import 'package:entao_bora/core/location/domain/entities/location_entity.dart';
import 'package:entao_bora/shared/enum/user_role.dart';

class UserSummaryEntity {
  final String id;

  final String name;
  final String? email;
  final String? photoUrl;

  final bool isAnonymous;

  final UserRole role;

  /// Id do parceiro caso este usuário seja um parceiro.
  final String? partnerId;

  /// Permite bloquear um usuário sem excluir sua conta.
  final bool active;
  final bool notificationsEnabled;
  final bool locationSharingEnabled;
  final LocationEntity? lastKnownLocation;

  const UserSummaryEntity({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.isAnonymous = false,
    this.role = UserRole.user,
    this.partnerId,
    this.active = true,
    this.notificationsEnabled = false,
    this.locationSharingEnabled = false,
    this.lastKnownLocation,
  });

  bool get isPartner => role == UserRole.partner;

  bool get isAdmin => role == UserRole.admin;

  UserSummaryEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    bool? isAnonymous,
    UserRole? role,
    String? partnerId,
    bool? active,
    bool? notificationsEnabled,
    bool? locationSharingEnabled,
    LocationEntity? lastKnownLocation,
  }) {
    return UserSummaryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      role: role ?? this.role,
      partnerId: partnerId ?? this.partnerId,
      active: active ?? this.active,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationSharingEnabled:
          locationSharingEnabled ?? this.locationSharingEnabled,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
    );
  }
}
