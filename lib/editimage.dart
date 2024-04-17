import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:milktea/menupage.dart';

class EditImage extends StatefulWidget {
  final String imageUrl; // Add this line

  const EditImage({Key? key, required this.imageUrl})
      : super(key: key); // Update this line

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  String image = "";
  @override
  void initState() {
    super.initState();
    fetchImageData();
  }

  Future<void> fetchImageData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('topic')
          .where('imageUrl', isEqualTo: widget.imageUrl)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot snapshot = querySnapshot.docs.first;
        setState(() {
          titleController.text = snapshot['title'] ?? '';
          detailController.text = snapshot['detail'] ?? '';

          print('Error fetching image data: $image');
        });
      }
    } catch (e) {
      print('Error fetching image data: $e');
    }
  }

  void EditImage() async {
    if (formKey.currentState!.validate()) {
      String newTitle = titleController.text;
      String newDetail = detailController.text;
      if (widget.imageUrl != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection("topic")
            .where('imageUrl', isEqualTo: widget.imageUrl)
            .get();

        snapshot.docs.forEach((doc) async {
          await FirebaseFirestore.instance
              .collection("topic")
              .doc(doc.id)
              .update({
            "title": newTitle,
            "detail": newDetail,
          });
        });

        print("อัปเดตข้อมูลสำเร็จ");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MenuPage(
                    screenIndex1: 1,
                  )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit Image",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        leading: IconButton(
          color: Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuPage(
                        screenIndex1: 1,
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
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: 400,
                height: 400,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
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
                            "Title",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              hintText: 'Tell others what your iamge is called',
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold // ขนาดข้อความ Label Text
                                  ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please input your title';
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detail",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                          TextFormField(
                            maxLength: 30,
                            controller: detailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              hintText: 'Add a detail to your iamge',
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold // ขนาดข้อความ Label Text
                                  ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Please add a detail to the iamge";
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
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
                          backgroundColor: Color.fromARGB(255, 1, 37, 66),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
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
                          EditImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 1, 37, 66),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "EDIT",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
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
