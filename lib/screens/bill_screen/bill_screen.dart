import 'package:flutter/material.dart';
import 'package:let_him_cook/constants.dart';
import 'package:let_him_cook/handlers/order_handlers.dart';
import 'package:let_him_cook/models/order_model.dart';
import 'package:let_him_cook/models/user_model.dart';
import 'package:let_him_cook/screens/bill_screen/bill_closed.dart';
import 'package:let_him_cook/screens/bill_screen/widgets/order_card.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({
    super.key,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  double totalBillValue = 0;
  List<Order> orders = [];
  bool isLoading = false;
  bool isClosing = false;

  @override
  void initState() {
    getUserOrders();
    super.initState();
  }

  getUserOrders() async {
    setState(() {
      isLoading = true;
    });

    List<Order> requestedOrders = await getOrdersByClient(userInfo!.uuid);
    print(requestedOrders);

    double totalValue = 0;

    if (requestedOrders.isNotEmpty) {
      for (var i in requestedOrders) {
        totalValue += i.totalPrice!;
      }
    }

    setState(() {
      isLoading = false;
      orders = requestedOrders;
      totalBillValue = totalValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    Route createFadeRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final fadeAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      );
    }

    void confirmCloseBill(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 600,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tem certeza que deseja fechar a conta?",
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(onBackground),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        child: const Text(
                          "CANCELAR",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isClosing = true;
                          });
                          List<String> orderIds = [];

                          for (var i in orders) {
                            orderIds.add(i.uuid!);
                          }

                          await closeOrders(orderIds, context);

                          setState(() {
                            isClosing = false;
                          });

                          Navigator.of(context).pop();

                          Navigator.of(context).pushReplacement(
                            createFadeRoute(
                              BillClosedScreen(
                                totalBillValue: totalBillValue,
                                userOrders: orders,
                              ),
                            ),
                          );
                        },
                        style: const ButtonStyle(
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                          ),
                          backgroundColor: WidgetStatePropertyAll(onBackground),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        child: isClosing
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "FECHAR CONTA",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: primaryColor,
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          width: 700,
          child: Column(
            children: [
              const Text(
                "CONTA",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 2,
                color: secondaryColor,
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: secondaryColor,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return BillOrderCard(
                            order: orders[index],
                          );
                        },
                      ),
              ),
              const Divider(
                thickness: 2,
                color: secondaryColor,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Total: R\$ ${totalBillValue.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        confirmCloseBill(context);
                      },
                      style: const ButtonStyle(
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(onBackground),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      child: const Text(
                        "FECHAR CONTA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
