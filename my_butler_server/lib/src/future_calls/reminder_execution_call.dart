import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// FutureCall that executes when a reminder is triggered
class ReminderExecutionCall extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? object) async {
    if (object == null) return;

    final reminder = object as ButlerReminder;

    try {
      // Send real-time notification to all user's connected devices
      session.messages.postMessage(
        'reminder_notification',
        reminder,
      );

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
        // For one-time reminders, mark as inactive
        reminder.isActive = false;
        await ButlerReminder.db.updateRow(session, reminder);
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
