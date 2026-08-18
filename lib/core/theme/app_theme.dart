import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = Color(0xfff3f2f2);
  static const Color surface = Color(0xfff3f2f2);
  static const Color textPrimary = Color(0xff201e1d);
  static const Color accent = Color(0xffec3013);
  static const Color divider = Color(0x66201e1d); // textPrimary @ 40%

  // No distinct dark palette in this flat red-on-white design; reuse light.
  static ThemeData get dark => light;

  static ThemeData get light {
    final base = ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        surface: surface,
        onSurface: textPrimary,
        primary: accent,
      ),
      scaffoldBackgroundColor: background,
    );

    final textTheme = GoogleFonts.archivoTextTheme(base.textTheme)
        .apply(bodyColor: textPrimary, displayColor: textPrimary)
        .copyWith(
          headlineLarge: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          headlineSmall: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          titleLarge: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          titleSmall: GoogleFonts.archivo(
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          bodyLarge: GoogleFonts.archivo(
            fontWeight: FontWeight.w400,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.archivo(
            fontWeight: FontWeight.w400,
            color: textPrimary,
          ),
          bodySmall: GoogleFonts.archivo(
            fontWeight: FontWeight.w400,
            color: textPrimary,
          ),
        );

    return base.copyWith(
      textTheme: textTheme,
      dividerTheme: const DividerThemeData(
        color: divider,
        thickness: 2,
        space: 2,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.archivo(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        elevation: 0,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.archivo(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? const Color(0xffae1800)
                : const Color(0xff8a8785),
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? const Color(0xffae1800)
                : const Color(0xff8a8785),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: const RoundedRectangleBorder(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
