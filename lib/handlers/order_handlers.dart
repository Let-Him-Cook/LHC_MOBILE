// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/order_model.dart';

const requestUrl = "http://localhost:8080/api/orders";

Future<void> createOrder(Order order, BuildContext context) async {
  List orderDishes = [];
  for (var dish in order.dishes!) {
    orderDishes.add({
      "idDish": dish.uuid,
      "amount": dish.quantity,
    });
  }
  try {
    final Map<String, dynamic> orderMap = {
      "idClient": order.clientUuid,
      "totalPrice": order.totalPrice,
      "status": order.state,
      "tableNumber": 1,
      "orderDishes": orderDishes,
    };

    final String jsonOrder = jsonEncode(orderMap);

    final response = await http.post(
      Uri.parse(requestUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonOrder,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
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
  final url = Uri.parse("http://localhost:8080/api/orders/$clientUuid");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final decodedData =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    return decodedData.map((data) => Order.fromJson(data)).toList();
  } else {
    return [];
  }
}

Future<void> closeOrders(List<String> orderIds, BuildContext context) async {
  try {
    final String jsonOrderIds = jsonEncode(orderIds);

    final response = await http.post(
      Uri.parse("$requestUrl/close-orders"),
      headers: {"Content-Type": "application/json"},
      body: jsonOrderIds,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedidos fechados com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      throw Exception('Error closing orders: ${response.statusCode}');
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao fechar pedidos: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
