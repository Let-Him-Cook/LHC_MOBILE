class Dish {
  const Dish({
    required this.uuid,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  });

  final String uuid;
  final String image;
  final String name;
  final double price;
  final String description;

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      uuid: json['id'] as String,
      image: json['imageUrl'] as String,
      name: json['name'] as String,
      price: json['price'] as double,
      description: json['description'] as String,
    );
  }
}

List<Dish> dishList = [];
