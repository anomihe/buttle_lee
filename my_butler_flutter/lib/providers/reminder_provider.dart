import 'package:flutter/foundation.dart';
import 'package:my_butler_client/my_butler_client.dart';

class ReminderProvider with ChangeNotifier {
  final Client client;
  List<ButlerReminder> _reminders = [];
  bool _isLoading = false;

  ReminderProvider({required this.client}) {
    _setupReminderStream();
  }

  List<ButlerReminder> get reminders => _reminders;
  bool get isLoading => _isLoading;

  /// Setup real-time stream for reminder notifications
  void _setupReminderStream() {
    // Open streaming connection
    client.openStreamingConnection();

    // Listen for reminder notifications
    // Note: In Serverpod 2.9.2, you may need to set up message listeners differently
    // This is a simplified version - adjust based on your Serverpod version's API
    debugPrint('Reminder stream setup initiated');
  }

  /// Load all reminders for the user
  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final reminders = await client.reminder.getUserReminders();
      _reminders = reminders;
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load completed (inactive) reminders
  Future<List<ButlerReminder>> loadCompletedReminders() async {
    try {
      final reminders = await client.reminder.getCompletedReminders();
      return reminders;
    } catch (e) {
      debugPrint('Error loading completed reminders: $e');
      return [];
    }
  }

  /// Create a new reminder
  Future<ButlerReminder?> createReminder({
    required String description,
    required DateTime triggerTime,
    required ReminderType reminderType,
    Priority priority = Priority.medium,
  }) async {
    try {
      final reminder = await client.reminder.createReminder(
        description,
        triggerTime,
        reminderType,
        priority: priority,
      );

      if (reminder != null) {
        _reminders.add(reminder);
        _reminders.sort((a, b) => a.triggerTime.compareTo(b.triggerTime));
        notifyListeners();
      }

      return reminder;
    } catch (e) {
      debugPrint('Error creating reminder: $e');
      return null;
    }
  }

  /// Update a reminder
  Future<void> updateReminder({
    required int reminderId,
    String? description,
    DateTime? triggerTime,
    ReminderType? reminderType,
    Priority? priority,
  }) async {
    try {
      await client.reminder.updateReminder(
        reminderId,
        description,
        triggerTime,
        reminderType,
        priority: priority,
      );
      await loadReminders();
    } catch (e) {
      debugPrint('Error updating reminder: $e');
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(int reminderId) async {
    try {
      await client.reminder.deleteReminder(reminderId);
      await loadReminders();
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
    }
  }

  /// Snooze a reminder to a later time
  Future<bool> snoozeReminder(int reminderId, DateTime snoozeUntil) async {
    try {
      final reminder =
          await client.reminder.snoozeReminder(reminderId, snoozeUntil);

      if (reminder != null) {
        // Update the reminder in the list
        final index = _reminders.indexWhere((r) => r.id == reminderId);
        if (index != -1) {
          _reminders[index] = reminder;
          _reminders.sort((a, b) => a.triggerTime.compareTo(b.triggerTime));
          notifyListeners();
        }
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error snoozing reminder: $e');
      return false;
    }
  }

  @override
  void dispose() {
    // Clean up streaming connection if needed
    super.dispose();
  }
}
