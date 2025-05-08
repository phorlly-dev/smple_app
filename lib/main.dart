import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smple_app/views/pages/home.dart';

//global object for accessing device screen size
Size mq = Size.zero;
var formKey = GlobalKey<FormState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await NotificationService.init(); // Must be awaited
  runApp(const MyApp());
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
