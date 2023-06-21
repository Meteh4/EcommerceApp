import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  String profilePicLink = '';
  String displayName = '';

  @override
  void initState() {
    super.initState();
    getUserProfile();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          displayName = 'Misafir';
        });
      } else {
        getUserProfile();
      }
    });
  }

  void getUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String downloadURL = await FirebaseStorage.instance
            .ref()
            .child("users/${user.uid}/profilepic.jpg")
            .getDownloadURL();

        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        String userName = snapshot['full_name'];

        setState(() {
          profilePicLink = downloadURL;
          displayName = userName.isNotEmpty ? userName : _getDisplayName();
        });
      } else {
        setState(() {
          displayName = 'Misafir';
        });
      }
    } catch (e) {
      setState(() {
        profilePicLink = '';
        displayName = 'Misafir';
      });
      print('Failed to get user profile: $e');
    }
  }

  String _getDisplayName() {
    User? user = FirebaseAuth.instance.currentUser;
    String displayName = user?.displayName ?? 'Misafir';
    return displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.0,
            backgroundImage: profilePicLink != ''
                ? NetworkImage(profilePicLink)
                : const AssetImage('assets/images/default_profile_pic.jpg') as ImageProvider<Object>?,
          ),
          const SizedBox(width: 8.0),
          Text(displayName),
        ],
      ),
    );
  }
}