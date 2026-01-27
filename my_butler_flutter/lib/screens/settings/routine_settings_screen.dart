import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../services/notification_service.dart';

class HabitSettingsScreen extends StatefulWidget {
  const HabitSettingsScreen({super.key});

  @override
  State<HabitSettingsScreen> createState() => _HabitSettingsScreenState();
}

class _HabitSettingsScreenState extends State<HabitSettingsScreen> {
  bool _isLoading = true;

  // Journal Settings
  bool _journalEnabled = false;
  int _journalInterval = 24; // Hours

  // Book Settings
  bool _bookEnabled = false;
  int _bookInterval = 24; // Hours

  // Focus Settings
  int _focusDuration = 25; // Minutes
  bool _focusReminderEnabled = false;
  int _focusReminderInterval = 4; // Hours

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final client = context.read<AuthProvider>().client;

    try {
      // Load local prefs first for new fields
      _focusReminderEnabled = prefs.getBool('focus_reminder_enabled') ?? false;
      _focusReminderInterval = prefs.getInt('focus_reminder_interval') ?? 4;

      final profile = await client.userProfile.getProfile();
      if (profile != null) {
        if (mounted) {
          setState(() {
            _journalEnabled = profile.journalReminder ?? false;
            _journalInterval = profile.journalInterval ?? 24;
            _bookEnabled = profile.bookReminder ?? false;
            _bookInterval = profile.bookInterval ?? 24;
            // Map focus duration from server
            _focusDuration = profile.focusModeDuration ?? 25;

            _isLoading = false;
          });
        }
        // Sync to local prefs
        await prefs.setBool('journal_enabled', _journalEnabled);
        await prefs.setInt('journal_interval', _journalInterval);
        await prefs.setBool('book_enabled', _bookEnabled);
        await prefs.setInt('book_interval', _bookInterval);
        await prefs.setInt('focus_duration', _focusDuration);
      }
    } catch (e) {
      // Fallback to local
      setState(() {
        _journalEnabled = prefs.getBool('journal_enabled') ?? false;
        _journalInterval = prefs.getInt('journal_interval') ?? 24;
        _bookEnabled = prefs.getBool('book_enabled') ?? false;
        _bookInterval = prefs.getInt('book_interval') ?? 24;
        _focusDuration = prefs.getInt('focus_duration') ?? 25;
        // Focus reminder already loaded above
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final client = context.read<AuthProvider>().client;

    // Save to server (Existing fields only)
    try {
      await client.userProfile.updateRoutineSettings(
        _journalEnabled,
        _journalInterval,
        _bookEnabled,
        _bookInterval,
        _focusDuration,
      );
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }

    // Save local
    await prefs.setBool('journal_enabled', _journalEnabled);
    await prefs.setInt('journal_interval', _journalInterval);
    await prefs.setBool('book_enabled', _bookEnabled);
    await prefs.setInt('book_interval', _bookInterval);
    await prefs.setInt('focus_duration', _focusDuration);

    // Save new Focus fields
    await prefs.setBool('focus_reminder_enabled', _focusReminderEnabled);
    await prefs.setInt('focus_reminder_interval', _focusReminderInterval);

    // Schedule/Cancel Notifications
    _updateNotifications();
  }

  void _updateNotifications() async {
    // Journal
    if (_journalEnabled) {
      await NotificationService().scheduleRecurrentReminder(
        id: 777,
        title: 'Journal Time 📔',
        body: 'Take a moment to reflect on your day.',
        interval: Duration(hours: _journalInterval),
      );
    } else {
      await NotificationService().cancelNotification(777);
    }

    // Reading
    if (_bookEnabled) {
      await NotificationService().scheduleRecurrentReminder(
        id: 666,
        title: 'Reading Time 📖',
        body: 'Immerse yourself in a good book for a while.',
        interval: Duration(hours: _bookInterval),
      );
    } else {
      await NotificationService().cancelNotification(666);
    }

    // Focus
    if (_focusReminderEnabled) {
      await NotificationService().scheduleRecurrentReminder(
        id: 555,
        title: 'Time to Focus 🧘',
        body: 'Ready to get into the zone? Start a focus session now.',
        interval: Duration(hours: _focusReminderInterval),
      );
    } else {
      await NotificationService().cancelNotification(555);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Routine Settings',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Mindfulness & Habits'),
          const SizedBox(height: 16),

          // Journal Card
          _buildSettingCard(
            title: 'Journaling',
            icon: Icons.book_outlined,
            color: Colors.brown,
            value: _journalEnabled,
            onToggle: (val) {
              setState(() => _journalEnabled = val);
              _saveSettings();
            },
            child: _journalEnabled
                ? _buildTimeSelector(
                    'Remind me every',
                    _journalInterval,
                    (val) {
                      setState(() => _journalInterval = val);
                      _saveSettings();
                    },
                    isHours: true,
                  )
                : null,
          ),

          const SizedBox(height: 16),

          // Reading Card
          _buildSettingCard(
            title: 'Reading',
            icon: Icons.menu_book_rounded,
            color: Colors.deepPurple,
            value: _bookEnabled,
            onToggle: (val) {
              setState(() => _bookEnabled = val);
              _saveSettings();
            },
            child: _bookEnabled
                ? _buildTimeSelector(
                    'Remind me every',
                    _bookInterval,
                    (val) {
                      setState(() => _bookInterval = val);
                      _saveSettings();
                    },
                    isHours: true,
                  )
                : null,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Focus Mode'),
          const SizedBox(height: 16),

          // Focus Reminder Card
          _buildSettingCard(
            title: 'Focus Check-in',
            icon: Icons.notifications_active_outlined,
            color: Colors.indigo,
            value: _focusReminderEnabled,
            onToggle: (val) {
              setState(() => _focusReminderEnabled = val);
              _saveSettings();
            },
            child: _focusReminderEnabled
                ? _buildTimeSelector(
                    'Remind me every',
                    _focusReminderInterval,
                    (val) {
                      setState(() => _focusReminderInterval = val);
                      _saveSettings();
                    },
                    isHours: true,
                  )
                : null,
          ),

          const SizedBox(height: 16),

          // Focus Duration Card (Existing but updated style)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .cardColor
                  .withOpacity(0.5), // Uniform background
              borderRadius: BorderRadius.circular(20),
              // Remove shadow for flatter/uniform look or keep it?
              // The user said "uniform with other screens". SettingsTab uses elevation 0 and opacity.
              // I'll match that.
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.timer, color: Colors.indigo),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Default Duration',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '$_focusDuration min',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_focusDuration > 5) {
                          setState(() => _focusDuration -= 5);
                          _saveSettings();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        if (_focusDuration < 120) {
                          setState(() => _focusDuration += 5);
                          _saveSettings();
                        }
                      },
                    ),
                  ],
                ),
                Slider(
                  value: _focusDuration.toDouble(),
                  min: 5,
                  max: 120,
                  divisions: 23,
                  label: '$_focusDuration min',
                  onChanged: (val) {
                    setState(() => _focusDuration = val.toInt());
                  },
                  onChangeEnd: (val) => _saveSettings(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required Color color,
    required bool value,
    required Function(bool) onToggle,
    Widget? child,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            Theme.of(context).cardColor.withOpacity(0.5), // Uniform background
        borderRadius: BorderRadius.circular(20),
        // Removed heavy shadow to match SettingsTab style
        border:
            value ? Border.all(color: color.withOpacity(0.5), width: 2) : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onToggle,
                activeColor: color,
              ),
            ],
          ),
          if (child != null && value) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, int value, Function(int) onChanged,
      {bool isHours = false}) {
    // Generate menu items
    List<int> items = isHours ? [1, 2, 4, 6, 8, 12, 24, 48] : [30, 60, 90, 120];

    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        DropdownButton<int>(
          value: items.contains(value) ? value : items.first, // Safety check
          underline: const SizedBox(),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      isHours ? '$e ${e == 1 ? "hour" : "hours"}' : '$e min',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    );
  }
}
