import 'package:let_him_cook/models/dish_model.dart';

class Order {
  const Order({
    required this.uuid,
    required this.clientUuid,
    required this.table,
    required this.totalPrice,
    required this.dishes,
  });

  final String uuid;
  final String clientUuid;
  final int table;
  final double totalPrice;
  final List<Dish> dishes;
}