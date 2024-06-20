import 'package:flutter/material.dart';
import 'package:let_him_cook/constants.dart';

class NameForm extends StatelessWidget {
  const NameForm({
    super.key,
    required this.isLoading,
    required this.nameController,
    required this.registerUser,
    required this.cpf,
  });

  final String cpf;
  final bool isLoading;
  final TextEditingController nameController;
  final Function(String, String) registerUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Parece que você é um novo cliente!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color(0xFF6A6A6A),
            ),
          ),
          const Text(
            "Insira seu nome",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            style: const TextStyle(fontSize: 30, color: secondaryColor),
            enabled: true,
            controller: nameController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              fillColor: secondarybackground,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          SizedBox(
            width: double.infinity,
            height: 130,
            child: ElevatedButton(
              onPressed: () {
                registerUser(
                  cpf,
                  nameController.text,
                );
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(onBackground),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "REGISTRAR-SE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
