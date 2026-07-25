enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get label {
    switch (this) {
      case Weekday.monday:
        return 'Segunda';

      case Weekday.tuesday:
        return 'Terça';

      case Weekday.wednesday:
        return 'Quarta';

      case Weekday.thursday:
        return 'Quinta';

      case Weekday.friday:
        return 'Sexta';

      case Weekday.saturday:
        return 'Sábado';

      case Weekday.sunday:
        return 'Domingo';
    }
  }

  String get shortLabel {
    switch (this) {
      case Weekday.monday:
        return 'Seg';

      case Weekday.tuesday:
        return 'Ter';

      case Weekday.wednesday:
        return 'Qua';

      case Weekday.thursday:
        return 'Qui';

      case Weekday.friday:
        return 'Sex';

      case Weekday.saturday:
        return 'Sáb';

      case Weekday.sunday:
        return 'Dom';
    }
  }

  String get slug => name;

  static Weekday fromSlug(String slug) {
    return Weekday.values.firstWhere(
      (e) => e.name == slug,
      orElse: () => Weekday.monday,
    );
  }
}