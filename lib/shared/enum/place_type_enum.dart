enum PlaceType {
  bar,
  pub,
  restaurant,
  brewery,
  concertHall,
  club,
  festival,
  square,
  other;

  String get label {
    switch (this) {
      case PlaceType.bar:
        return 'Bar';

      case PlaceType.pub:
        return 'Pub';

      case PlaceType.restaurant:
        return 'Restaurante';

      case PlaceType.brewery:
        return 'Cervejaria';

      case PlaceType.concertHall:
        return 'Casa de Shows';

      case PlaceType.club:
        return 'Clube';

      case PlaceType.festival:
        return 'Festival';

      case PlaceType.square:
        return 'Praça';

      case PlaceType.other:
        return 'Outro';
    }
  }

  String get slug => name;

  static PlaceType fromSlug(String slug) {
    return PlaceType.values.firstWhere(
      (e) => e.name == slug,
      orElse: () => PlaceType.other,
    );
  }
}