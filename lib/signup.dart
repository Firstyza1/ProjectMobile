import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:milktea/login.dart';
import 'package:milktea/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (builder) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      // เรียกใช้ Firebase Authentication เพื่อตรวจสอบอีเมล
      var userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // ลงทะเบียนสำเร็จ
        print('ลงทะเบียนสำเร็จ: ${userCredential.user!.email}');
        // เก็บข้อมูลผู้ใช้เพิ่มเติมใน Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': usernameController.text,
          'email': userCredential.user!.email,
          "caption": '',
          "image":
              'https://firebasestorage.googleapis.com/v0/b/milktea-13bba.appspot.com/o/profile.png?alt=media&token=dd3912db-c907-4541-a396-c0102b5a34e6'
          // เพิ่มข้อมูลผู้ใช้อื่น ๆ ตามต้องการ
        });
      } else {
        print('ไม่สามารถลงทะเบียนได้');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('มีผู้ใช้งานอีเมลนี้แล้ว');
      } else {
        print('เกิดข้อผิดพลาด: ${e.message}');
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
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
      ),
      body: Container(
        color: Color.fromARGB(255, 1, 37, 66),
        padding: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: "DMSerif",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
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
                                fontSize: 15,
                                color: const Color.fromARGB(221, 255, 255, 255),
                              ),
                            ),
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
                                  hintText: 'Enter your Email',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight
                                        .w400, // ขนาดข้อความ Label Text
                                    color: Color.fromARGB(255, 196, 194, 194),
                                  ),
                                ),
                                validator: MultiValidator([
                                  EmailValidator(
                                      errorText:
                                          "Please fill in the information correctly."),
                                  RequiredValidator(
                                      errorText: "Please specify email.")
                                ])),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                      //Username Field
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Username",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: const Color.fromARGB(221, 255, 255, 255),
                              ),
                            ),
                            TextFormField(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                controller: usernameController,
                                obscureText: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  hintText: 'Enter your username',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight
                                        .w400, // ขนาดข้อความ Label Text
                                    color: Color.fromARGB(255, 196, 194, 194),
                                  ),
                                ),
                                validator: RequiredValidator(
                                    errorText: "Please specify username.")),
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
                                fontSize: 15,
                                color: const Color.fromARGB(221, 255, 255, 255),
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
                                    fontWeight: FontWeight
                                        .w400, // ขนาดข้อความ Label Text
                                    color: Color.fromARGB(255, 196, 194, 194),
                                  ),
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Please specify password."),
                                  MinLengthValidator(6,
                                      errorText:
                                          "Please enter a password with all 6 characters."),
                                ])),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),

                      // Confirm Password Field
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: const Color.fromARGB(221, 255, 255, 255),
                              ),
                            ),
                            TextFormField(
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                hintText: 'Enter your confirm password',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w400, // ขนาดข้อความ Label Text
                                  color: Color.fromARGB(255, 196, 194, 194),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Please specify confirm password";
                                if (value.length < 6)
                                  return "Please enter a password with all 6 characters.";
                                if (value != passwordController.text)
                                  return "Please fill in the information to match.";
                              },
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
                  border: Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                ),
                child: MaterialButton(
                  minWidth: 300,
                  height: 60,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      signUserUp();
                    }
                  },
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: "DMSerif",
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('img/SAAA.png'),
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
