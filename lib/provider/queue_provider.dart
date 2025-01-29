import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Queue.dart';

class QueueProvider extends ChangeNotifier {
  List queues = [];
  bool allowSnapshots = false;

  Future<void> createQueueProfile(String queueId) async {
    var queueQuery =
        await FirebaseFirestore.instance.collection(queueId).doc("qInfo").get();

    // Converts doc Into Dart Map
    Map<String, dynamic> queueDoc = queueQuery.data() as Map<String, dynamic>;

    queues.add(
      Queue(
        queueId: queueId,
        landmark: queueDoc["landmark"],
        location: queueDoc["location"],
        name: queueDoc["name"],
        waitTime: queueDoc["waitTime"],
      ),
    );
  }

  Future<void> getAllQueues() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("userId");
    print(userId);

    // Gets the user doc from Firebase
    var userQuery =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    // Converts doc Into Dart Map
    Map<String, dynamic> userDoc = userQuery.data() as Map<String, dynamic>;

    for (var queueId in userDoc["queues"]) {
      var queueQuery = await FirebaseFirestore.instance
          .collection(queueId)
          .doc("qInfo")
          .get();

      // Converts doc Into Dart Map
      Map<String, dynamic> queueDoc = queueQuery.data() as Map<String, dynamic>;

      queues.add(
        Queue(
          queueId: queueId,
          landmark: queueDoc["landmark"],
          location: queueDoc["location"],
          name: queueDoc["name"],
          waitTime: queueDoc["waitTime"],
        ),
      );
    }

    getNewlyJoinedQueues();

    notifyListeners();
  }

  // Manages Queues Joined In RealTime
  Future<void> getNewlyJoinedQueues() async {
    print("Real Time Queueing Now Active");
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("userId");

    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        if (allowSnapshots == false) {
          allowSnapshots = true;
        } else {
          final userDoc = snapshot.data() as Map<String, dynamic>?;
          List userDocQueues = userDoc?["queues"] as List;

          if (userDocQueues.isNotEmpty) {
            queues.forEach((queue) {
              if (queue.id == userDocQueues.last) {
                print("Duplicate Found!");
                return;
              } else {}
            });

            var queueQuery = await FirebaseFirestore.instance
                .collection(userDocQueues.last)
                .doc("qInfo")
                .get();

            // Converts doc Into Dart Map
            Map<String, dynamic> queueDoc =
                queueQuery.data() as Map<String, dynamic>;

            queues.add(
              Queue(
                queueId: userDocQueues.last,
                landmark: queueDoc["landmark"],
                location: queueDoc["location"],
                name: queueDoc["name"],
                waitTime: queueDoc["waitTime"],
              ),
            );
            notifyListeners();
          } else {
            print("No Queues Were Found!");
          }
        }
      } else {
        print("Document does not exist.");
      }
    });
  }

  void removeQueue(String queueId) {
    queues.removeWhere((queue) => queue.queueId == queueId);
    notifyListeners();
  }
}
