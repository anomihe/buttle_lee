import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

/// Endpoint for managing reminders
class ReminderEndpoint extends Endpoint {
  /// Create a new reminder and schedule its execution
  Future<ButlerReminder?> createReminder(
    Session session,
    String description,
    DateTime triggerTime,
    ReminderType reminderType, {
    Priority priority = Priority.medium,
  }) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    // Create reminder
    final reminder = ButlerReminder(
      description: description,
      triggerTime: triggerTime,
      reminderType: reminderType,
      priority: priority,
      userId: userId,
      isActive: true,
    );

    final insertedReminder =
        await ButlerReminder.db.insertRow(session, reminder);

    // Schedule future call for reminder execution
    await session.serverpod.futureCallAtTime(
      'reminderExecution',
      insertedReminder,
      triggerTime,
    );

    return insertedReminder;
  }

  /// Get all reminders for the authenticated user
  Future<List<ButlerReminder>> getUserReminders(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final reminders = await ButlerReminder.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isActive.equals(true),
      orderBy: (t) => t.triggerTime,
    );

    return reminders;
  }

  /// Get completed (inactive) reminders for the authenticated user
  Future<List<ButlerReminder>> getCompletedReminders(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final reminders = await ButlerReminder.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isActive.equals(false),
      orderBy: (t) => t.triggerTime,
      orderDescending: true, // Most recent first
    );

    return reminders;
  }

  /// Get upcoming reminders within a time range
  Future<List<ButlerReminder>> getUpcomingReminders(
    Session session,
    DateTime startTime,
    DateTime endTime,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final reminders = await ButlerReminder.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isActive.equals(true) &
          t.triggerTime.between(startTime, endTime),
      orderBy: (t) => t.triggerTime,
    );

    return reminders;
  }

  /// Update a reminder
  Future<ButlerReminder?> updateReminder(
    Session session,
    int reminderId,
    String? description,
    DateTime? triggerTime,
    ReminderType? reminderType, {
    Priority? priority,
  }) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final reminder = await ButlerReminder.db.findById(session, reminderId);
    if (reminder == null || reminder.userId != userId) {
      throw Exception('Reminder not found or access denied');
    }

    if (description != null) reminder.description = description;
    if (triggerTime != null) {
      reminder.triggerTime = triggerTime;

      // Auto-reactivate if the new time is in the future
      if (triggerTime.isAfter(DateTime.now()) && !reminder.isActive) {
        reminder.isActive = true;
        session.log(
            'Reminder ${reminder.id} reactivated - new time is in the future');
      }
    }
    if (reminderType != null) reminder.reminderType = reminderType;
    if (priority != null) reminder.priority = priority;

    await ButlerReminder.db.updateRow(session, reminder);

    return reminder;
  }

  /// Delete (deactivate) a reminder
  Future<bool> deleteReminder(Session session, int reminderId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final reminder = await ButlerReminder.db.findById(session, reminderId);
    if (reminder == null || reminder.userId != userId) {
      throw Exception('Reminder not found or access denied');
    }

    reminder.isActive = false;
    await ButlerReminder.db.updateRow(session, reminder);

    return true;
  }

  /// Snooze a reminder to a later time
  Future<ButlerReminder?> snoozeReminder(
    Session session,
    int reminderId,
    DateTime snoozeUntil,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final reminder = await ButlerReminder.db.findById(session, reminderId);
    if (reminder == null || reminder.userId != userId) {
      throw Exception('Reminder not found or access denied');
    }

    // Update the snoozed time and trigger time
    reminder.snoozedUntil = snoozeUntil;
    reminder.triggerTime = snoozeUntil;

    await ButlerReminder.db.updateRow(session, reminder);

    // Reschedule future call
    await session.serverpod.futureCallAtTime(
      'reminderExecution',
      reminder,
      snoozeUntil,
    );

    return reminder;
  }
}
