import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:milktea/menupage.dart'; // เพิ่ม dependency นี้

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  File? image;
  String imageUrl = ""; 

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      setState(() {
        usernameController.text = userDoc['username'] ?? '';
        captionController.text = userDoc['caption'] ?? '';
        imageUrl = userDoc['image'] ??
            "https://firebasestorage.googleapis.com/v0/b/milktea-13bba.appspot.com/o/profile.png?alt=media&token=dd3912db-c907-4541-a396-c0102b5a34e6";
      });
    }
  }

  void editProfile() async {
    if (formKey.currentState!.validate()) {
      String newUsername = usernameController.text;
      String newCaption = captionController.text;
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // ถ้ามีการเลือกรูปภาพใหม่
        if (image != null) {
          // อัปโหลดรูปภาพไปยัง Firebase Storage
          try {
            TaskSnapshot snapshot = await FirebaseStorage.instance
                .ref("profile_images/$userId.jpg")
                .putFile(image!);

            // ดึง URL ของรูปภาพที่อัปโหลด
            imageUrl = await snapshot.ref.getDownloadURL();
          } catch (e) {
            print("เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ: $e");
          }
        }

        // อัปเดตข้อมูลใน Firestore ในตาราง "users"
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .update({
          "username": newUsername,
          "caption": newCaption,
          "image": imageUrl, // ให้ใช้ URL ของรูปภาพที่อัปโหลด
        });

        print("อัปเดตข้อมูลสำเร็จ");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MenuPage(
                    screenIndex1: 2,
                  )),
        ); // เ
      }
    }
  }

  Future pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;

      final imageTemporary = File(pickedImage.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print("Failed to pick up image: $e");
    }
  }

  void _showUploading() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context)
              .pop(true); // เมื่อกระบวนการอัปโหลดเสร็จสิ้น ให้ปิด AlertDialog
        });
        return AlertDialog(
          title: Text("Uploading image"),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Profile",style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Color.fromARGB(221, 255, 255, 255),
                          ),),
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        leading: IconButton(
          color: Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuPage(
                        screenIndex1: 2,
                      )),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 1, 37, 66),
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: const Color.fromARGB(255, 255, 253, 253).withOpacity(0.1),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image != null
                            ? FileImage(image!)
                            : imageUrl.isNotEmpty
                                ? NetworkImage(imageUrl)
                                : AssetImage("img/profile.png")
                                    as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        pickImage(ImageSource.gallery);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.blue,
                        ),
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                               color: Color.fromARGB(221, 255, 255, 255),
                            ),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),                            controller: usernameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              hintText: 'Enter your username',
                              hintStyle: TextStyle(
                                color:Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w400 // ขนาดข้อความ Label Text
                                  ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter your username';
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Caption",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Color.fromARGB(225, 255, 255, 255),
                            ),
                          ),
                          SizedBox(height: 5),
                          TextFormField(
                            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                            maxLength: 30,
                            controller: captionController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              hintText: 'Enter your caption',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w400 // ขนาดข้อความ Label Text
                                  ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          formKey.currentState?.reset();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showUploading();
                          editProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "EDIT",
                          style: TextStyle(color: Color.fromARGB(255, 5, 5, 5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
