import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final p = await SharedPreferences.getInstance();
    _isDark = p.getBool('dark') ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark', _isDark);
  }

  Future<void> setDark(bool v) async {
    _isDark = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark', _isDark);
  }
}
