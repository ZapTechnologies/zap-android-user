import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zap_android_user/provider/queue_provider.dart';
import 'package:zap_android_user/screen/authentication/registration_screen.dart';
import 'package:zap_android_user/screen/main/home_screen.dart';

import 'configs/theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyC9be2gXvuRvRwSMtxOckWFmyu-kdmfvSk",
  //     appId: "1:461474743043:web:e5828fb4d057e9ebf5df36",
  //     messagingSenderId: '"461474743043"',
  //     projectId: "q-up-2b8ae",
  //   ),
  // );

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var activeScreen = prefs.getInt("activeScreenIndex");

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  List<Widget> screens = [RegistrationScreen(), HomeScreen()];

  if (activeScreen == null) {
    await prefs.setInt('number', 0);
    activeScreen =
        0; // Assign the default value for `data` after setting it to 0
  }

  // await initializeBackground();

  runApp(
    ChangeNotifierProvider(
      create: (context) => QueueProvider(),
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: lightTheme,
        home: screens[activeScreen],
      ),
    ),
  );
}

Future<void> initializeBackground() async {
  bool success = await FlutterBackground.initialize();
  if (success) {
    await FlutterBackground.enableBackgroundExecution();
  } else {
    print("Failed to initialize background execution");
  }
}
