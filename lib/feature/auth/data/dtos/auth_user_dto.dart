import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSummaryDto extends UserSummaryEntity {
  const UserSummaryDto({
    required super.id,
    required super.name,
    super.email,
    super.photoUrl,
    super.isAnonymous,
  });

  factory UserSummaryDto.fromEntity(UserSummaryEntity entity) {
    return UserSummaryDto(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      photoUrl: entity.photoUrl,
      isAnonymous: entity.isAnonymous,
    );
  }

  factory UserSummaryDto.fromMap(Map<String, dynamic> map) {
    return UserSummaryDto(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String?,
      photoUrl: map['photoUrl'] as String?,
      isAnonymous: map['isAnonymous'] as bool? ?? false,
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
    );
  }

  UserSummaryEntity toEntity() {
    return UserSummaryEntity(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      isAnonymous: isAnonymous,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'isAnonymous': isAnonymous,
    };
  }
}