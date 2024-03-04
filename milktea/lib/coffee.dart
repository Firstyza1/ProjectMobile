import 'package:flutter/material.dart';
import 'package:milktea/coffeetile.dart';

class Coffee extends StatelessWidget {
  List coffeeDetails = [
    ["Black Coffee", "40", "icons/blackcoffee.png"],
    ["B", "45", "icons/blackcoffee.png"],
    ["Bla", "47", "icons/blackcoffee.png"],
    ["Black", "48", "icons/blackcoffee.png"]
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: coffeeDetails.length,
        itemBuilder: (context, index) {
          return CoffeeTile(
            coffeeType: coffeeDetails[index][0],
            coffeePrice: coffeeDetails[index][1],
            imageName: coffeeDetails[index][2],
          );
        });
  }
}
