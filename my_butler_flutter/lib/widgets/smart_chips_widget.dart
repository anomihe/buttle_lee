import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SmartChipsWidget extends StatelessWidget {
  final Function(String) onActionSelected;
  final VoidCallback? onFocusSelected;

  const SmartChipsWidget({
    super.key,
    required this.onActionSelected,
    this.onFocusSelected,
  });

  final List<(String label, String icon, String command)> _actions = const [
    ('Morning', '☀️', 'Start my morning routine'),
    ('Focus', '🎯', 'Focus for 25 minutes'),
    ('Water', '💧', 'Log water intake'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final action = _actions[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                if (action.$1 == 'Focus' && onFocusSelected != null) {
                  onFocusSelected!();
                } else {
                  onActionSelected(action.$3);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.black.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(action.$2), // Icon/Emoji
                    const SizedBox(width: 6),
                    Text(
                      action.$1,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate(delay: (100 * index).ms)
              .fadeIn()
              .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }
}
