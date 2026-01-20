import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class AnalyticsEndpoint extends Endpoint {
  /// Returns a map of DayOfWeek -> Completion Count for the last 7 days
  Future<Map<String, int>> getWeeklyProductivity(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    final userId = authInfo.userId;

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Fetch completed reminders in the last 7 days
    // Note: This is an unoptimized query if there are thousands, but fine for now.
    final completed = await ButlerReminder.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.isActive.equals(false) &
          t.triggerTime.between(sevenDaysAgo, now),
    );

    final Map<String, int> stats = {};
    // Initialize with 0
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      stats[_getDayName(day.weekday)] = 0;
    }

    // Populate
    for (final reminder in completed) {
      final dayName = _getDayName(reminder.triggerTime.weekday);
      stats[dayName] = (stats[dayName] ?? 0) + 1;
    }

    return stats;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
