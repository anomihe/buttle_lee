import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/gamification_helper.dart';

class LevelProgressWidget extends StatelessWidget {
  final int xp;
  final int level;
  final bool isDark;

  const LevelProgressWidget({
    super.key,
    required this.xp,
    required this.level,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progress = GamificationHelper.getProgress(xp, level);
    final xpToNext = GamificationHelper.getXpToNextLevel(xp, level);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.white24,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Level $level',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6), // Reduced from 8
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('How to Earn XP ⚡️'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• Complete a task: +10 XP'),
                                Text('• Finish a focus session: +50 XP'),
                                Text('• Log water intake: +5 XP'),
                                Text('• Daily check-in: +20 XP'),
                                SizedBox(height: 10),
                                Text(
                                    'Level up to unlock new badges and features!'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Got it!'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 16,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Share.share(
                          'I just reached Level $level with $xp XP on Butler Lee! 🚀\n#ButlerLee #Productivity #LevelUp',
                          subject: 'My Butler Lee Stats',
                        );
                      },
                      child: Icon(
                        Icons.share_rounded,
                        size: 16,
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Row(
                mainAxisSize: MainAxisSize.min, // Ensure it takes minimum space
                children: [
                  const Icon(Icons.bolt, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Flexible(
                    // Allow text to shrink if absolutely necessary
                    child: Text(
                      '$xp XP',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$xpToNext XP to next level',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }
}
