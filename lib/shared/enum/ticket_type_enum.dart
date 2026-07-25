enum TicketType {
  free,
  external;

  String get label {
    switch (this) {
      case TicketType.free:
        return 'Gratuito';

      case TicketType.external:
        return 'Venda externa';
    }
  }

  String get slug => name;

  static TicketType fromSlug(String slug) {
    return TicketType.values.firstWhere(
      (e) => e.name == slug,
      orElse: () => TicketType.free,
    );
  }
}