import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

enum PersonaMode { student, worker, personal }

class PersonaProvider with ChangeNotifier {
  PersonaMode _currentMode = PersonaMode.personal;
  bool _isDarkMode = false;

  PersonaMode get currentMode => _currentMode;
  bool get isDarkMode => _isDarkMode;

  PersonaProvider() {
    _loadPersistedMode();
  }

  Future<void> _loadPersistedMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeIndex = prefs.getInt('persona_mode') ?? 2;
    _currentMode = PersonaMode.values[modeIndex];
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> setMode(PersonaMode mode) async {
    _currentMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('persona_mode', mode.index);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }

  ThemeData get currentTheme {
    ThemeData baseTheme;
    switch (_currentMode) {
      case PersonaMode.student:
        baseTheme = _isDarkMode ? _studentThemeDark : _studentTheme;
        break;
      case PersonaMode.worker:
        baseTheme = _isDarkMode ? _workerThemeDark : _workerTheme;
        break;
      case PersonaMode.personal:
        baseTheme = _isDarkMode ? _personalThemeDark : _personalTheme;
        break;
    }
    return baseTheme.copyWith(
      textTheme: GoogleFonts.outfitTextTheme(baseTheme.textTheme),
    );
  }

  // Student Theme - Vibrant and energetic (Light)
  static final ThemeData _studentTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.light,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Student Theme Dark
  static final ThemeData _studentThemeDark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.dark,
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Worker Theme - Professional and focused (Light)
  static final ThemeData _workerTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // Worker Theme Dark
  static final ThemeData _workerThemeDark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  // Personal Theme - Warm and comfortable (Light)
  static final ThemeData _personalTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // Personal Theme Dark
  static final ThemeData _personalThemeDark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  String get modeDisplayName {
    switch (_currentMode) {
      case PersonaMode.student:
        return 'Student';
      case PersonaMode.worker:
        return 'Worker';
      case PersonaMode.personal:
        return 'Personal';
    }
  }

  IconData get modeIcon {
    return getIconForMode(_currentMode);
  }

  // Helper methods for UI
  IconData getIconForMode(PersonaMode mode) {
    switch (mode) {
      case PersonaMode.student:
        return Icons.school;
      case PersonaMode.worker:
        return Icons.work;
      case PersonaMode.personal:
        return Icons.home;
    }
  }

  String getNameForMode(PersonaMode mode) {
    switch (mode) {
      case PersonaMode.student:
        return 'Student';
      case PersonaMode.worker:
        return 'Worker';
      case PersonaMode.personal:
        return 'Personal';
    }
  }

  // Alias for compatibility
  void setPersona(PersonaMode mode) => setMode(mode);
  PersonaMode get currentPersona => _currentMode;
}
