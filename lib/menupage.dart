import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:milktea/addImage.dart';
import 'package:milktea/editimage.dart';
import 'package:milktea/editprofile.dart';
import 'package:milktea/favoritebyuser.dart';
import 'package:milktea/imagedetails.dart';
import 'package:milktea/main.dart';
import 'package:milktea/userpost.dart';

class MenuPage extends StatefulWidget {
  final int screenIndex1;
  const MenuPage({Key? key, required this.screenIndex1}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final Random random = Random();

  int screenIndex = 0;
  final mobileScreens = [
    Home(),
    ManageImage(),
    ProfilePage(),
    _UserFavorie(),
  ];

  void initState() {
    super.initState();
    screenIndex = widget.screenIndex1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mobileScreens[screenIndex],
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 1, 37, 66),
        shape: CircularNotchedRectangle(),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 0;
                  });
                },
                icon: Icon(
                  Icons.home,
                  //------ ถ้า Index = 0 ให้ไอคอนสีเหลือง ถ้าไม่ใช้ไอคอนสีขาว ------
                  color: screenIndex == 0
                      ? Color.fromRGBO(254, 254, 254, 1) // สีขาวเมื่อถูกเลือก
                      : const Color.fromARGB(
                          255, 172, 169, 169), // สีเทาเมื่อไม่ได้เลือก
                  // color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.edit,
                  //------ ถ้า Index = 0 ให้ไอคอนสีเหลือง ถ้าไม่ใช้ไอคอนสีขาว ------
                  color: screenIndex == 1
                      ? Color.fromRGBO(254, 254, 254, 1) // สีขาวเมื่อถูกเลือก
                      : const Color.fromARGB(
                          255, 172, 169, 169), // สีเทาเมื่อไม่ได้เลือก
                  // color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 3;
                  });
                },
                icon: Icon(
                  Icons.favorite,
                  //------ ถ้า Index = 0 ให้ไอคอนสีเหลือง ถ้าไม่ใช้ไอคอนสีขาว ------
                  color: screenIndex == 3
                      ? Color.fromRGBO(254, 254, 254, 1) // สีขาวเมื่อถูกเลือก
                      : const Color.fromARGB(
                          255, 172, 169, 169), // สีเทาเมื่อไม่ได้เลือก
                  // color: Colors.white,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    //------ กำหนดค่า Index เมื่อมีการคลิก ------
                    screenIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.person,
                  color: screenIndex == 2
                      ? Color.fromRGBO(254, 254, 254, 1)
                      : const Color.fromARGB(255, 172, 169, 169),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addImage()),
          );
        },
        child: Icon(Icons.add_photo_alternate),
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

//------------- Home page -------------
class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            color: Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Do you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // ปิดกล่องข้อความ
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          // เพิ่มโค้ดที่ต้องการเมื่อคุณต้องการlogout
                        },
                        child: Text('logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('topic').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          final List<String> imageUrls = documents
              .map((doc) => doc['imageUrl'] as String)
              .toList(); // รับ URL ของรูปภาพจาก documents

          return SingleChildScrollView(
            child: MasonryGrid(
              column: 2,
              children: imageUrls.map((imageUrl) {
                return Padding(
                  padding: const EdgeInsets.all(4.0), // ระยะห่างระหว่างรูปภาพ
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageDetailPage(
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // ปรับขอบรูปภาพให้โค้ง
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit
                            .cover, // ทำให้รูปภาพปรับตามขนาดของพื้นที่ที่กำหนด
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

//------------- profile Page -------------
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Stream<int> likeCountStream = FirebaseFirestore.instance
      .collection('favorite')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots()
      .map((snapshot) {
    int totalLikes = 0;
    snapshot.docs.forEach((doc) {
      totalLikes += (doc['liked_by'] as List).length;
    });
    return totalLikes;
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<int> fetchPostCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('topic')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching post count: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Do you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // ปิดกล่องข้อความ
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text('logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic>? userData =
                snapshot.data?.data() as Map<String, dynamic>?;

            String imageUrl = userData?['image'] ?? '';

            return Column(
              children: [
                SizedBox(height: 15),
                Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : AssetImage("img/profile.png") as ImageProvider,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Column(
                    children: [
                      Text(
                        userData?['username'] ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(userData?['email'] ?? ""),
                      Text(
                        userData?['caption'] ?? "",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FutureBuilder<int>(
                        future: fetchPostCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(
                              children: [
                                Text(
                                  snapshot.data.toString(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "POST",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: Colors.grey),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      StreamBuilder<int>(
                        stream: likeCountStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Column(
                              children: [
                                Text(
                                  snapshot.data.toString(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "LIKE",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: Colors.grey),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 1, 37, 66),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: TabBar(
                      controller: _tabController,
                      indicatorColor: Color.fromARGB(255, 1, 37, 66),
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.post_add,
                            color: Colors.black,
                          ),
                        ),
                        Tab(
                          icon: Icon(Icons.favorite, color: Colors.black),
                        )
                      ]),
                ),
                Container(
                  child: Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [UserPost(), UserFavorie()],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

//------------- ManageImage   -------------
class ManageImage extends StatefulWidget {
  const ManageImage({Key? key}) : super(key: key);
  @override
  State<ManageImage> createState() => _ManageImageState();
}

class _ManageImageState extends State<ManageImage> {
  late String currentUserEmail;
  @override
  void initState() {
    super.initState();
    // Get current user's email
    currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  }

  void showDeleteDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm deletion'),
          content: Text('Are you sure you want to delete this Image'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องข้อความ
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteImage(
                    imageUrl); // เรียกใช้ฟังก์ชัน deleteImage เมื่อต้องการลบ
                Navigator.of(context)
                    .pop(); // ปิดกล่องข้อความหลังจากลบเสร็จสิ้น
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteImage(String imageUrl) async {
    if (imageUrl != null) {
      // ตรวจสอบว่า imageUrl ไม่ใช่ค่า null ก่อนที่จะดำเนินการ

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("topic")
          .where('imageUrl', isEqualTo: imageUrl)
          .get();

      snapshot.docs.forEach((doc) async {
        String documentId = doc.id;
        // ลบเอกสารจากตาราง "topic"
        await FirebaseFirestore.instance
            .collection("topic")
            .doc(documentId)
            .delete();

        // ลบรูปภาพใน Cloud Storage
        String fileName = imageUrl.split('/').last; // รับชื่อไฟล์จาก URL
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();

        // ลบข้อมูลจากตาราง "favorite"
        await FirebaseFirestore.instance
            .collection("favorite")
            .where('imageUrl', isEqualTo: imageUrl)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((doc) {
            String favoriteDocumentId = doc.id;
            FirebaseFirestore.instance
                .collection("favorite")
                .doc(favoriteDocumentId)
                .delete();
          });
        });
      });

      print("ลบข้อมูลสำเร็จ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Manage Images',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Do you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // ปิดกล่องข้อความ
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          // เพิ่มโค้ดที่ต้องการเมื่อคุณต้องการlogout
                        },
                        child: Text('logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('topic')
            .where('email', isEqualTo: currentUserEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(child: Text('No images found for this user'));
          }
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final imageUrl = documents[index]['imageUrl'] as String;
              final imageTitle = documents[index]['title'] as String;
              final imageDetail = documents[index]['detail'] as String;

              return Container(
                height: 120,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                      color: Colors.grey[400]!,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          imageUrl,
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              imageTitle,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              imageDetail,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10), // Adjust this value as needed
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditImage(imageUrl: imageUrl),
                                ),
                              );

                              // Edit button pressed
                            },
                            icon: Icon(
                              Icons.edit,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDeleteDialog(imageUrl);
                              // Delete button pressed
                            },
                            icon: Icon(
                              Icons.delete,
                              color: const Color.fromARGB(255, 254, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    );
  }
}

//------------- UserFavorite  -------------
class _UserFavorie extends StatelessWidget {
  _UserFavorie({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // ไม่ได้ล็อคอิน
      return Center(
        child: Text('Please login to view pictures.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Favorite',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 1, 37, 66),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            color: Color.fromARGB(255, 254, 255, 255),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Do you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // ปิดกล่องข้อความ
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          // เพิ่มโค้ดที่ต้องการเมื่อคุณต้องการlogout
                        },
                        child: Text('logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorite')
            .where('liked_by', arrayContains: user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          final List<String> imageUrls = documents
              .where((doc) =>
                  doc['imageUrl'] != null &&
                  doc['imageUrl'] != "") // ตรวจสอบว่ามี URL รูปภาพหรือไม่
              .map((doc) => doc['imageUrl'] as String)
              .toList();

          if (imageUrls.isEmpty) {
            // ไม่พบรูปภาพที่ถูกใจสำหรับผู้ใช้นี้
            return Center(
              child: Text('No favorite images were found for this user'),
            );
          }

          return SingleChildScrollView(
            child: MasonryGrid(
              column: 2,
              children: imageUrls.map((imageUrl) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageDetailPage(
                            imageUrl: imageUrl,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
