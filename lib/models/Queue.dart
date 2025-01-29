import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/notification.dart';
import '../widgets/main/queue_card_widget.dart';

class Queue {
  // Firebase's Queue Information
  String queueId;
  String landmark;
  String location;
  String name;

  int waitTime;
  int indexWaitTime;
  bool isTimerActive = false;

  // Queue Card Metadata
  Color queueCardColor = Color.fromARGB(255, 30, 144, 255);

  int userQueuePosition = 0;
  List queueMembers = [];
  int seconds = 59;

  Function queueStateManager = () {};

  Queue({
    required this.queueId,
    required this.landmark,
    required this.location,
    required this.name,
    required this.waitTime,
  }) : indexWaitTime = waitTime;

  void queueCardWidgetBridge(Function queueCardWidgetState) {
    queueStateManager = queueCardWidgetState;
  }

  void startQueueTimer() {
    seconds = 59;
    var timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      queueStateManager("update-index");
      if (seconds == 0) {
        timer.cancel();
        if (waitTime > 0) {
          waitTime--;
          startQueueTimer();
        } else {
          timer.cancel();
          queueUserRemoval();
        }
      }
    });
  }

  void startQueueTimerAsync(newSeconds) {
    seconds = newSeconds;
    Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      queueStateManager("update-index");
      if (seconds == 0) {
        timer.cancel();
        if (waitTime > 0) {
          waitTime--;
          startQueueTimer();
        } else {
          timer.cancel();
          queueUserRemoval();
        }
      }
    });
  }

  Future<void> queueUserRemoval() async {
    // Finds the User ID from Local Storage
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("userId");

    var collectionQuery = FirebaseFirestore.instance.collection(queueId);

    final collectionSnapshot =
        await collectionQuery
            .where("id", isEqualTo: userId?.toUpperCase())
            .get();

    for (var doc in collectionSnapshot.docs) {
      await doc.reference.delete();
    }

    queueStateManager("reload-tree");

    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      'queues': FieldValue.arrayRemove([queueId]),
    });
  }

  Future<void> queueIndexManager() async {
    // Finds the logged in user's index
    final SharedPreferences pref = await SharedPreferences.getInstance();
    var userId = pref.getString("userId");

    userQueuePosition = queueMembers.indexWhere(
      (element) => element['data']['id'] == userId,
    );

    // Updates index according to one and not Zero
    if (userQueuePosition == 0) {
      userQueuePosition = 1;
      queueCardColor = Color.fromARGB(255, 255, 165, 0);
      isTimerActive = true;
      showNotification(1);
      startQueueTimer();
    } else {
      userQueuePosition++;
    }

    switch (userQueuePosition) {
      case 2:
        showNotification(2);
        break;
      case 3:
        showNotification(3);
    }

    // Alerts the Queue Widget of a new state change
    queueStateManager("update-index");
  }

  Future<void> findUserIndex() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection(queueId)
            .where(FieldPath.documentId, isNotEqualTo: "qInfo") // Exclude by ID
            .get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> docMember = doc.data() as Map<String, dynamic>;

      Map<String, dynamic> queueMember = {
        'timestamp': docMember['timestamp'].toDate(),
        "data": docMember,
      };

      // Adds the newly joined queue member to the Array of Queue Members
      queueMembers.add(queueMember);

      // Resorts the Queue Members Array from first joined to last joined
      queueMembers.sort(
        (a, b) => a['timestamp'].compareTo(b['timestamp']),
      ); // Sort from oldest to newest
    }

    print(queueMembers);

    queueIndexManager();
    updateUserIndexRealTime();
  }

  void updateUserIndexRealTime() {
    FirebaseFirestore.instance
        .collection(queueId)
        .snapshots(includeMetadataChanges: true)
        .listen((snapshot) {
          // Ignore cache data
          if (snapshot.metadata.isFromCache) {
            return;
          }

          // Loop through the document changes
          for (var change in snapshot.docChanges) {
            // Skip the 'qInfo' document (presumably metadata or queue info)
            if (change.doc.id == 'qInfo') {
              continue;
            }

            if (change.type == DocumentChangeType.added) {
              print("New Member!");
              // Create a Profile for the Queue Member
              Map<String, dynamic> queueMember = {
                'timestamp': change.doc.data()?['timestamp'].toDate(),
                "data": change.doc.data(),
              };

              // Adds the newly joined queue member to the Array of Queue Members
              queueMembers.add(queueMember);

              // Resorts the Queue Members Array from first joined to last joined
              queueMembers.sort(
                (a, b) => a['timestamp'].compareTo(b['timestamp']),
              ); // Sort from oldest to newest

              queueIndexManager();
            }
            if (change.type == DocumentChangeType.removed) {
              print("New Member!");
              // Create a Profile for the Queue Member

              queueMembers.removeWhere(
                (queueMember) =>
                    queueMember["data"]["id"] == change.doc.data()?["id"],
              );

              // Resorts the Queue Members Array from first joined to last joined
              queueMembers.sort(
                (a, b) => a['timestamp'].compareTo(b['timestamp']),
              ); // Sort from oldest to newest

              print(queueMembers);

              queueIndexManager();
            }
          }
        });
  }
}
