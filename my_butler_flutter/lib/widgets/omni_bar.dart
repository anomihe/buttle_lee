import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/reminder_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class OmniBar extends StatefulWidget {
  const OmniBar({super.key});

  @override
  State<OmniBar> createState() => OmniBarState();
}

class OmniBarState extends State<OmniBar> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _isProcessing = false;
  bool _isFocused = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Voice Input
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    // Listen to text changes to update UI (mic vs send button)
    _controller.addListener(() {
      setState(() {});
    });
    _initSpeech();

    // Subtle pulse animation for AI icon
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _initSpeech() async {
    try {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (errorNotification) {
          setState(() => _isListening = false);
          debugPrint('Speech error: $errorNotification');
        },
      );
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing speech: $e');
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_isFocused) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _pulseController.dispose();
    _speech.cancel();
    super.dispose();
  }

  void _listen() async {
    if (!_speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      HapticFeedback.mediumImpact();
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });

          if (result.finalResult) {
            // Auto-send after a pause
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted && _controller.text.isNotEmpty) {
                _processCommand();
              }
            });
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: "en_US",
        onSoundLevelChange: (level) {
          // Can use this to animate microphone if desired
        },
      );
    }
  }

  /// Public method to programmatically submit a command
  void submitCommand(String command) {
    _controller.text = command;
    _processCommand();
  }

  Future<void> _processCommand() async {
    // If listening, stop first
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }

    final command = _controller.text.trim();
    if (command.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final authProvider = context.read<AuthProvider>();

      // Add local time context for the AI
      final now = DateTime.now();
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      final contextString =
          '\n[System Context: User Local Time: ${DateFormat('HH:mm').format(now)}, Date: ${DateFormat('yyyy-MM-dd').format(now)}, Timezone: $timeZoneName]';

      final response = await authProvider.client.ai
          .processCommand('$command $contextString');

      setState(() => _isProcessing = false);
      _controller.clear();

      // Auto-refresh reminders if a reminder was likely created
      if (response.toLowerCase().contains('reminder') ||
          response.toLowerCase().contains('created')) {
        if (mounted) {
          context.read<ReminderProvider>().loadReminders();
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: _isFocused ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.9),
              border: Border.all(
                color: _isFocused
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                    : Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Animated AI Icon
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Text Input
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask Butler Lee anything...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black38,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) {
                      HapticFeedback.lightImpact();
                      _processCommand();
                    },
                    enabled: !_isProcessing,
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button or Mic Button
                if (_isProcessing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show Mic if text is empty OR if currently listening
                      if (_controller.text.isEmpty || _isListening)
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _listen,
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isListening
                                    ? Colors.redAccent.withOpacity(0.1)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isListening
                                    ? Icons.mic_off_rounded
                                    : Icons.mic_rounded,
                                color: _isListening
                                    ? Colors.redAccent
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black54),
                                size: 22,
                              ),
                            ),
                          ),
                        ),

                      // Show Send if text is NOT empty (and not listening, or alongside?)
                      // Let's show Send only if there is text.
                      if (_controller.text.isNotEmpty) ...[
                        if (_controller.text.isNotEmpty && _isListening)
                          const SizedBox(width: 4),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _processCommand();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.tertiary,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}
