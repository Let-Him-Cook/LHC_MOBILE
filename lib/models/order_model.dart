import 'package:let_him_cook/models/dish_on_order.dart';

class Order {
  const Order({
    required this.uuid,
    required this.clientUuid,
    required this.table,
    required this.totalPrice,
    required this.dishes,
    required this.state,
  });

  final String? uuid;
  final String? clientUuid;
  final int? table;
  final double? totalPrice;
  final List<DishOnOrder>? dishes;
  final String? state;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      uuid: json['uuid'] as String,
      clientUuid: json['clientUuid'] as String,
      table: json['table'] as int?,
      totalPrice: json['totalPrice'] as double?,
      dishes: (json['dishes'] as List<dynamic>?)
          ?.map((dish) => DishOnOrder.fromJson(dish))
          .toList(),
      state: json['state'] as String?,
    );
  }
}
