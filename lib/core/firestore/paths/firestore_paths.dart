abstract final class FirestorePaths {
  static const users = 'users';

  static const places = 'places';

  static const events = 'events';

  static const comments = 'comments';

  static const favorites = 'favorites';

  static String event(String id) =>
      '$events/$id';

  static String place(String id) =>
      '$places/$id';

  static String user(String id) =>
      '$users/$id';

  static String presences(
    String eventId,
  ) =>
      'events/$eventId/presences';

  static String presence(
    String eventId,
    String userId,
  ) =>
      'events/$eventId/presences/$userId';

      static String eventBora(
  String eventId,
  String userId,
) =>
    'events/$eventId/boras/$userId';

static String eventCheckin(
  String eventId,
  String userId,
) =>
    'events/$eventId/checkins/$userId';
}