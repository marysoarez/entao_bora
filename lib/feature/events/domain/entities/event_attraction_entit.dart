class EventAttractionEntity {
  /// Pode ser vazio por enquanto
  final String id;

  final String name;

  /// username do Instagram
  final String? instagram;

  final String? image;

  final bool isHeadliner;

  const EventAttractionEntity({
    this.id = '',
    required this.name,
    this.instagram,
    this.image,
    this.isHeadliner = false,
  });

  EventAttractionEntity copyWith({
    String? id,
    String? name,
    String? instagram,
    String? image,
    bool? isHeadliner,
  }) {
    return EventAttractionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      instagram: instagram ?? this.instagram,
      image: image ?? this.image,
      isHeadliner: isHeadliner ?? this.isHeadliner,
    );
  }
}