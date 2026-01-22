import 'package:shared_preferences/shared_preferences.dart';

enum RoutineType {
  morning,
  afternoon,
  evening,
}

class RoutineService {
  static const String _keyMorning = 'routine_morning';
  static const String _keyAfternoon = 'routine_afternoon';
  static const String _keyEvening = 'routine_evening';

  static final List<String> defaultMorning = [
    'Make the bed 🛏️',
    'Drink water 💧',
    'Stretch / Light Exercise 🧘',
    'Plan the day 🗓️'
  ];

  static final List<String> defaultAfternoon = [
    'Check emails 📧',
    'Stretch / Walk 🚶',
    'Review top priorities 📝',
    'Drink water 💧'
  ];

  static final List<String> defaultEvening = [
    'Dim the lights 🌙',
    'Review tomorrow\'s schedule 🗓️',
    'Read a book 📖',
    'Set alarm ⏰'
  ];

  Future<List<String>> getRoutine(RoutineType type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getKey(type);
    final List<String>? stored = prefs.getStringList(key);

    if (stored != null) return stored;

    // Return defaults if none stored
    switch (type) {
      case RoutineType.morning:
        return defaultMorning;
      case RoutineType.afternoon:
        return defaultAfternoon;
      case RoutineType.evening:
        return defaultEvening;
    }
  }

  Future<void> saveRoutine(RoutineType type, List<String> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_getKey(type), tasks);
  }

  Future<void> resetToDefaults(RoutineType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getKey(type));
  }

  String _getKey(RoutineType type) {
    switch (type) {
      case RoutineType.morning:
        return _keyMorning;
      case RoutineType.afternoon:
        return _keyAfternoon;
      case RoutineType.evening:
        return _keyEvening;
    }
  }
}
