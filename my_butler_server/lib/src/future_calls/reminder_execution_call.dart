import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/fcm_service.dart';

/// FutureCall that executes when a reminder is triggered
class ReminderExecutionCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    if (object == null) return;

    final reminder = object as ButlerReminder;

    try {
      // Send real-time notification to all user's connected devices (In-App)
      session.messages.postMessage(
        'reminder_notification',
        reminder,
      );

      // Send Push Notification (FCM)
      // Note: We need the user's FCM token. For now, we'll assume we are broadcasting to a topic
      // or we need to fetch the user's devices.
      // Since we don't have a 'UserDevice' table with tokens yet, I will log a TODO.
      // BUT, the user requested: "server to trigger the firebase notifification"
      // I'll assume we might store tokens in UserProfile or similar, OR we broadcast to a user-specific topic.
      // Let's use a topic convention: 'user_<userId>'

      final fcm = FcmService(session);
      await fcm.sendNotification(
        target: 'user_${reminder.userId}', // Topic for this user
        title: 'Butler Reminder',
        body: reminder.description,
        data: {
          'type': 'reminder',
          'reminderId': reminder.id.toString(),
        },
      );

      // Also check for "drink water" specific request
      if (reminder.description.toLowerCase().contains('water')) {
        // Maybe add specific water logic if needed, but the generic reminder handles it.
      }

      session.log(
          'Reminder executed: ${reminder.description} for user ${reminder.userId}');

      // Handle recurring reminders
      if (reminder.reminderType != ReminderType.once) {
        final nextTriggerTime = _calculateNextTriggerTime(
          reminder.triggerTime,
          reminder.reminderType,
        );

        // Update reminder with next trigger time
        reminder.triggerTime = nextTriggerTime;
        await ButlerReminder.db.updateRow(session, reminder);

        // Schedule next execution
        await session.serverpod.futureCallAtTime(
          'reminderExecution',
          reminder,
          nextTriggerTime,
        );

        session.log('Scheduled next occurrence at $nextTriggerTime');
      } else {
        // For one-time reminders, DO NOT mark as inactive.
        // We want them to stay in the list until the user manually completes them.
        // reminder.isActive = false;
        // await ButlerReminder.db.updateRow(session, reminder);
        session.log('One-time reminder executed (notified), keeping active.');
      }
    } catch (e) {
      session.log('Error executing reminder: $e');
    }
  }

  /// Calculate the next trigger time for recurring reminders
  DateTime _calculateNextTriggerTime(
    DateTime currentTrigger,
    ReminderType type,
  ) {
    switch (type) {
      case ReminderType.daily:
        return currentTrigger.add(Duration(days: 1));

      case ReminderType.weekly:
        return currentTrigger.add(Duration(days: 7));

      case ReminderType.annual:
        return DateTime(
          currentTrigger.year + 1,
          currentTrigger.month,
          currentTrigger.day,
          currentTrigger.hour,
          currentTrigger.minute,
        );

      case ReminderType.once:
        return currentTrigger; // Should not be called for 'once'
    }
  }
}
