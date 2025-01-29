import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showNotification(positionIndex) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Queue Update', // Title
    'Your current position is ${positionIndex.toString()}. Please arrive soon',
    // Body
    platformChannelSpecifics,
  );
}
