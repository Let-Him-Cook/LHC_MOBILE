import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/dish_model.dart';

const requestUrl = "http://localhost:8080/api/dishes";

Future<void> getAllDishes() async {
  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List<dynamic>;
    final dishes = data.map((dish) => Dish.fromJson(dish)).toList();
    dishList = dishes;
  } else {
    print('Erro na requisição: ${response.statusCode}');
  }
}
