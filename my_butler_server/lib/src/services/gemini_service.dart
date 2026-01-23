import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../endpoints/reminder_endpoint.dart';

/// Service for integrating with Google Gemini API
class GeminiService {
  final Session session;

  GeminiService(this.session);

  /// Process a natural language command
  Future<String> processCommand(String command, int userId) async {
    final apiKey = session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) {
      return 'Gemini API key not configured. Please add it to your passwords.yaml file.';
    }

    try {
      // Call Gemini API to parse the command
      final intent = await _parseCommandWithGemini(command, apiKey);

      // Handle different intents
      if (intent['action'] == 'create_reminder') {
        return await _handleCreateReminder(intent, userId);
      } else if (intent['action'] == 'query_reminders') {
        return await _handleQueryReminders(intent, userId);
      } else {
        return intent['response'] ?? 'I\'m not sure how to help with that.';
      }
    } catch (e) {
      session.log('Error in Gemini service: $e');
      return 'Sorry, I encountered an error processing your request.';
    }
  }

  /// Parse command using Gemini API
  Future<Map<String, dynamic>> _parseCommandWithGemini(
    String command,
    String apiKey,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
    );

    final now = DateTime.now();
    final dateContext = "Today is ${_formatDate(now)}.";

    final prompt = '''
You are Butler Lee, a helpful, intelligent, and chatty AI butler. 
$dateContext
Current time: ${now.hour}:${now.minute.toString().padLeft(2, '0')}
Your goal is to assist the user with their daily tasks, reminders, and questions.
Be conversational and engaging. Don't be too brief; explain your thoughts or offer extra helpful advice. 
However, if the user explicitly asks to set a reminder or query reminders, you MUST extract that intent accurately.

Parse the following command and extract the intent.

Command: "$command"

Respond with a JSON object containing:
- "action": one of "create_reminder", "query_reminders", or "general"
- For create_reminder: "description", "time" (ISO 8601 format), "type" (daily/weekly/annual/once), "priority" (high/medium/low)
- For query_reminders: "query_type" (next/all/today)
- For general: "response" (a conversational, helpful text response)

TIME PARSING RULES (CRITICAL):
1. Relative times:
   - "in X minutes" → add X minutes to current time
   - "in X hours" → add X hours to current time
   - "in the next X minutes/hours" → same as above
   - "in X days" → add X days to current date, use same time or specified time
   
2. Specific times today:
   - "at 3 PM", "at 15:00" → today at that time (if not passed, else tomorrow)
   
3. Tomorrow:
   - "tomorrow" → next day, default to 9:00 AM unless time specified
   - "tomorrow at 3 PM" → next day at 15:00
   
4. Day of week:
   - "Monday", "next Monday" → upcoming Monday at 9:00 AM unless time specified

5. Always return ISO 8601 format for "time" field:
   - Full datetime: "2026-01-23T15:30:00"
   - Time only (for today): "15:30" (will be converted to today's date)

Priority detection rules:
- "urgent", "important", "critical", "asap" → high
- "low priority", "not urgent", "whenever" → low
- Default → medium

Examples:
"Remind me to eat every day at 1 PM" → {"action": "create_reminder", "description": "eat", "time": "13:00", "type": "daily", "priority": "medium"}
"Remind me to test in 2 minutes" → {"action": "create_reminder", "description": "test", "time": "${now.add(Duration(minutes: 2)).toIso8601String()}", "type": "once", "priority": "medium"}
"Remind me in the next 5 minutes to check email" → {"action": "create_reminder", "description": "check email", "time": "${now.add(Duration(minutes: 5)).toIso8601String()}", "type": "once", "priority": "medium"}
"Remind me in 1 hour to call mom" → {"action": "create_reminder", "description": "call mom", "time": "${now.add(Duration(hours: 1)).toIso8601String()}", "type": "once", "priority": "medium"}
"Remind me tomorrow at 3 PM to submit report" → {"action": "create_reminder", "description": "submit report", "time": "${now.add(Duration(days: 1)).toIso8601String().split('T')[0]}T15:00:00", "type": "once", "priority": "medium"}
"Urgent reminder to call the doctor at 3 PM" → {"action": "create_reminder", "description": "call the doctor", "time": "15:00", "type": "once", "priority": "high"}
"When is my next meeting?" → {"action": "query_reminders", "query_type": "next"}
"What should I do today?" → {"action": "general", "response": "Well, today is ${_formatDate(now)}. It's a great day to focus on your goals! You have a few reminders coming up..."}

Respond ONLY with valid JSON, no other text.
''';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];

      // Extract JSON from response (Gemini might wrap it in markdown)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        return jsonDecode(jsonMatch.group(0)!);
      }

      return {'action': 'general', 'response': text};
    } else {
      throw Exception('Gemini API error: ${response.statusCode}');
    }
  }

  /// Handle creating a reminder from parsed intent
  Future<String> _handleCreateReminder(
    Map<String, dynamic> intent,
    int userId,
  ) async {
    try {
      // Safely extract fields with null checks
      final description = intent['description'] as String?;
      final timeStr = intent['time'] as String?;
      final typeStr = intent['type'] as String? ?? 'once';

      if (description == null || description.isEmpty) {
        return 'I couldn\'t understand what to remind you about. Please try again with more details.';
      }

      if (timeStr == null || timeStr.isEmpty) {
        return 'I couldn\'t understand when to set the reminder. Please include a time like "at 3 PM" or "tomorrow at noon".';
      }

      // Parse time
      DateTime triggerTime;
      try {
        if (timeStr.contains('T')) {
          // Full ISO 8601 datetime
          triggerTime = DateTime.parse(timeStr);
        } else {
          // Time only (HH:MM), use today's date
          final parts = timeStr.split(':');
          if (parts.length < 2) {
            return 'I couldn\'t parse the time "$timeStr". Please use a format like "3 PM" or "15:00".';
          }
          final now = DateTime.now();
          triggerTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          );

          // If time has passed today, schedule for tomorrow
          if (triggerTime.isBefore(now)) {
            triggerTime = triggerTime.add(Duration(days: 1));
          }
        }
      } catch (e) {
        return 'I couldn\'t parse the time "$timeStr". Please try again.';
      }

      // Parse reminder type
      final reminderType = ReminderType.values.firstWhere(
        (e) => e.name == typeStr,
        orElse: () => ReminderType.once,
      );

      // Parse priority
      final priorityStr = intent['priority'] as String? ?? 'medium';
      final priority = Priority.values.firstWhere(
        (e) => e.name == priorityStr,
        orElse: () => Priority.medium,
      );

      // Create reminder using endpoint
      final reminderEndpoint = ReminderEndpoint();
      final reminder = await reminderEndpoint.createReminder(
        session,
        description,
        triggerTime,
        reminderType,
        priority: priority,
      );

      if (reminder != null) {
        final typeText =
            reminderType == ReminderType.once ? 'once' : reminderType.name;
        final priorityText = priority == Priority.high
            ? ' (high priority)'
            : priority == Priority.low
                ? ' (low priority)'
                : '';
        return 'I\'ve created a $typeText reminder$priorityText: "$description" at ${_formatTime(triggerTime)}.';
      } else {
        return 'Sorry, I couldn\'t create the reminder. Please try again.';
      }
    } catch (e) {
      session.log('Error creating reminder: $e');
      return 'Sorry, I had trouble creating that reminder. Please try again.';
    }
  }

  /// Handle querying reminders
  Future<String> _handleQueryReminders(
    Map<String, dynamic> intent,
    int userId,
  ) async {
    try {
      final queryType = intent['query_type'] as String;
      final reminderEndpoint = ReminderEndpoint();

      if (queryType == 'next') {
        final now = DateTime.now();
        final reminders = await reminderEndpoint.getUpcomingReminders(
          session,
          now,
          now.add(Duration(days: 365)),
        );

        if (reminders.isEmpty) {
          return 'You don\'t have any upcoming reminders.';
        }

        final next = reminders.first;
        return 'Your next reminder is "${next.description}" at ${_formatTime(next.triggerTime)}.';
      } else if (queryType == 'today') {
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = startOfDay.add(Duration(days: 1));

        final reminders = await reminderEndpoint.getUpcomingReminders(
          session,
          startOfDay,
          endOfDay,
        );

        if (reminders.isEmpty) {
          return 'You don\'t have any reminders for today.';
        }

        final count = reminders.length;
        return 'You have $count reminder${count > 1 ? 's' : ''} today.';
      } else {
        final reminders = await reminderEndpoint.getUserReminders(session);
        return 'You have ${reminders.length} active reminder${reminders.length != 1 ? 's' : ''}.';
      }
    } catch (e) {
      session.log('Error querying reminders: $e');
      return 'Sorry, I couldn\'t retrieve your reminders.';
    }
  }

  /// Format DateTime for display
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period on ${time.month}/${time.day}/${time.year}';
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
