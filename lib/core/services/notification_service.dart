// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     // Initialize timezone
//     tz.initializeTimeZones();
//     final String localTimeZone = tz.local.name;
//     tz.setLocalLocation(tz.getLocation(localTimeZone));

//     // Android settings
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings settings = InitializationSettings(
//       android: androidSettings,
//     );

//     await _notificationsPlugin.initialize(settings);
//   }

//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//   }) async {
//     final tz.TZDateTime tzDateTime = tz.TZDateTime.from(
//       scheduledDate,
//       tz.local,
//     );

//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tzDateTime,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'main_channel',
//           'Main Notifications',
//           channelDescription: 'Fires at local scheduled time',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime,
//     );
//   }
// }
