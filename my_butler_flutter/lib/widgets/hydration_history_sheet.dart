import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class HydrationHistorySheet extends StatefulWidget {
  const HydrationHistorySheet({super.key});

  @override
  State<HydrationHistorySheet> createState() => _HydrationHistorySheetState();
}

class _HydrationHistorySheetState extends State<HydrationHistorySheet> {
  Map<String, int> _history = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('hydration_history');
    if (historyString != null) {
      try {
        final decoded = jsonDecode(historyString) as Map<String, dynamic>;
        setState(() {
          _history = decoded.map((k, v) => MapEntry(k, v as int));
          _isLoading = false;
        });
      } catch (e) {
        debugPrint('Error decoding hydration history: $e');
        setState(() => _isLoading = false);
      }
    } else {
      // Fallback: check legacy single-day if history is empty
      final date = prefs.getString('hydration_date');
      final count = prefs.getInt('hydration_count');
      if (date != null && count != null) {
        setState(() {
          _history = {date: count};
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  void _shareEntry(String dateStr, int count) {
    // Parse date for prettier format
    final date = DateFormat('yyyy-MM-dd').parse(dateStr);
    final prettyDate = DateFormat('MMMM d').format(date); // e.g., January 20

    Share.share(
        'Hey! I drank $count cups of water on $prettyDate! 💧 Can you beat my streak? #Hydration #ButlerLee');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort keys descending (newest first)
    final sortedKeys = _history.keys.toList()..sort((a, b) => b.compareTo(a));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2630) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.history_rounded, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Hydration History',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : sortedKeys.isEmpty
                      ? Center(
                          child: Text(
                            'No history yet. Start drinking! 💧',
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: sortedKeys.length,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemBuilder: (context, index) {
                            final dateKey = sortedKeys[index];
                            final count = _history[dateKey]!;
                            final date =
                                DateFormat('yyyy-MM-dd').parse(dateKey);
                            final isToday = dateKey ==
                                DateFormat('yyyy-MM-dd').format(DateTime.now());

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.grey.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: isToday
                                    ? Border.all(
                                        color: Colors.blue.withOpacity(0.3))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          isToday
                                              ? 'Today'
                                              : DateFormat('EEEE, MMM d')
                                                  .format(date),
                                          style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '$count cups',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _shareEntry(dateKey, count),
                                    icon: const Icon(Icons.share_rounded,
                                        size: 20),
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    tooltip: 'Share',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
