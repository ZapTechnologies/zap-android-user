// Dependencies & Packages Import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../screen/main/home_screen.dart';

var uuid = Uuid();

class User {
  final String id;
  final String name;
  final String phone;
  final String usermail;

  User(this.name, this.phone, this.usermail) : id = uuid.v4();

  Future<void> createAccount(BuildContext context) async {
    var firestore = FirebaseFirestore.instance.collection("users");
    final prefs = await SharedPreferences.getInstance();
    firestore.doc(id.toUpperCase()).set({
      'id': id.toUpperCase(),
      'name': name,
      'phone': phone,
      'queues': [],
      'usermail': usermail,
    });

    print("Account Created With ID of $id");

    // Locally Set's the User's ID
    prefs.setString("userId", id.toUpperCase());

    // Locally Set's the default screen index
    prefs.setInt("activeScreenIndex", 1);

    print(id);

    // Navigate to the home screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }
}
