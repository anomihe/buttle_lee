import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DailyQuoteWidget extends StatefulWidget {
  const DailyQuoteWidget({super.key});

  @override
  State<DailyQuoteWidget> createState() => _DailyQuoteWidgetState();
}

class _DailyQuoteWidgetState extends State<DailyQuoteWidget> {
  late String _quote;
  late String _author;

  final List<Map<String, String>> _quotes = [
    {
      'quote': 'The best way to predict the future is to create it.',
      'author': 'Peter Drucker'
    },
    {
      'quote':
          'Your time is limited, don\'t waste it living someone else\'s life.',
      'author': 'Steve Jobs'
    },
    {
      'quote':
          'Productivity is being able to do things that you were never able to do before.',
      'author': 'Franz Kafka'
    },
    {
      'quote': 'Focus on being productive instead of busy.',
      'author': 'Tim Ferriss'
    },
    {
      'quote':
          'Small steps in the right direction can turn out to be the biggest step of your life.',
      'author': 'Unknown'
    },
    {
      'quote': 'Simplicity is the ultimate sophistication.',
      'author': 'Leonardo da Vinci'
    },
    {
      'quote':
          'Efficiency is doing things right; effectiveness is doing the right things.',
      'author': 'Peter Drucker'
    },
    {
      'quote':
          'Amateurs sit and wait for inspiration, the rest of us just get up and go to work.',
      'author': 'Stephen King'
    },
  ];

  @override
  void initState() {
    super.initState();
    _pickRandomQuote();
  }

  void _pickRandomQuote() {
    final random = Random();
    final index = random.nextInt(_quotes.length);
    setState(() {
      _quote = _quotes[index]['quote']!;
      _author = _quotes[index]['author']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.4),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Daily Inspiration',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _quote,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                    color:
                        isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "— $_author",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}
