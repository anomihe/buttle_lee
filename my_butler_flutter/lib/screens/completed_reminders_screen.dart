import 'package:flutter/material.dart';
import 'package:my_butler_client/my_butler_client.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../widgets/reminder_card.dart';

class CompletedRemindersScreen extends StatefulWidget {
  const CompletedRemindersScreen({super.key});

  @override
  State<CompletedRemindersScreen> createState() =>
      _CompletedRemindersScreenState();
}

class _CompletedRemindersScreenState extends State<CompletedRemindersScreen> {
  List<ButlerReminder> _completedReminders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedReminders();
  }

  Future<void> _loadCompletedReminders() async {
    setState(() => _isLoading = true);
    try {
      final reminders =
          await context.read<ReminderProvider>().loadCompletedReminders();
      setState(() {
        _completedReminders = reminders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCompletedReminders,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF0D2137),
                    const Color(0xFF0A1628),
                  ]
                : [
                    const Color(0xFFE8F5F3),
                    const Color(0xFFF5F9F8),
                  ],
          ),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : _completedReminders.isEmpty
                ? _buildEmptyState(context, isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _completedReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _completedReminders[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Opacity(
                          opacity: 0.7,
                          child: ReminderCard(
                            reminder: reminder,
                            onEdit: _loadCompletedReminders,
                            onDelete: () async {
                              await context
                                  .read<ReminderProvider>()
                                  .deleteReminder(reminder.id!);
                              _loadCompletedReminders();
                            },
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 48,
              color: isDark ? Colors.white30 : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No completed reminders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Executed reminders will appear here',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
