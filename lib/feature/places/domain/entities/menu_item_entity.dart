class MenuItemEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String photo;

  const MenuItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.photo,
  });

  MenuItemEntity copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? photo,
  }) {
    return MenuItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      photo: photo ?? this.photo,
    );
  }
}
