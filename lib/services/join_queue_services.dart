import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../screen/join_queue/grouping_screen.dart';

Future<void> joinQueueHandler(queueId, context) async {
  // Locally retrieves the User's Id
  final prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString("userId");

  // Fetches the user from Firestore
  var fetchedUserDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  Map<String, dynamic>? retrievedDoc = fetchedUserDoc.data();

  // Updates the Users Queue ArrayList
  DocumentReference userDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(userId);

  await userDoc
      .update({
        'queues': FieldValue.arrayUnion([queueId.toString()]),
      })
      .then((_) {
        print("Item added successfully.");
      })
      .catchError((error) {
        print("Failed to add item: $error");
      });

  // Retrieves the Inputted code from Firebase
  var firebase =
      await FirebaseFirestore.instance.collection(queueId).doc("qInfo").get();
  Map<String, dynamic>? inputtedQueue = firebase.data();

  // Debugging: print the value of groupingEn
  print("groupingEn value: ${inputtedQueue?["groupingEn"]}");

  if (inputtedQueue?["groupingEn"] == false) {
    DateTime now = DateTime.now();

    // Define the desired format
    DateFormat format = DateFormat('MMMM d, y \'at\' h:mm:ss a');

    // Format the current DateTime object (optional if you want to store a string)
    String formattedDate = format.format(now);

    var firebase = await FirebaseFirestore.instance.collection(queueId).add({
      'id': userId,
      'name': retrievedDoc?['name'],
      'phone': retrievedDoc?['phone'],
      'timestamp': now,
      'usermail': retrievedDoc?['usermail'],
    });
    Navigator.pop(context);
    print("Joining Queue");
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupingScreen(queueId)),
    );
  }
}

Future<void> groupingJoinHandler(queueId, context, members) async {
  final prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString("userId");

  // Fetches the user from Firestore
  var fetchedUserDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  Map<String, dynamic>? retrievedDoc = fetchedUserDoc.data();

  DateTime now = DateTime.now();

  // Define the desired format
  DateFormat format = DateFormat('MMMM d, y \'at\' h:mm:ss a');

  // Format the current DateTime object (optional if you want to store a string)
  String formattedDate = format.format(now);

  // Add the user to the queue
  var firebase = await FirebaseFirestore.instance.collection(queueId).add({
    'id': userId,
    'name': retrievedDoc?['name'],
    'phone': retrievedDoc?['phone'],
    'timestamp': now,
    'usermail': retrievedDoc?['usermail'],
    'members': members,
  });

  // Debugging: print the success message and the value of members
  print("User added to queue. Members: $members");

  // Navigator.popUntil(context, ModalRoute.withName('/home'));

  // Close all modal bottom sheets if needed
  void closeAllModals(BuildContext context) {
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Close all modals
  closeAllModals(context);
}
