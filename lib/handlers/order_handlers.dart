// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/order_model.dart';

const requestUrl = "http://localhost:8080/api/orders";

Future<void> createOrder(Order order, BuildContext context) async {
  try {
    final Map<String, dynamic> orderMap = {
      'idClient': order.clientUuid,
      'totalPrice': order.totalPrice,
      'status': order.state,
      'tableNumber': order.table,
      'observation': "",
    };

    // Encode the Map into JSON format
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
  final url = Uri.parse("http://localhost:8080/api/orders");
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> decodedData = jsonDecode(response.body);
    // Assuming Order can be decoded from JSON
    return decodedData.map((data) => Order.fromJson(data)).toList();
  } else {
    print("Error fetching orders: ${response.statusCode}");
    return []; // Empty list on error
  }
}
