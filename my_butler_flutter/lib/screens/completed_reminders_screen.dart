import 'package:flutter/material.dart';
import 'package:my_butler_client/my_butler_client.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
          color: Theme.of(context).scaffoldBackgroundColor, // Clean background
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : _completedReminders.isEmpty
                ? _buildEmptyState(context, isDark)
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    itemCount: _completedReminders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reminder = _completedReminders[index];
                      // Use a simplified card view for history
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                shape: BoxShape.circle),
                            child: const Icon(Icons.check,
                                color: Colors.green, size: 20),
                          ),
                          title: Text(
                            reminder.description,
                            style: GoogleFonts.outfit(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Completed", // Could add date here if we tracked completion date explicitly
                            style: GoogleFonts.outfit(
                                fontSize: 12, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                size: 20, color: Colors.redAccent),
                            onPressed: () async {
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
          Icon(Icons.history_edu_outlined,
              size: 64, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            "No history yet",
            style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
