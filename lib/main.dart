import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:milktea/login.dart';
import 'package:milktea/menupage.dart';
import 'package:milktea/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        color: Color.fromARGB(255, 1, 37, 66), // เปลี่ยนสีพื้นหลังเป็นสีน้ำเงิน

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 1,
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/SAAA.png'),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontFamily: "DMSerif",
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Color.fromARGB(255, 0, 0, 0))),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    color: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          fontFamily: "DMSerif",
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          color: Color.fromARGB(255, 26, 26, 26)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
