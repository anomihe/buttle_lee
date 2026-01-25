import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class UserProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<UserProfile?> getProfile(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return null;
    final userId = authInfo.userId;

    return await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );
  }

  Future<void> updateHydration(Session session, int goal, int count,
      String? date, bool reminder, String? history, int? interval) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    var profile = await UserProfile.db
        .findFirstRow(session, where: (t) => t.userInfoId.equals(userId));
    if (profile != null) {
      profile.hydrationGoal = goal;
      profile.hydrationCount = count;
      profile.hydrationDate = date;
      profile.hydrationReminder = reminder;
      profile.hydrationHistory = history;
      if (interval != null) profile.hydrationInterval = interval;

      await UserProfile.db.updateRow(session, profile);
    }
  }

  Future<void> updateRoutineSettings(
      Session session,
      bool journalReminder,
      int journalInterval,
      bool bookReminder,
      int bookInterval,
      int focusModeDuration) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    var profile = await UserProfile.db
        .findFirstRow(session, where: (t) => t.userInfoId.equals(userId));
    if (profile != null) {
      profile.journalReminder = journalReminder;
      profile.journalInterval = journalInterval;
      profile.bookReminder = bookReminder;
      profile.bookInterval = bookInterval;
      profile.focusModeDuration = focusModeDuration;

      await UserProfile.db.updateRow(session, profile);
    }
  }

  Future<void> updateFocusStats(
      Session session, int completed, int givenUp) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    var profile = await UserProfile.db
        .findFirstRow(session, where: (t) => t.userInfoId.equals(userId));
    if (profile != null) {
      profile.focusCompleted = completed;
      profile.focusGivenUp = givenUp;
      await UserProfile.db.updateRow(session, profile);
    }
  }

  /// Increment user XP by a specified amount
  Future<void> incrementXp(Session session, int amount) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    var profile = await UserProfile.db
        .findFirstRow(session, where: (t) => t.userInfoId.equals(userId));
    if (profile != null) {
      profile.xp = profile.xp + amount;
      await UserProfile.db.updateRow(session, profile);
    }
  }
}
