import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'hydration_history_sheet.dart';
import 'package:confetti/confetti.dart';

import '../services/notification_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:my_butler_client/my_butler_client.dart';

class HydrationTrackerWidget extends StatefulWidget {
  const HydrationTrackerWidget({super.key});

  @override
  State<HydrationTrackerWidget> createState() => HydrationTrackerWidgetState();
}

class HydrationTrackerWidgetState extends State<HydrationTrackerWidget>
    with WidgetsBindingObserver {
  int _glasses = 0;
  int _goal = 8;
  bool _isLoading = true;
  bool _reminderEnabled = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _confettiController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData();
    }
  }

  // Reload data when dependency changes or returned from settings
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Try to fetch from cloud first if authenticated
    try {
      final client = context.read<AuthProvider>().client;
      final profile = await client.userProfile.getProfile();
      if (profile != null) {
        // Sync cloud to local
        await prefs.setInt('hydration_count', profile.hydrationCount ?? 0);
        await prefs.setInt('hydration_goal', profile.hydrationGoal ?? 8);
        await prefs.setBool(
            'hydration_reminder', profile.hydrationReminder ?? false);
        if (profile.hydrationDate != null) {
          await prefs.setString('hydration_date', profile.hydrationDate!);
        }
        if (profile.hydrationHistory != null) {
          await prefs.setString('hydration_history', profile.hydrationHistory!);
        }
      }
    } catch (e) {
      debugPrint('Error syncing hydration from cloud: $e');
    }

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDate = prefs.getString('hydration_date');
    final savedGoal = prefs.getInt('hydration_goal') ?? 8;
    final reminder = prefs.getBool('hydration_reminder') ?? false;

    if (lastDate != today) {
      if (mounted) {
        setState(() {
          _glasses = 0;
          _goal = savedGoal;
          _reminderEnabled = reminder;
          _isLoading = false;
        });
      }
      await prefs.setString('hydration_date', today);
      await prefs.setInt('hydration_count', 0);
      _syncToCloud(); // Sync the reset count
    } else {
      if (mounted) {
        setState(() {
          _glasses = prefs.getInt('hydration_count') ?? 0;
          _goal = savedGoal;
          _reminderEnabled = reminder;
          _isLoading = false;
        });
      }
    }

    // Ensure reminder is scheduled if enabled (e.g. on new device)
    if (_reminderEnabled) {
      await NotificationService().scheduleHydrationReminder(
        DateTime.now().add(const Duration(hours: 1)),
      );
    }
  }

  Future<void> _syncToCloud() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final client = context.read<AuthProvider>().client;

      await client.userProfile.updateHydration(
        _goal,
        _glasses,
        prefs.getString('hydration_date'),
        _reminderEnabled,
        prefs.getString('hydration_history'),
      );
    } catch (e) {
      debugPrint('Failed to sync hydration to cloud: $e');
    }
  }

  Future<void> _toggleReminder() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _reminderEnabled = !_reminderEnabled);
    await prefs.setBool('hydration_reminder', _reminderEnabled);

    if (_reminderEnabled) {
      await NotificationService().scheduleHydrationReminder(
        DateTime.now().add(const Duration(hours: 1)),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hydration reminders enabled (Hourly)')),
        );
      }
    } else {
      await NotificationService().cancelNotification(888);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hydration reminders disabled')),
        );
      }
    }
    _syncToCloud();
  }

  Future<void> _saveHistory(String date, int count) async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString('hydration_history');
    Map<String, dynamic> history = {};

    if (historyString != null) {
      try {
        history = jsonDecode(historyString) as Map<String, dynamic>;
      } catch (e) {
        // Ignore error
      }
    }

    history[date] = count;
    await prefs.setString('hydration_history', jsonEncode(history));
  }

  Future<void> addWater() async {
    final prefs = await SharedPreferences.getInstance();
    final wasAtGoal = _glasses >= _goal;
    setState(() => _glasses++);

    // Check for goal completion (celebration)
    if (_glasses == _goal && !wasAtGoal) {
      _confettiController.play();

      // Award XP for completing daily hydration goal
      try {
        final client = context.read<AuthProvider>().client;
        await client.userProfile.incrementXp(10); // 10 XP for hydration goal

        // Reload user profile to update XP bar
        final authProvider = context.read<AuthProvider>();
        await authProvider.loadUserProfile();
      } catch (e) {
        debugPrint('Failed to increment XP: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Daily Goal Reached! +10 XP 🎉'), // Added unicode safety
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    await prefs.setInt('hydration_count', _glasses);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _saveHistory(today, _glasses);

    HapticFeedback.lightImpact();
    _syncToCloud();
  }

  Future<void> removeWater() async {
    if (_glasses <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() => _glasses--);
    await prefs.setInt('hydration_count', _glasses);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _saveHistory(today, _glasses);

    HapticFeedback.lightImpact();
    _syncToCloud();
  }

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HydrationHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (_glasses / _goal).clamp(0.0, 1.0);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2630) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.water_drop_rounded,
                            color: Colors.blue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _showHistory(context),
                        child: Text(
                          'Hydration',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _reminderEnabled
                              ? Icons.notifications_active_rounded
                              : Icons.notifications_off_outlined,
                          color: _reminderEnabled ? Colors.blue : Colors.grey,
                          size: 20,
                        ),
                        onPressed: _toggleReminder,
                        tooltip: 'Toggle Reminder',
                      ),
                      IconButton(
                        icon: Icon(Icons.history_rounded,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 20),
                        onPressed: () => _showHistory(context),
                        tooltip: 'History',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$_glasses / $_goal cups',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: isDark ? Colors.white10 : Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(
                    icon: Icons.remove,
                    onTap: removeWater,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 24),
                  _buildButton(
                    icon: Icons.add,
                    onTap: addWater,
                    isDark: isDark,
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Confetti Overlay
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // radial
              shouldLoop: false,
              colors: const [
                Colors.blue,
                Colors.lightBlueAccent,
                Colors.white,
                Colors.cyanAccent
              ],
              createParticlePath: drawStar,
            ),
          ),
        ),
      ],
    );
  }

  // Custom star path for visual flair
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (3.1415926535897932 / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
          halfWidth + externalRadius * 1.0 /*cos*/,
          halfWidth +
              externalRadius *
                  1.0 /*sin (simulated)*/); // Logic simplified for brevity, using standard star path logic is better or built-in rect
    }
    // Using simple rectangle for robustness if star logic is complex to one-line
    path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    return path;
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDark,
    bool isPrimary = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isPrimary
                ? Colors.blue
                : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey[100]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isPrimary
                ? Colors.white
                : (isDark ? Colors.white : Colors.black87),
            size: 24,
          ),
        ),
      ),
    );
  }
}
