import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/persona_provider.dart';
import '../providers/auth_provider.dart';
import 'edit_profile_screen.dart';
import 'routine_settings_screen.dart';
import 'settings/routine_settings_screen.dart'; // For HabitSettingsScreen

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    final personaProvider = context.watch<PersonaProvider>();
    final authProvider = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader('Appearance'),
        _buildTile(
          context,
          icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          title: 'Dark Mode',
          trailing: Switch(
            value: isDark,
            onChanged: (_) => personaProvider.toggleDarkMode(),
          ),
        ),
        _buildTile(
          context,
          icon: Icons.tune_rounded,
          title: 'Butler Persona',
          subtitle: personaProvider.modeDisplayName,
          onTap: () => _showPersonaMenu(context, personaProvider),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Wellness'),
        FutureBuilder<int>(
          future: SharedPreferences.getInstance()
              .then((prefs) => prefs.getInt('hydration_goal') ?? 8),
          builder: (context, snapshot) {
            final goal = snapshot.data ?? 8;
            return _buildTile(
              context,
              icon: Icons.water_drop_rounded,
              title: 'Hydration Goal',
              subtitle: '$goal cups daily',
              onTap: () => _showHydrationGoalPicker(context, goal),
            );
          },
        ),
        // Focus History
        if (authProvider.userProfile != null)
          _buildTile(
            context,
            icon: Icons.history_rounded,
            title: 'Focus History',
            subtitle:
                '${authProvider.userProfile!.focusCompleted} completed · ${authProvider.userProfile!.focusGivenUp} given up',
            onTap: null, // Just display for now
          ),
        FutureBuilder<int>(
          future: SharedPreferences.getInstance()
              .then((prefs) => prefs.getInt('focus_duration_minutes') ?? 25),
          builder: (context, snapshot) {
            final duration = snapshot.data ?? 25;
            return _buildTile(
              context,
              icon: Icons.timer_rounded,
              title: 'Focus Duration',
              subtitle: '$duration minutes',
              onTap: () => _showFocusDurationPicker(context, duration),
            );
          },
        ),
        _buildTile(
          context,
          icon: Icons.checklist_rtl_rounded,
          title: 'Daily Checklists',
          subtitle: 'Morning, Afternoon, Evening lists',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RoutineSettingsScreen(),
            ),
          ),
        ),
        _buildTile(
          context,
          icon: Icons.notifications_active_rounded,
          title: 'Habit Reminders',
          subtitle: 'Journal, Reading, Focus notifications',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HabitSettingsScreen(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionHeader('Account'),
        _buildTile(
          context,
          icon: Icons.person_rounded,
          title: 'Edit Profile',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditProfileScreen(),
            ),
          ),
        ),
        _buildTile(
          context,
          icon: Icons.logout_rounded,
          title: 'Logout',
          onTap: () => authProvider.logout(),
          isDestructive: true,
        ),
        const SizedBox(height: 48),
        Center(
          child: Text(
            'Butler Lee v1.0.0',
            style: GoogleFonts.outfit(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Future<void> _showHydrationGoalPicker(
      BuildContext context, int currentGoal) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Load prefs upfront to avoid FutureBuilder reset issues
    final prefs = await SharedPreferences.getInstance();
    bool remindersEnabled =
        prefs.getBool('hydration_reminders_enabled') ?? true;
    int interval = prefs.getInt('hydration_interval') ?? 60;
    int tempGoal = currentGoal;

    if (!context.mounted) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2630) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            // Prevent Overflow
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Daily Water Goal',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (tempGoal > 1) setModalState(() => tempGoal--);
                      },
                      icon: Icon(Icons.remove_circle_outline_rounded,
                          color: isDark ? Colors.white70 : Colors.black54),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$tempGoal cups',
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        setModalState(() => tempGoal++);
                      },
                      icon: Icon(Icons.add_circle_outline_rounded,
                          color: isDark ? Colors.white70 : Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Reminders Toggle & Interval
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Hydration Reminders',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  value: remindersEnabled,
                  onChanged: (val) async {
                    remindersEnabled = val;
                    await prefs.setBool('hydration_reminders_enabled', val);
                    setModalState(() {});
                  },
                ),
                if (remindersEnabled) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Frequency',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildIntervalButton(context, 30, interval, isDark,
                          (val) async {
                        interval = val;
                        await prefs.setInt('hydration_interval', val);
                        setModalState(() {});
                      }),
                      _buildIntervalButton(context, 60, interval, isDark,
                          (val) async {
                        interval = val;
                        await prefs.setInt('hydration_interval', val);
                        setModalState(() {});
                      }),
                      _buildIntervalButton(context, 90, interval, isDark,
                          (val) async {
                        interval = val;
                        await prefs.setInt('hydration_interval', val);
                        setModalState(() {});
                      }),
                    ],
                  ),
                ],

                const SizedBox(height: 24),
                Text(
                  'Recommended: 8 cups/day',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await prefs.setInt('hydration_goal', tempGoal);
                      if (context.mounted) {
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Save Goal',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper inside the method (or class) for buttons
  Widget _buildIntervalButton(BuildContext context, int minutes,
      int currentInterval, bool isDark, Function(int) onTap) {
    final isSelected = currentInterval == minutes;
    return InkWell(
      onTap: () => onTap(minutes),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : (isDark ? Colors.white12 : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$minutes m',
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _showFocusDurationPicker(
      BuildContext context, int currentDuration) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    int tempDuration = currentDuration;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2630) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Focus Session Length',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (tempDuration > 5) {
                        setModalState(() => tempDuration -= 5);
                      }
                    },
                    icon: Icon(Icons.remove_circle_outline_rounded,
                        color: isDark ? Colors.white70 : Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$tempDuration min',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      if (tempDuration < 120) {
                        setModalState(() => tempDuration += 5);
                      }
                    },
                    icon: Icon(Icons.add_circle_outline_rounded,
                        color: isDark ? Colors.white70 : Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('focus_duration_minutes', tempDuration);
                    if (context.mounted) {
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Save Duration',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : null,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: GoogleFonts.outfit())
            : null,
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right_rounded, size: 20)
                : null),
        onTap: onTap,
      ),
    );
  }

  void _showPersonaMenu(BuildContext context, PersonaProvider provider) {
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
                    borderRadius: BorderRadius.circular(2))),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Select Persona',
                    style: GoogleFonts.outfit(
                        fontSize: 18, fontWeight: FontWeight.bold))),
            ...PersonaMode.values.map((mode) => ListTile(
                  leading: Icon(provider.getIconForMode(mode)),
                  title: Text(provider.getNameForMode(mode)),
                  onTap: () {
                    provider.setPersona(mode);
                    Navigator.pop(context);
                  },
                  selected: provider.currentPersona == mode,
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
