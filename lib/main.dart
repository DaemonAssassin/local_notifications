import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart' as tz;

//! Create Notifications
//* 1 => To initialize local notifications - create InitializationSettings
//* 2 => To create notification - create NotificationDetails
//? - For simple notifications use show method
//? - For schedule notifications use zoneSchedule method (with Timezone package)

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
Logger logger = Logger();

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeTimeZones(); // package -> timezone/data/latest_10y.dart
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings iOSSettings = const DarwinInitializationSettings(
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iOSSettings,
  );
  bool? isInitialized =
      await notificationsPlugin.initialize(initializationSettings);
  logger.i('Notifications: $isInitialized');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: showScheduleNotification,
          child: const Icon(Icons.notification_add),
        ),
      ),
    );
  }

  void showNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'CID-1',
      'YouTube Notifications',
      channelDescription: 'This channel is for YouTube Notifications',
      importance: Importance.max,
      priority: Priority.max,
    );

    DarwinNotificationDetails iOSDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 0,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await notificationsPlugin.show(
      0,
      'First Notification',
      'Hello To the Future',
      notificationDetails,
    );
  }

  void showScheduleNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'CID-1',
      'YouTube Notifications',
      channelDescription: 'This channel is for YouTube Notifications',
      importance: Importance.max,
      priority: Priority.max,
    );

    DarwinNotificationDetails iOSDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 0,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    final DateTime scheduleDate =
        DateTime.now().add(const Duration(seconds: 5));
    await notificationsPlugin.zonedSchedule(
      0,
      'Zoned Schedule Notification',
      'Data is here.',
      tz.TZDateTime.from(scheduleDate, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,
    );
  }
}
