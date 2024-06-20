// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/order_model.dart';

const requestUrl = "https://lhcapi.azurewebsites.net/api/orders";

Future<void> createOrder(Order order, BuildContext context) async {
  List orderDishes = [];
  for (var dish in order.dishes!) {
    orderDishes.add({
      "idDish": dish.uuid,
      "name": dish.name,
      "price": dish.price,
    });
  }
  try {
    final Map<String, dynamic> orderMap = {
      "idClient": order.clientUuid,
      "totalPrice": order.totalPrice,
      "status": order.state,
      "tableNumber": order.table,
      "observation": "",
      "orderDishesModelList": orderDishes,
    };

    final String jsonOrder = jsonEncode(orderMap);

    final response = await http.post(
      Uri.parse(requestUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonOrder,
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido feito com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      throw Exception('Error creating order: ${response.statusCode}');
    }
  } catch (error) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao fazer pedido: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<List<Order>> getOrdersByClient(String clientUuid) async {
  final url = Uri.parse("https://lhcapi.azurewebsites.net/api/$clientUuid");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> decodedData = jsonDecode(response.body);

    return decodedData.map((data) => Order.fromJson(data)).toList();
  } else {
    return [];
  }
}


