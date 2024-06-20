import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:let_him_cook/constants.dart';
import 'package:let_him_cook/handlers/user_handlers.dart';
import 'package:let_him_cook/models/user_model.dart';
import 'package:let_him_cook/screens/initial_screen/widgets/cpf_form.dart';
import 'package:let_him_cook/screens/initial_screen/widgets/name_form.dart';
import 'package:let_him_cook/screens/order_screen/order_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({
    super.key,
  });

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool isLoading = false;
  bool showNameForm = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  Future<void> login(String cpf) async {
    setState(() {
      isLoading = true;
    });

    User? user = await clientLogin(cpf);

    if (user == null) {
      setState(() {
        isLoading = false;
        showNameForm = !showNameForm;
      });
    } else {
      isLoading = false;

      userInfo = user;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderScreen(),
        ),
      );
    }
  }

  Future<void> registerUser(String cpf, String name) async {
    setState(() {
      isLoading = true;
    });

    await createUser(name, cpf, context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: background),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: showNameForm
                    ? NameForm(
                        cpf: cpfController.text,
                        isLoading: isLoading,
                        nameController: nameController,
                        registerUser: registerUser,
                      )
                    : CpfForm(
                        isLoading: isLoading,
                        cpfController: cpfController,
                        loginFunc: login,
                      ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: primaryColor),
              child: Center(
                child: Image.asset("assets/images/logo.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
