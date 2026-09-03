class PublicUrlHelper {
  const PublicUrlHelper._();

  static const baseUrl = 'https://entaobora.com.br';

  static String placePath({required String slug, required String id}) {
    return '/place/${_slugOrId(slug: slug, id: id)}';
  }

  static String eventPath({required String slug, required String id}) {
    return '/events/${_slugOrId(slug: slug, id: id)}';
  }

  static String placeUrl({required String slug, required String id}) {
    return '$baseUrl${placePath(slug: slug, id: id)}';
  }

  static String eventUrl({required String slug, required String id}) {
    return '$baseUrl${eventPath(slug: slug, id: id)}';
  }

  static String _slugOrId({required String slug, required String id}) {
    return slug.trim().isNotEmpty ? slug : id;
  }
}
