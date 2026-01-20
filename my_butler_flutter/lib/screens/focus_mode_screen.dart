import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  late AnimationController _breathingController;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.initialMinutes * 60;

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _timer.cancel();
            _breathingController.stop();
            // TODO: Play completion sound or vibration
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _breathingController.dispose();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Give Up Button
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Give Up',
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
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
