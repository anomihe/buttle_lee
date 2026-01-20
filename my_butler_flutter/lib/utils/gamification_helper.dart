class GamificationHelper {
  static const int xpPerTask = 50;

  static int xpRequiredForLevel(int level) {
    if (level <= 1) return 0;
    // Level 2 needs 100 total XP
    // Level 3 needs 300 total XP (100 + 200)
    return (level - 1) * 100 + xpRequiredForLevel(level - 1);
  }

  static double getProgress(int currentXp, int currentLevel) {
    final currentLevelBaseXp = xpRequiredForLevel(currentLevel);
    final nextLevelBaseXp = xpRequiredForLevel(currentLevel + 1);

    final xpInCurrentLevel = currentXp - currentLevelBaseXp;
    final xpNeededForNextLevel = nextLevelBaseXp - currentLevelBaseXp;

    if (xpNeededForNextLevel == 0) return 1.0;

    return (xpInCurrentLevel / xpNeededForNextLevel).clamp(0.0, 1.0);
  }

  static int getXpToNextLevel(int currentXp, int currentLevel) {
    final nextLevelBaseXp = xpRequiredForLevel(currentLevel + 1);
    return nextLevelBaseXp - currentXp;
  }
}
