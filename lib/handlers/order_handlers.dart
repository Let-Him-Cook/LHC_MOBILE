import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/order_model.dart';

const requestUrl = "http://localhost:8080/api/orders";

Future<void> createOrder(Order order) async {
  final String jsonOrder = jsonEncode(order);

  final response = await http.post(
    Uri.parse(requestUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonOrder,
  );

  if (response.statusCode == 200) {
    print("Order created successfully!");
  } else {
    print("Error creating order: ${response.statusCode}");
  }
}
