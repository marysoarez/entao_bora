class UserSummaryEntity {
  final String id;
  final String name;
  final String? email;
  final String? photoUrl;
  final bool isAnonymous;

  const UserSummaryEntity({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    this.isAnonymous = false,
  });

  UserSummaryEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    bool? isAnonymous,
  }) {
    return UserSummaryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}