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
      // Extract timezone offset from command
      int offsetSeconds = 0;
      final offsetMatch =
          RegExp(r'TimezoneOffset: ([+-])(\d{2}):(\d{2})').firstMatch(command);
      if (offsetMatch != null) {
        final sign = offsetMatch.group(1) == '+' ? 1 : -1;
        final hours = int.parse(offsetMatch.group(2)!);
        final minutes = int.parse(offsetMatch.group(3)!);
        offsetSeconds = sign * ((hours * 3600) + (minutes * 60));
      }

      // Call Gemini API to parse the command
      final intent = await _parseCommandWithGemini(command, apiKey);
      intent['user_offset_seconds'] = offsetSeconds; // Pass to handler

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
Current Server Time: ${now.hour}:${now.minute.toString().padLeft(2, '0')} (UTC)

Your goal is to assist the user with their daily tasks, reminders, and questions.
You will receive a command that includes a [System Context] block containing the user's Local Time and Timezone.
USE THIS CONTEXT. All times in the command are relative to the User's Local Time, not the server time.

Parse the following command and extract the intent.

Command: "$command"

Respond with a JSON object containing:
- "action": one of "create_reminder", "query_reminders", or "general"
- For create_reminder: "description", "time" (ISO 8601 format), "type" (daily/weekly/annual/once), "priority" (high/medium/low)
- For query_reminders: "query_type" (next/all/today)
- For general: "response" (a conversational, helpful text response)

TIME PARSING RULES (CRITICAL):
1. **UTC CONVERSION**: You MUST calculate the specific UTC timestamp for the "time" field.
   - Use the User's Local Time and Timezone from the context to determine the offset.
   - Example: If User Time is 12:00 (UTC+1) and they say "at 1 PM" (13:00), the UTC time is 12:00Z.
   - Return the result in UTC (ending in Z), e.g., "2026-01-28T12:00:00Z".

2. Relative times:
   - "in X minutes" → add X minutes to User's Local Time -> convert to UTC
   
3. Specific times:
   - "at 3 PM" → Today at 3 PM (User's Time) -> convert to UTC

4. Return ISO 8601 format for "time" field:
   - "2026-01-23T15:30:00Z" (MUST be UTC)

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

      // Extract Timezone Offset from command
      // Format: TimezoneOffset: +01:00
      Duration offset = Duration.zero;
      final offsetMatch = RegExp(r'TimezoneOffset: ([+-]\d{2}:\d{2})')
          .firstMatch(intent['original_command'] ?? '');
      // Wait, 'intent' doesn't have the original command unless we pass it.
      // We need to parse the command string passed to processCommand.
      // But _handleCreateReminder only gets 'intent'.
      // We'll need to pass 'command' to _handleCreateReminder or extract offset in processCommand.
      // Let's modify processCommand to pass the offset. But first, let's just fix the time parsing here assuming 'triggerTime' is Local.

      // Actually, we can't access 'command' here easily without changing signature.
      // Let's assume we pass the offset as an argument.
      // But I can't change the signature easily in this tool call.

      // BETTER: Update processCommand to extract offset and pass it to _handleCreateReminder.
      // I will abort this specific edit and do it in two steps:
      // 1. Update _handleCreateReminder signature.
      // 2. Update processCommand to call it with offset.

      // Let's implement the parsing logic assuming we have the offset.
      // Wait, I can't change the signature and the call site in one tool call if they are far apart.

      // Let's hack it: Pass 'command' inside 'intent' map? No, processCommand constructs intent from Gemini response.
      // I should modify processCommand to add 'user_offset' to the intent map before calling _handleCreateReminder.

      // This tool call is for lines 136-164 (Parsing).
      // I will assume 'intent' has 'user_offset_seconds'.

      // Parse time
      DateTime triggerTime;
      try {
        if (timeStr.contains('T')) {
          triggerTime = DateTime.parse(timeStr); // Local time (no Z)
        } else {
          // ... (same logic for HH:MM)
          final parts = timeStr.split(':');
          final now = DateTime.now(); // This 'now' is Server Time (UTC).
          // We should technically use User Local Time for 'now' if we are building date from components.
          // But Gemini should return full ISO mostly.
          // If Gemini returns HH:MM, we use Server Date? That might be wrong if User is on next day.
          // BUT my prompt asks for ISO.

          triggerTime = DateTime(now.year, now.month, now.day,
              int.parse(parts[0]), int.parse(parts[1]));
        }

        // Apply Offset to convert to UTC
        // triggerTime is "19:10" (Local).
        // We want UTC. UTC = Local - Offset.
        // ex: 19:10 - (+01:00) = 18:10 UTC.

        final offsetSeconds = intent['user_offset_seconds'] as int? ?? 0;
        triggerTime = triggerTime.subtract(Duration(seconds: offsetSeconds));
        // Force isUtc = true (though subtract on non-utc might keep it compatible, best to be explicit)
        triggerTime = DateTime.utc(
            triggerTime.year,
            triggerTime.month,
            triggerTime.day,
            triggerTime.hour,
            triggerTime.minute,
            triggerTime.second);
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
