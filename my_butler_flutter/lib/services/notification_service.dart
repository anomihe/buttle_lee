import 'dart:typed_data';
import 'dart:ui' show Color;

import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Top-level function for background handling
@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  if (notificationResponse.payload == 'hydration_yes') {
    final prefs = await SharedPreferences.getInstance();
    int glasses = prefs.getInt('hydration_count') ?? 0;
    glasses++;
    await prefs.setInt('hydration_count', glasses);

    // Save history
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final historyString = prefs.getString('hydration_history');
    // ... simple history save (simplified for background) ...
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone
    tz_data.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories = [
      DarwinNotificationCategory(
        'hydration_category',
        actions: [
          DarwinNotificationAction.plain('hydration_yes', 'Yes, I drank water'),
          DarwinNotificationAction.plain('hydration_later', 'Remind me later'),
        ],
        options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
      ),
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _createNotificationChannels();
// ... (existing imports)

// ... (inside init method)
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        if (details.payload == 'hydration_yes' ||
            details.actionId == 'hydration_yes') {
          await _handleHydrationAction(true);
        } else if (details.payload == 'hydration_later' ||
            details.actionId == 'hydration_later') {
          await _handleHydrationAction(false);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Request Exact Alarms Permission (Android 12+)
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestExactAlarmsPermission();
    await androidImplementation?.requestNotificationsPermission();

    // Initialize Firebase Messaging
    await _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Get the token
      try {
        String? token = await messaging.getToken();
        print('FCM Token: $token');
      } catch (e) {
        print('Failed to get FCM token: $e');
        // Continue without token - app shouldn't crash
      }

      // Handle Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
          // Show local notification
          scheduleNotification(
            id: message.hashCode,
            title: message.notification!.title ?? 'New Notification',
            body: message.notification!.body ?? '',
            scheduledTime: DateTime.now(), // Show immediately
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _createNotificationChannels() async {
    // Android 8.0+ requires notification channels
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      'butler_reminders_channel_v2',
      'Butler Reminders',
      description: 'Notifications for your Butler Lee reminders',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList(const [0, 500, 500, 500]),
    );

    const AndroidNotificationChannel hydrationChannel =
        AndroidNotificationChannel(
      'butler_hydration_channel_v2',
      'Hydration Reminders',
      description: 'Reminders to drink water',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel routineChannel =
        AndroidNotificationChannel(
      'butler_routine_channel',
      'Routine Reminders',
      description: 'Reminders for your daily routines',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
    await androidPlugin?.createNotificationChannel(hydrationChannel);
    await androidPlugin?.createNotificationChannel(routineChannel);
  }

  /// Subscribe to user-specific topic for FCM notifications
  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Failed to subscribe to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Failed to unsubscribe from topic $topic: $e');
    }
  }

  Future<void> _handleHydrationAction(bool isYes) async {
    // This runs in foreground typically when app opens
    if (isYes) {
      final prefs = await SharedPreferences.getInstance();
      int glasses = prefs.getInt('hydration_count') ?? 0;
      await prefs.setInt('hydration_count', glasses + 1);
      // Note: HydrationTrackerWidget will reload on resume/build
    } else {
      // Reschedule for 1 hour later
      final now = DateTime.now().add(const Duration(hours: 1));
      await scheduleHydrationReminder(now);
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
      debugPrint('Scheduling notification [$id] at: $tzTime');

      // Always use exact scheduling for better reliability
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'butler_reminders_channel_v2',
            'Butler Reminders',
            channelDescription: 'Notifications for your Butler Lee reminders',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 500, 500, 500]),
            colorized: true,
            color: const Color.fromARGB(255, 0, 122, 255),
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'default',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Notification [$id] scheduled successfully');
    } catch (e, stackTrace) {
      debugPrint('Error scheduling notification [$id]: $e');
      debugPrint('Stack trace: $stackTrace');

      // Fallback: show immediately if scheduling fails
      await showNotificationImmediately(
        id: id,
        title: title,
        body: body,
      );
    }
  }

  Future<void> showNotificationImmediately({
    required int id,
    required String title,
    required String body,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'butler_reminders_channel_v2',
          'Butler Reminders',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  // Future<void> scheduleNotification({
  //   required int id,
  //   required String title,
  //   required String body,
  //   required DateTime scheduledTime,
  // }) async {
  //   // If time is now or past, show immediately using show()
  //   if (scheduledTime.difference(DateTime.now()).inSeconds < 5) {
  //     await flutterLocalNotificationsPlugin.show(
  //       id,
  //       title,
  //       body,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'butler_reminders_channel',
  //           'Butler Reminders',
  //           channelDescription: 'Notifications for your Butler Lee reminders',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //         ),
  //         iOS: DarwinNotificationDetails(),
  //       ),
  //     );
  //     return;
  //   }

  //   debugPrint(
  //       'Scheduling regular notification [$id]: "$title" at ${scheduledTime.toLocal()} (Exact)');

  //   try {
  //     final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);
  //     debugPrint('Converting to TZ Time: $tzTime (Timezone: ${tz.local.name})');

  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tzTime,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'butler_reminders_channel_v2', // Changed ID to force update
  //           'Butler Reminders',
  //           channelDescription: 'Notifications for your Butler Lee reminders',
  //           importance: Importance.max,
  //           priority: Priority.max, // Upgraded from high to max
  //           fullScreenIntent: true, // Enable full screen intent
  //         ),
  //         iOS: DarwinNotificationDetails(),
  //       ),
  //       androidScheduleMode:
  //           AndroidScheduleMode.exactAllowWhileIdle, // Ensure EXACT
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  //   } catch (e) {
  //     debugPrint(
  //         'Error scheduling exact notification [$id]: $e. Falling back to inexact.');
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       id,
  //       title,
  //       body,
  //       tz.TZDateTime.from(scheduledTime, tz.local),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'butler_reminders_channel_v2',
  //           'Butler Reminders',
  //           importance: Importance.max,
  //           priority: Priority.max,
  //           fullScreenIntent: true,
  //         ),
  //         iOS: DarwinNotificationDetails(),
  //       ),
  //       androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //     );
  //   }
  // }

  Future<void> scheduleHydrationReminder(DateTime scheduledTime) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        888, // Hydration specific ID
        'Hydration Check 💧',
        'Time to drink some water!',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'butler_hydration_channel_v2', // Changed ID
            'Hydration Reminders',
            channelDescription: 'Reminders to drink water',
            importance: Importance.max,
            priority: Priority.max,
            fullScreenIntent: true,
            actions: [
              AndroidNotificationAction('hydration_yes', 'Yes',
                  showsUserInterface: true),
              AndroidNotificationAction('hydration_later', 'Later',
                  showsUserInterface: false),
            ],
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: 'hydration_category',
          ),
        ),
        androidScheduleMode:
            AndroidScheduleMode.exactAllowWhileIdle, // Ensure EXACT
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'hydration_check',
      );
    } catch (e) {
      debugPrint(
          'Error scheduling exact hydration reminder: $e. Falling back to inexact.');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        888,
        'Hydration Check 💧',
        'Time to drink some water!',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'butler_hydration_channel_v2',
            'Hydration Reminders',
            channelDescription: 'Reminders to drink water',
            importance: Importance.max,
            priority: Priority.max,
            fullScreenIntent: true,
          ),
          iOS: DarwinNotificationDetails(
              categoryIdentifier: 'hydration_category'),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'hydration_check',
      );
    }
  }

  /// Schedule a recurrent reminder (simulated by spacing out notifications)
  /// Note: Real 'repeatInterval' in local_notifications is limited (every minute/hour/day/week).
  /// For custom intervals (e.g. 45 mins), we schedule a one-off and reschedule upon firing/completion,
  /// or schedule multiple future notifications.
  /// Here we'll schedule a single shot, assuming the app will re-schedule the next one when this fires
  /// OR the user interacts. For robustness, we could schedule X instances ahead.
  Future<void> scheduleRecurrentReminder({
    required int id,
    required String title,
    required String body,
    required Duration interval,
  }) async {
    final now = DateTime.now();
    debugPrint(
        'Scheduling recurrent reminder [$id]: "$title" every ${interval.inMinutes} minutes (Next: ${now.add(interval).toLocal()})');
    // Schedule the first one
    final scheduledTime = now.add(interval);

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(interval),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'butler_routine_channel',
            'Routine Reminders',
            channelDescription: 'Reminders for your daily routines',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint(
          'Error scheduling exact recurrent reminder [$id]: $e. Falling back.');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(interval),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'butler_routine_channel',
            'Routine Reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> showTestNotification() async {
    debugPrint('Showing test notification...');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'butler_reminders_channel_v2',
      'Butler Reminders',
      channelDescription: 'Notifications for your Butler Lee reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      999,
      'Test Notification',
      'This is a test notification from Butler Lee',
      platformChannelSpecifics,
      payload: 'test',
    );
  }

  Future<String> debugPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? notificationsGranted =
        await androidImplementation?.areNotificationsEnabled();
    final bool? exactAlarmsGranted =
        await androidImplementation?.requestExactAlarmsPermission();
    // Note: requestExactAlarmsPermission returns success? No, it requests.
    // There isn't a simple "canScheduleExactAlarms" getter exposed in this version of the plugin easily without platform channel check,
    // but looking at 'requestExactAlarmsPermission', it usually opens settings if needed.
    // Let's just return what we know.

    final now = tz.TZDateTime.now(tz.local);
    return 'Notifications Enabled: $notificationsGranted\n'
        'Exact Alarms Requested: True\n'
        'Timezone: ${tz.local.name}\n'
        'App Local Time: $now';
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
