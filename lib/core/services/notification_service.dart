import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smple_app/common/global.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()!
        .requestNotificationsPermission();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onSelectNotification: onSelectNotification, // You can add this later for handling notification taps
    );
  }

  Future<void> scheduleNotification({
    required String id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    // Convert the scheduled time to the local timezone
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    if (Global.isSameMinute(scheduledTime.toLocal(), DateTime.now())) {
      await flutterLocalNotificationsPlugin.show(
        id.hashCode,
        title,
        'Scheduled: ${Global.dateTimeFormat(scheduledTime)}',
        notificationDetails,
        payload: 'item x',
      );
    }

    // Schedule the notification
    // await flutterLocalNotificationsPlugin.show(
    //   id.hashCode,
    //   title,
    //   '${Global.dateTimeFormat(scheduledTime)}',
    //   notificationDetails,
    //   payload: 'item x',
    // );

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id.hashCode,
    //   title,
    //   '${Global.dateTimeFormat(scheduledTime)}',
    //   tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    //   notificationDetails,
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    // );
  }

  // You can add a method to cancel notifications later
  Future<void> cancelNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(id.hashCode);
  }
}

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
// final tz.TZDateTime tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

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
//       androidScheduleMode: null,
//     );
//   }
// }
