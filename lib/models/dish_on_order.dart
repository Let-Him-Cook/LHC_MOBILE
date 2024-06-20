import 'package:let_him_cook/models/dish_model.dart';

class DishOnOrder {
  const DishOnOrder({
    required this.uuid,
    required this.image,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
  });

  final String uuid;
  final String image;
  final String name;
  final double price;
  final String description;
  final int quantity;

  factory DishOnOrder.fromDish(Dish dish) {
    return DishOnOrder(
      uuid: dish.uuid,
      image: dish.image,
      name: dish.name,
      price: dish.price,
      description: dish.description,
      quantity: 1,
    );
  }

  factory DishOnOrder.fromJson(Map<String, dynamic> json) {
    return DishOnOrder(
      uuid: "",
      image: "",
      name: json['name'] as String,
      price: json['price'] as double,
      description: "",
      quantity: json['amount'] as int,
    );
  }
}
