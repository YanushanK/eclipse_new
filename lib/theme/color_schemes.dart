import 'package:flutter/material.dart';

const _gold = Color(0xFFC8A84E);
const _goldDark = Color(0xFFB4923F);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: _gold,
  onPrimary: Colors.black,
  primaryContainer: Color(0xFFFFE9A9),
  onPrimaryContainer: Color(0xFF2F2400),
  secondary: Color(0xFF6B6B6B),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFE5E5E5),
  onSecondaryContainer: Color(0xFF1F1F1F),
  surface: Color(0xFFF8F6F2),
  onSurface: Color(0xFF141414),
  background: Color(0xFFF8F6F2),
  onBackground: Color(0xFF141414),
  error: Color(0xFFB3261E),
  onError: Colors.white,
  outline: Color(0xFFB9B9B9),
  outlineVariant: Color(0xFFE2E2E2),
  shadow: Colors.black,
  scrim: Colors.black,
  tertiary: Color(0xFF2E7D32),
  onTertiary: Colors.white,
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: _goldDark,
  onPrimary: Colors.black,
  primaryContainer: Color(0xFF3B2F0B),
  onPrimaryContainer: Color(0xFFFFF2C9),
  secondary: Color(0xFFBDBDBD),
  onSecondary: Colors.black,
  secondaryContainer: Color(0xFF2C2C2C),
  onSecondaryContainer: Color(0xFFEDEDED),
  surface: Color(0xFF0F0F0F),
  onSurface: Color(0xFFF3F3F3),
  background: Color(0xFF0B0B0B),
  onBackground: Color(0xFFF3F3F3),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  outline: Color(0xFF5B5B5B),
  outlineVariant: Color(0xFF3A3A3A),
  shadow: Colors.black,
  scrim: Colors.black,
  tertiary: Color(0xFF66BB6A),
  onTertiary: Colors.black,
);
