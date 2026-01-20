import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class GamificationService {
  static const int xpPerTask = 50;
  static const int xpPerLevelBase = 100;
  static const double xpMultiplier = 1.5; // Exponential growth for levels

  /// Adds XP to a user and handles leveling up.
  /// Returns the updated UserProfile.
  static Future<UserProfile?> addXp(
      Session session, int userId, int amount) async {
    final userProfile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );

    if (userProfile == null) return null;

    userProfile.xp += amount;

    // Check for level up
    // Simple logic: Level N requires 100 * N * 1.5 XP?
    // Let's stick to a simpler threshold for now or just cumulative.
    // Let's say Level 1 -> 2 needs 100 XP.
    // Level 2 -> 3 needs 200 XP.
    // Total XP for Level L = 100 * L * (L-1) / 2 roughly?

    // Let's use a simple recursive check or loop
    var neededForNext = _xpRequiredForLevel(userProfile.level + 1);
    bool leveledUp = false;

    while (userProfile.xp >= neededForNext) {
      userProfile.level += 1;
      leveledUp = true;
      neededForNext = _xpRequiredForLevel(userProfile.level + 1);
    }

    await UserProfile.db.updateRow(session, userProfile);

    if (leveledUp) {
      session.log('User $userId leveled up to ${userProfile.level}!',
          level: LogLevel.info);
    }

    return userProfile;
  }

  static int _xpRequiredForLevel(int level) {
    // Level 2 needs 100 total XP
    // Level 3 needs 300 total XP (100 + 200)
    // Level 4 needs 600 total XP (100 + 200 + 300)
    if (level <= 1) return 0;
    return (level - 1) * 100 + _xpRequiredForLevel(level - 1);
  }
}
