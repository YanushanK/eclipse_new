import 'package:flutter/material.dart';
import 'color_schemes.dart';

class AppTheme {
  static ThemeData _base(ColorScheme cs) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: cs.background,
      canvasColor: cs.surface,

      // Buttons — readable labels in both modes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          disabledBackgroundColor: cs.primary.withOpacity(.35),
          disabledForegroundColor: cs.onPrimary.withOpacity(.65),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
        ),
      ),

      // Inputs — high-contrast labels/hints/borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // leave transparent here and set field-level fillColor to theme.cardColor when needed
        fillColor: const Color(0x00000000),
        labelStyle: TextStyle(color: cs.onSurface.withOpacity(.9)),
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(.6)),
        prefixIconColor: cs.onSurface.withOpacity(.8),
        suffixIconColor: cs.onSurface.withOpacity(.8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.error, width: 1.5),
        ),
      ),

      // 🔧 Use CardThemeData (not CardTheme) for your Flutter version
      cardTheme: CardThemeData(
        color: cs.surface,
        elevation: 0,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.transparent, // avoid muddy M3 tint
      ),

      listTileTheme: ListTileThemeData(
        iconColor: cs.onSurface,
        textColor: cs.onSurface,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: cs.background,
        foregroundColor: cs.onBackground,
        elevation: 0,
        centerTitle: true,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withOpacity(.6),
        type: BottomNavigationBarType.fixed,
      ),

      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
      ),

      textTheme: const TextTheme().apply(
        bodyColor: cs.onSurface,
        displayColor: cs.onSurface,
      ),
    );
  }

  static ThemeData light = _base(lightColorScheme);
  static ThemeData dark  = _base(darkColorScheme);
}
