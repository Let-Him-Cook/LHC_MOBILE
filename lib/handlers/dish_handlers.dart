import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/dish_model.dart';

const requestUrl = "https://lhcapi.azurewebsites.net/api/dishes";

Future<List<Dish>> getAllDishes() async {
  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    final dishes = data.map((dish) => Dish.fromJson(dish)).toList();
    return dishes;
  } else {
    return [];
  }
}
