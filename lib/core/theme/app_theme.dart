import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFFE50000); // Toyota Red
  static const Color secondary = Color(0xFF2C2C2C); // Dark Gray
  static const Color accent = Color(0xFF0D7ABC); // Toyota Blue

  // Neutral Colors
  static const Color neutral100 = Color(0xFFFFFFFF); // White
  static const Color neutral200 = Color(0xFFF8F9FA);
  static const Color neutral300 = Color(0xFFE9ECEF);
  static const Color neutral400 = Color(0xFFDEE2E6);
  static const Color neutral500 = Color(0xFF707070); // Medium Gray
  static const Color neutral600 = Color(0xFF6C757D);
  static const Color neutral700 = Color(0xFF495057);
  static const Color neutral800 = Color(0xFF343A40);
  static const Color neutral900 = Color(0xFF2C2C2C); // Deep Gray

  // Background Color
  static const Color backgroundMain = Color(0xFFEEEEEE); // Light Gray Background


  // Semantic Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Shadows
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: neutral900.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Typography with Barlow Fonts
  static TextTheme get textTheme {
    return TextTheme(
      // Titles and Headers
      displayLarge: GoogleFonts.barlow(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: neutral900,
      ),
      displayMedium: GoogleFonts.barlow(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: neutral900,
      ),
      displaySmall: GoogleFonts.barlow(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: neutral900,
      ),

      // Section Subtitles
      headlineLarge: GoogleFonts.barlow(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutral900,
      ),
      headlineMedium: GoogleFonts.barlow(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: neutral500,
      ),

      // Body Text
      bodyLarge: GoogleFonts.barlow(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: neutral700,
      ),
      bodyMedium: GoogleFonts.barlow(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: neutral700,
      ),

      // Buttons and Labels
      labelLarge: GoogleFonts.barlow(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: neutral100,
      ),
    );
  }

  // App Bar Styling
  static AppBarTheme get appBarTheme => AppBarTheme(
    elevation: 0,
    backgroundColor: neutral900,
    foregroundColor: neutral100,
    centerTitle: true,
    titleTextStyle: GoogleFonts.barlow(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: neutral100,
    ),
    iconTheme: const IconThemeData(color: neutral100),
  );

  // Card Styling
  static CardTheme get cardTheme => CardTheme(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Corners.lg),
    ),
    color: neutral100,
  );

  // Elevated Button Styling
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: neutral100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Corners.md),
          ),
          textStyle: GoogleFonts.barlow(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );

  // Input Field Styling
  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: neutral200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: const BorderSide(color: neutral300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: const BorderSide(color: neutral300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: const BorderSide(color: primary, width: 2),
    ),
    contentPadding: const EdgeInsets.all(16),
    hintStyle: GoogleFonts.barlow(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: neutral500,
    ),
  );

  // Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: neutral100,
      primaryColor: primary,
      appBarTheme: appBarTheme,
      cardTheme: cardTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: neutral100,
        background: neutral200,
        surface: neutral100,
      ),
    );
  }

  // Dark Theme Configuration
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: neutral900,
      appBarTheme: appBarTheme.copyWith(backgroundColor: neutral900),
      textTheme: textTheme.apply(
        bodyColor: neutral100,
        displayColor: neutral100,
      ),
    );
  }
}

// Spacing and Corner Styles
class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class Corners {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}
