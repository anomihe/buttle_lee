import 'package:flutter/material.dart';
import 'package:my_butler_client/my_butler_client.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import 'edit_reminder_dialog.dart';

class ReminderCard extends StatelessWidget {
  final ButlerReminder reminder;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onDelete,
    this.onEdit,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inMinutes}m';
    }
  }

  IconData _getReminderTypeIcon() {
    switch (reminder.reminderType) {
      case ReminderType.daily:
        return Icons.today;
      case ReminderType.weekly:
        return Icons.calendar_view_week;
      case ReminderType.annual:
        return Icons.calendar_month;
      case ReminderType.once:
        return Icons.notifications;
    }
  }

  Color _getReminderTypeColor(BuildContext context) {
    switch (reminder.reminderType) {
      case ReminderType.daily:
        return Colors.blue;
      case ReminderType.weekly:
        return Colors.green;
      case ReminderType.annual:
        return Colors.purple;
      case ReminderType.once:
        return Colors.orange;
    }
  }

  Color _getPriorityColor() {
    switch (reminder.priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.blue;
    }
  }

  void _showSnoozeDialog(BuildContext context) {
    final reminderProvider = context.read<ReminderProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 16),
            const Text(
              'Snooze Reminder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('5 minutes'),
              onTap: () {
                final snoozeTime =
                    DateTime.now().add(const Duration(minutes: 5));
                Navigator.of(context).pop();
                reminderProvider.snoozeReminder(reminder.id!, snoozeTime);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('15 minutes'),
              onTap: () {
                final snoozeTime =
                    DateTime.now().add(const Duration(minutes: 15));
                Navigator.of(context).pop();
                reminderProvider.snoozeReminder(reminder.id!, snoozeTime);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('1 hour'),
              onTap: () {
                final snoozeTime = DateTime.now().add(const Duration(hours: 1));
                Navigator.of(context).pop();
                reminderProvider.snoozeReminder(reminder.id!, snoozeTime);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Tomorrow morning'),
              onTap: () {
                final now = DateTime.now();
                final snoozeTime =
                    DateTime(now.year, now.month, now.day + 1, 9, 0);
                Navigator.of(context).pop();
                reminderProvider.snoozeReminder(reminder.id!, snoozeTime);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeUntil = _formatDateTime(reminder.triggerTime);
    final formattedDate =
        DateFormat('MMM d, y • h:mm a').format(reminder.triggerTime);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getPriorityColor().withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getReminderTypeColor(context).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getReminderTypeIcon(),
                color: _getReminderTypeColor(context),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reminder.description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Priority badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getPriorityColor().withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          reminder.priority.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getPriorityColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Date
                  Text(
                    formattedDate,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tags row with Wrap to prevent overflow
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      // Time until
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 12,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              timeUntil,
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white60 : Colors.grey[600],
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              _getReminderTypeColor(context).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          reminder.reminderType.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getReminderTypeColor(context),
                          ),
                        ),
                      ),
                      // Snoozed indicator
                      if (reminder.snoozedUntil != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.snooze,
                                  size: 12, color: Colors.purple),
                              const SizedBox(width: 4),
                              Text(
                                'Snoozed',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons - vertical layout to save space
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showEditDialog(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit_outlined,
                          size: 18, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Snooze button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showSnoozeDialog(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.snooze,
                          size: 18, color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Delete button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showDeleteConfirmation(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline,
                          size: 18, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditReminderBottomSheet(reminder: reminder),
    ).then((_) {
      // Call onEdit callback after editing is done
      if (onEdit != null) {
        onEdit!();
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
