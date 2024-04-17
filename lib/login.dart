import 'package:flutter/material.dart';
import 'package:milktea/forgotpassword.dart';
import 'package:milktea/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:milktea/menupage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void userLogin() async {
      showDialog(
          context: context,
          builder: (builder) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((_) {
          // เนื่องจากล็อกอินสำเร็จเท่านั้น จึงทำการนำทางไปยังหน้าโปรไฟล์
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuPage(
                      screenIndex1: 0,
                    )),
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('ไม่พบผู้ใช้สำหรับอีเมลนี้');
        } else if (e.code == 'wrong-password') {
          print('รหัสผ่านไม่ถูกต้องสำหรับผู้ใช้นี้');
        }
        // ปิดกล่องโหลดเมื่อการล็อกอินล้มเหลว
        Navigator.pop(context);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          color: Color.fromARGB(255, 255, 255, 255),
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            ); // Handle menu button press
          },
        ),
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 1, 37, 66),
          padding: EdgeInsets.symmetric(vertical: 60),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "DMSerif",
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // Email Field
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: const Color.fromARGB(221, 255, 255, 255),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                hintText: 'Enter your email',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w400, // ขนาดข้อความ Label Text
                                  color: Color.fromARGB(255, 196, 194, 194),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter your email';
                              },
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),

                      // Password Field
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: const Color.fromARGB(225, 255, 255, 255),
                              ),
                            ),
                            TextFormField(
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w400, // ขนาดข้อความ Label Text
                                  color: Color.fromARGB(255, 196, 194, 194),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter your password';
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  forgotPasswordPage()));
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10,
                                        color: const Color.fromARGB(
                                            225, 255, 255, 255),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black),
                ),
                child: MaterialButton(
                  minWidth: 300,
                  height: 60,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      userLogin();
                    }
                  },
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "DMSerif",
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 250),
            ],
          ),
        ),
      ),
    );
  }
}
