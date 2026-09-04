enum UserRole {
  user,
  partner,
  admin;

  String get slug => name;

  bool get isUser => this == UserRole.user;

  bool get isPartner => this == UserRole.partner;

  bool get isAdmin => this == UserRole.admin;

  static UserRole fromSlug(String? slug) {
    final normalizedSlug = slug?.trim().toLowerCase();

    return UserRole.values.firstWhere(
      (e) => e.slug == normalizedSlug,
      orElse: () => UserRole.user,
    );
  }
}
