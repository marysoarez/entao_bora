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

  const UserSummaryEntity({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.isAnonymous = false,
    this.role = UserRole.user,
    this.partnerId,
    this.active = true,
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
    );
  }
}