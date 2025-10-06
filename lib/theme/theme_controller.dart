import 'package:flutter/material.dart';

/// Single source of truth for theme mode (light/dark).
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  /// Current theme mode for the app.
  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  /// Convenience helpers
  bool get isDark => mode.value == ThemeMode.dark;
  void setDark(bool v) => mode.value = v ? ThemeMode.dark : ThemeMode.light;
}
