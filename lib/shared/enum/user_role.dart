enum UserRole {
  user,
  partner,
  admin;

  String get slug => name;

  static UserRole fromSlug(String? slug) {
    return UserRole.values.firstWhere(
      (e) => e.slug == slug,
      orElse: () => UserRole.user,
    );
  }
}