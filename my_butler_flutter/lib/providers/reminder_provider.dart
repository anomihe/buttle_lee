import 'package:flutter/foundation.dart';
import 'package:my_butler_client/my_butler_client.dart';
import '../services/notification_service.dart';

class ReminderProvider with ChangeNotifier {
  final Client client;
  List<ButlerReminder> _reminders = [];
  bool _isLoading = false;
  double _productivityScore = 0.0;

  // Energy Mode: high (default, show all) or low (filter high priority)
  bool _isLowEnergyMode = false;

  ReminderProvider({required this.client}) {
    _setupReminderStream();
  }

  List<ButlerReminder> get reminders => _reminders;
  bool get isLoading => _isLoading;
  double get dailyProductivityScore => _productivityScore;
  bool get isLowEnergyMode => _isLowEnergyMode;

  void toggleEnergyMode() {
    _isLowEnergyMode = !_isLowEnergyMode;
    loadReminders(); // Reload to apply filter/sort
    notifyListeners();
  }

  /// Setup real-time stream for reminder notifications
  void _setupReminderStream() {
    // Open streaming connection
    client.openStreamingConnection();

    // Listen for reminder notifications
    // Note: In Serverpod 2.9.2, you may need to set up message listeners differently
    // This is a simplified version - adjust based on your Serverpod version's API
    debugPrint('Reminder stream setup initiated');
  }

  /// Load all reminders for the user and calculate productivity
  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load active reminders
      final allReminders = await client.reminder.getUserReminders();

      // Calculate productivity before filtering
      final completedHistory = await client.reminder.getCompletedReminders();
      _calculateProductivity(completedHistory, allReminders);

      if (_isLowEnergyMode) {
        // Low Energy: Filter OUT high priority and complex tasks. Shows Medium/Low only.
        // Actually, let's keep it positive: "Quick Wins".
        _reminders =
            allReminders.where((r) => r.priority != Priority.high).toList();
      } else {
        _reminders = allReminders;
      }

      _reminders.sort((a, b) => a.triggerTime.compareTo(b.triggerTime));
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateProductivity(List<ButlerReminder> completedHistory,
      List<ButlerReminder> currentActive) {
    final completedTodayCount = completedHistory.length;
    final activeTodayCount = currentActive.where((r) {
      final now = DateTime.now();
      return r.triggerTime.year == now.year &&
          r.triggerTime.month == now.month &&
          r.triggerTime.day == now.day;
    }).length;

    final total = completedTodayCount + activeTodayCount;
    if (total == 0) {
      _productivityScore = 0.0;
    } else {
      _productivityScore = completedTodayCount / total;
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
      final createdReminder = await client.reminder.createReminder(
        description,
        triggerTime,
        reminderType,
        priority: priority,
      );

      if (createdReminder != null) {
        _reminders.add(createdReminder);
        _reminders.sort((a, b) => a.triggerTime.compareTo(b.triggerTime));
        notifyListeners();

        // Schedule Notification
        // triggerTime is already required, so it won't be null
        NotificationService().scheduleNotification(
          id: createdReminder.id!, // Assuming id is non-null after creation
          title: 'Butler Reminder',
          body: createdReminder.description,
          scheduledTime: createdReminder.triggerTime,
        );

        return createdReminder;
      }
      return null;
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
          _reminders[index].snoozedUntil = snoozeUntil;
          // Optimistically update triggerTime for sorting/display
          _reminders[index].triggerTime = snoozeUntil;
          _reminders.sort((a, b) => a.triggerTime.compareTo(b.triggerTime));
          notifyListeners();

          // Reschedule Notification
          NotificationService().cancelNotification(reminderId);
          NotificationService().scheduleNotification(
            id: reminderId,
            title: 'Snoozed Reminder',
            body: _reminders[index].description,
            scheduledTime: snoozeUntil,
          );
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
