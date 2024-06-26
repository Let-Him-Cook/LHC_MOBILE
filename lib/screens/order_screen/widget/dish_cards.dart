import 'package:flutter/material.dart';
import 'package:let_him_cook/constants.dart';
import 'package:let_him_cook/models/dish_model.dart';

class DishCard extends StatelessWidget {
  const DishCard({super.key, required this.dish, required this.openDishModal});

  final Dish dish;
  final VoidCallback openDishModal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openDishModal,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  dish.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200, // Adjust height as needed
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: onBackground,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.all(8),
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      dish.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: background,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${dish.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: background,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
