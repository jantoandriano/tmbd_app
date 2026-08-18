import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _themeFrom(
    ColorScheme.fromSeed(seedColor: Colors.indigo),
  );

  static ThemeData get dark => _themeFrom(
    ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
  );

  static ThemeData _themeFrom(ColorScheme colorScheme) => ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: colorScheme.onPrimaryContainer,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      indicatorColor: colorScheme.primaryContainer,
    ),
    cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
  );
}
