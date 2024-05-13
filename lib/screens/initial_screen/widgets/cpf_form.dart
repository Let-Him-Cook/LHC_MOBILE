import 'package:flutter/material.dart';
import 'package:let_him_cook/constants.dart';

class CpfForm extends StatelessWidget {
  const CpfForm({
    super.key,
    required this.cpfController,
    required this.onToggle,
  });

  final TextEditingController cpfController;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Insira seu CPF",
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
            style: const TextStyle(fontSize: 40, color: secondaryColor),
            enabled: true,
            controller: cpfController,
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
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            height: 130,
            child: ElevatedButton(
              onPressed: onToggle,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(onBackground),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              child: const Text(
                "ENTRAR",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
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