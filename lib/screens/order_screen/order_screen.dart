import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:let_him_cook/constants.dart';
import 'package:let_him_cook/handlers/dish_handlers.dart';
import 'package:let_him_cook/handlers/order_handlers.dart';
import 'package:let_him_cook/models/dish_model.dart';
import 'package:let_him_cook/models/dish_on_order.dart';
import 'package:let_him_cook/models/order_model.dart';
import 'package:let_him_cook/models/user_model.dart';
import 'package:let_him_cook/screens/bill_screen/bill_screen.dart';
import 'package:let_him_cook/screens/order_screen/widget/dish_cards.dart';
import 'package:let_him_cook/screens/order_screen/widget/dish_modal.dart';
import 'package:badges/badges.dart' as badges;
import 'package:let_him_cook/screens/order_screen/widget/order_modal.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    super.key,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<DishOnOrder> orderedDishes = [];
  List<Dish> dishes = [];
  String category = "Lanche";
  bool isLoading = true;

  @override
  void initState() {
    isLoading = true;
    prepareDishesOnScreen();
    super.initState();
  }

  void prepareDishesOnScreen() async {
    var getDishes = await getAllDishes();
    setState(() {
      dishes = getDishes;
      isLoading = false;
    });
  }

  void createOrderAndAddToBill(List<DishOnOrder> orderedDishes) async {
    double totalPrice = orderedDishes.fold(0,
        (previousValue, dish) => previousValue + (dish.quantity * dish.price));

    Order order = Order(
      uuid: null,
      clientUuid: userInfo!.uuid,
      table: 1,
      totalPrice: totalPrice,
      dishes: orderedDishes,
      state: "PENDENTE",
    );

    await createOrder(order, context);

    setState(() {
      orderedDishes = [];
    });
  }

  void addToOrderedDishes(Dish dish) {
    bool found = false;
    for (int i = 0; i < orderedDishes.length; i++) {
      if (orderedDishes[i].uuid == dish.uuid) {
        setState(() {
          found = true;
          orderedDishes[i] = DishOnOrder(
            uuid: dish.uuid,
            image: dish.image,
            name: dish.name,
            price: dish.price,
            description: dish.description,
            quantity: orderedDishes[i].quantity + 1,
          );
        });
        Navigator.pop(context);
        break;
      }
    }
    if (!found) {
      setState(() {
        orderedDishes.add(
          DishOnOrder(
            uuid: dish.uuid,
            image: dish.image,
            name: dish.name,
            price: dish.price,
            description: dish.description,
            quantity: 1, // Initial quantity is 1
          ),
        );
        Navigator.pop(context);
      });
    }
  }

  addDishDialog(Dish dish) {
    showDialog(
        barrierDismissible: true,
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: DishModal(
              dish: dish,
              addDish: addToOrderedDishes,
            ),
          );
        });
  }

  orderDialog() {
    showDialog(
        barrierDismissible: true,
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: OrderModal(
              orderedDishes: orderedDishes,
              addOrderToBill: () {
                createOrderAndAddToBill(orderedDishes);
                setState(() {
                  orderedDishes = [];
                });
              },
            ),
          );
        });
  }

  changeCategory(String newCategory) {
    if (category == newCategory) {
      return;
    } else {
      setState(() {
        category = newCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 150),
        child: Container(
          color: primaryColor,
          height: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 210,
                width: 210,
                child: Image.asset(
                  "assets/images/Illustration.png",
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text("Let Him Cook",
                        style: GoogleFonts.dosis(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 80,
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Container(
              color: secondarybackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: const Column(
                      children: [],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BillScreen(),
                      ));
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: secondaryColor,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 70,
                          ),
                          Text(
                            "PEDIDOS",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(
                    bottom: 40,
                    left: 32,
                    right: 32,
                    top: 16,
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: onBackground,
                          ),
                        )
                      : GridView.builder(
                          itemCount: dishes.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemBuilder: (context, index) {
                            var filteredDishes = dishes.toList();
                            var dish = filteredDishes[index];
                            return DishCard(
                              dish: dish,
                              openDishModal: () {
                                addDishDialog(
                                  dish,
                                );
                              },
                            );
                          },
                        ),
                ),
                Positioned(
                  bottom: 12,
                  right: 32,
                  child: Stack(
                    children: [
                      badges.Badge(
                        badgeStyle: const badges.BadgeStyle(
                            badgeColor: primaryColor,
                            padding: EdgeInsets.all(8)),
                        badgeContent: Text(
                          orderedDishes.length.toString(),
                          style: const TextStyle(
                            color: secondaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: SizedBox(
                          width: 175,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              orderDialog();
                            },
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(onBackground),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            child: const Text(
                              "FAZER PEDIDO",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
