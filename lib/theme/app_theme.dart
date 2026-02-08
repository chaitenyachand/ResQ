import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF121212);
  static const Color primaryAction = Color(0xFFFF3B30); // Neon Red
  static const Color safety = Color(0xFF34C759); // Neon Green
  static const Color accent = Color(0xFF007AFF); // Electric Blue
  static const Color warning = Color(
    0xFFFFCC00,
  ); // Warning Yellow (implied for Fire/Alerts)
  static const Color surface = Color(0xFF1E1E1E); // Slightly lighter for cards

  // Text Styles
  static TextTheme get textTheme {
    return GoogleFonts.rajdhaniTextTheme().copyWith(
      displayLarge: GoogleFonts.orbitron(
        color: Colors.white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
      displayMedium: GoogleFonts.orbitron(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
      bodyLarge: GoogleFonts.rajdhani(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.rajdhani(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: GoogleFonts.spaceMono(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelSmall: GoogleFonts.spaceMono(
        color: Colors.white54,
        fontSize: 10,
        letterSpacing: 1.0,
      ),
    );
  }

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryAction,
      colorScheme: ColorScheme.dark(
        primary: primaryAction,
        secondary: safety,
        tertiary: accent,
        surface: surface,
        error: primaryAction,
      ),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
    );
  }
}
