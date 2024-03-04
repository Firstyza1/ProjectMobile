import 'package:flutter/material.dart';

class CoffeeTile extends StatelessWidget {
  final String coffeeType;
  final String coffeePrice;
  final String imageName;

  const CoffeeTile({
  required this.coffeeType,
  required this.coffeePrice,
  required this.imageName,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 244, 165, 136)
      ),
    );
  }
}
