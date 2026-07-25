enum EventStatus {
  draft,
  published,
  cancelled,
  finished,
  hidden;

  String get label {
    switch (this) {
      case EventStatus.draft:
        return 'Rascunho';

      case EventStatus.published:
        return 'Publicado';

      case EventStatus.cancelled:
        return 'Cancelado';

      case EventStatus.finished:
        return 'Finalizado';

      case EventStatus.hidden:
        return 'Oculto';
    }
  }

  String get slug => name;

  static EventStatus fromSlug(String slug) {
    return EventStatus.values.firstWhere(
      (status) => status.name == slug,
      orElse: () => EventStatus.draft,
    );
  }
}