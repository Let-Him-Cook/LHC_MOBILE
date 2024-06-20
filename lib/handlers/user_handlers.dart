import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:let_him_cook/models/user_model.dart';

const requestUrl = "http://localhost:8080/api/clients";
const requestLoginUrl = "http://localhost:8080/api/clients/login";

Future<User?> clientLogin(String cpf) async {
  final Map<String, dynamic> loginMap = {
    "cpf": cpf,
  };

  final String jsonLogin = jsonEncode(loginMap);

  final response = await http.post(
    Uri.parse(requestLoginUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonLogin,
  );

  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);
    return User.fromJson(decodedData);
  } else {
    return null;
  }
}

void createUser(String name, String cpf, BuildContext context) async {
  try {
    final Map<String, dynamic> userMap = {
      "name": name,
      "cpf": cpf,
    };

    final String jsonUser = jsonEncode(userMap);

    final response = await http.post(
      Uri.parse(requestUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonUser,
    );

    if (response.statusCode == 200) {
      await clientLogin(cpf);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer o registro'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Erro ao fazer o registro: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
