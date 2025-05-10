import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smple_app/views/pages/home.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//global object for accessing device screen size
Size mq = Size.zero;
var formKey = GlobalKey<FormState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set up background message handler BEFORE runApp()
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize timezone
  tz.initializeTimeZones();
  final String localTimeZone = tz.local.name;
  tz.setLocalLocation(tz.getLocation(localTimeZone));
  runApp(const MyApp());
}

// Define the top-level or static background message handler
// This function must be a top-level function or static class method.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're using other Firebase services in the background, initialize them first
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform, // Optional
  );

  log("Handling a background message: ${message.messageId}");
  // You can access message data like message.data or message.notification
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // initialRoute: '/',
      routes: {
        // '/home': (context) => const HomePage(title: 'Home Page'),
        // '/user': (context) => const UserPage(title: 'User Page'),
        // '/timerstopwatch': (context) => const TimerStopwatch(),
        // '/weightcalulator': (context) => const WeightCalulator(),
        // '/musicplayer': (context) => const MusicPlayer(),
        // '/simplecalendar': (context) => const SimpleCalendar(),
        // '/calendarnote': (context) => const CalendarNote(),

        // Add other routes here
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(title: 'Home Page'),
    );
  }
}
