import 'package:flutter/material.dart';
import 'package:milktea/mytab.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Widget> myTabs = [
  MyTab(iconPath: 'img/logo.png'),
  MyTab(iconPath: 'img/logo.png'),
  MyTab(iconPath: 'img/logo.png'),
  MyTab(iconPath: 'img/logo.png'),
];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 238, 238),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
              Icons.menu,
              color: Colors.black,
              size: 36,
            ),
          ),
          title: Text(
            "Milk Tea Cafe",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.person,
                color: Colors.black,
                size: 36,
              ),
            ),
          ],
        ),
        body: Column(
          children:  [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
              child: Row(
                children: [
                  Text(
                    "I want to ",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "DRINK ",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TabBar(tabs: myTabs)
          ],
        ),
        
      ),
    );
  }
}
