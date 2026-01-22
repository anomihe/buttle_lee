import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/notification_service.dart';
import '../providers/reminder_provider.dart';
import '../providers/auth_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';

class FocusModeScreen extends StatefulWidget {
  final int initialMinutes;

  const FocusModeScreen({super.key, this.initialMinutes = 25});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  bool _isPaused = false;
  bool _isCompleted = false;
  late AnimationController _breathingController;

  static const platform = MethodChannel('com.example.my_butler/dnd');

  @override
  void initState() {
    super.initState();
    // Enable Immersive sticky mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Enable Wakelock to keep screen on
    WakelockPlus.enable();

    // Set screen brightness to low (application level)
    _setLowBrightness();

    _remainingSeconds = widget.initialMinutes * 60;

    SharedPreferences.getInstance().then((prefs) {
      if (mounted) {
        final savedMinutes = prefs.getInt('focus_duration_minutes') ?? 25;
        setState(() {
          _remainingSeconds = savedMinutes * 60;
        });
      }
    });

    // Silence notifications (Butler DND)
    Future.microtask(() {
      if (mounted) {
        NotificationService().cancelAll();
        _setDND(true); // Enable Android DND
      }
    });

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _startTimer();
  }

  Future<void> _setLowBrightness() async {
    try {
      // Set to very low but visible
      await ScreenBrightness().setApplicationScreenBrightness(0.05);
    } catch (e) {
      debugPrint('Error setting brightness: $e');
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      // Reset application brightness to system default
      await ScreenBrightness().resetApplicationScreenBrightness();
    } catch (e) {
      debugPrint('Error restoring brightness: $e');
    }
  }

  Future<void> _setDND(bool enable) async {
    try {
      final success = await platform.invokeMethod('setDND', {'enable': enable});
      if (!success && enable && mounted) {
        // Permission not granted, settings opened.
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Please grant Do Not Disturb access to Butler Lee for Focus Mode.')));
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to set DND: '${e.message}'.");
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && !_isCompleted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer.cancel();
            _breathingController.stop();
            _completeSession();
          }
        });
      }
    });
  }

  void _completeSession() {
    setState(() => _isCompleted = true);
    HapticFeedback.heavyImpact();
    Future.delayed(
        const Duration(milliseconds: 500), () => HapticFeedback.heavyImpact());
    Future.delayed(
        const Duration(milliseconds: 1000), () => HapticFeedback.heavyImpact());

    // Play sound
    try {
      final player = AudioPlayer();
      player.play(AssetSource('crowd-cheer-ii-6263.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _breathingController.dispose();

    // Disable Wakelock
    WakelockPlus.disable();

    // Restore Brightness
    _restoreBrightness();

    // Restore System UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Disable DND
    _setDND(false);

    // Restore notifications
    try {
      if (mounted) {
        context.read<ReminderProvider>().rescheduleAllReminders();
      }
    } catch (e) {
      debugPrint('Could not Restore reminders on dispose: $e');
    }

    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Ambient Background
          AnimatedBuilder(
            animation: _breathingController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5 + (_breathingController.value * 0.2),
                    colors: [
                      Colors.blueGrey.shade900,
                      Colors.black,
                    ],
                  ),
                ),
              );
            },
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.self_improvement_rounded,
                    size: 48, color: Colors.white54),
                const SizedBox(height: 40),

                // Timer Text with Glow
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    shadows: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ).animate().fadeIn(duration: 800.ms),

                const SizedBox(height: 60),

                // Controls
                if (_isCompleted) ...[
                  Text(
                    'Focus Session Complete!',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthProvider>().updateFocusStats(1, 0);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.outfit(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ).animate().scale(),
                ] else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Give Up Button
                      TextButton(
                        onPressed: () {
                          context.read<AuthProvider>().updateFocusStats(0, 1);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Give Up',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.4)),
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Pause/Resume
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        },
                        icon: Icon(
                            _isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            color: Colors.white70,
                            size: 40),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
