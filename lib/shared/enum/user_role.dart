enum UserRole {
  user,
  partner,
  admin;

  String get slug => name;

  bool get isUser => this == UserRole.user;

  bool get isPartner => this == UserRole.partner;

  bool get isAdmin => this == UserRole.admin;

  static UserRole fromSlug(String? slug) {
    return UserRole.values.firstWhere(
      (e) => e.slug == slug,
      orElse: () => UserRole.user,
    );
  }
}