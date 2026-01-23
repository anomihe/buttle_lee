import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
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
    tz_data.initializeTimeZones();

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
    if (scheduledTime.isBefore(DateTime.now())) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'butler_reminders_channel',
          'Butler Reminders',
          channelDescription: 'Notifications for your Butler Lee reminders',
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

  Future<void> scheduleHydrationReminder(DateTime scheduledTime) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      888, // Hydration specific ID
      'Hydration Check 💧',
      'Have you had water recently?',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'butler_hydration_channel',
          'Hydration Reminders',
          channelDescription: 'Reminders to drink water',
          importance: Importance.max,
          priority: Priority.high,
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
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'hydration_check',
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
