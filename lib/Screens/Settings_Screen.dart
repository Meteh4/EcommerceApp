import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shoptral1/Screens/About_Me_Screen.dart';
import 'package:shoptral1/Screens/Misc_Screen.dart';
import 'login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  late String profilePicLink = '';

  @override
  void initState() {
    super.initState();
    getUserProfilePic();
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Logout failed: $e');
    }
  }

  void getUserProfilePic() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          setState(() {
            profilePicLink = snapshot.get('profilePic') ?? '';
          });
        }
      }
    } catch (e) {
      setState(() {
        profilePicLink = '';
      });
      print('Failed to get profile photo: $e');
    }
  }

  void uploadUserProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 100,
    );

    if (image != null) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          Reference ref = FirebaseStorage.instance.ref().child("users/${user.uid}/profilepic.jpg");

          await ref.putFile(File(image.path));

          String downloadURL = await ref.getDownloadURL();

          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {'profilePic': downloadURL},
            SetOptions(merge: true),
          );

          setState(() {
            profilePicLink = downloadURL;
          });
        }
      } catch (e) {
        setState(() {
          profilePicLink = '';
        });
        print('Failed to upload profile photo: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffDAD3C8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    uploadUserProfilePic();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 235,
                        width: 235,
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4.0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 230,
                        width: 230,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        child: Center(
                          child: profilePicLink != ''
                              ? ClipRRect(
                            child: Image.network(
                              profilePicLink,
                              fit: BoxFit.cover,
                              width: 230,
                              height: 230,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Container(
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 160,
                                  ),
                                );
                              },
                            ),
                          )
                              : const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 160,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    uploadUserProfilePic();
                  },
                  child: const Text('Upload Photo'),
                ),
                ListTile(
                  leading: const Icon(Icons.person_2_outlined),
                  title: const Text('Profile'),
                  onTap: () {
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About Me'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.miscellaneous_services_outlined),
                  title: const Text('Misc'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MiscScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Log Out'),
                  onTap: () {
                    logout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}