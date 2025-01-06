// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFFE50000); // Toyota Red
  static const Color secondary = Color(0xFF1E1E1E); // Almost Black
  static const Color accent = Color(0xFF0D7ABC); // Toyota Blue

  // Neutral Colors
  static const Color neutral100 = Color(0xFFFFFFFF); // White
  static const Color neutral200 = Color(0xFFF8F9FA);
  static const Color neutral300 = Color(0xFFE9ECEF);
  static const Color neutral400 = Color(0xFFDEE2E6);
  static const Color neutral500 = Color(0xFFADB5BD);
  static const Color neutral600 = Color(0xFF6C757D);
  static const Color neutral700 = Color(0xFF495057);
  static const Color neutral800 = Color(0xFF343A40);
  static const Color neutral900 = Color(0xFF212529);

  // Semantic Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);

  // Surface Colors
  static const Color surface = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundAlt = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFF2A2A2A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [neutral100, neutral200],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Shadows
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: neutral900.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: neutral900.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: neutral900.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Typography
  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: neutral900,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: neutral900,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: neutral900,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: neutral900,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: neutral900,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: neutral900,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: neutral900,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        height: 1.5,
        color: neutral700,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
        color: neutral700,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: neutral900,
      ),
    );
  }

  // Component Themes
  static CardTheme get cardTheme => CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Corners.lg),
    ),
    clipBehavior: Clip.antiAlias,
    color: neutral100,
  );

  static AppBarTheme get appBarTheme => AppBarTheme(
    elevation: 0,
    backgroundColor: neutral100,
    foregroundColor: neutral900,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: neutral900,
    ),
    iconTheme: IconThemeData(color: neutral900),
  );

  static ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.md),
      ),
      foregroundColor: neutral100,
      backgroundColor: primary,
    ),
  );

  static OutlinedButtonThemeData get outlinedButtonTheme => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Corners.md),
      ),
      foregroundColor: primary,
      side: const BorderSide(color: primary, width: 1.5),
    ),
  );

  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      foregroundColor: primary,
      textStyle: textTheme.labelLarge,
    ),
  );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: neutral100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: BorderSide(color: neutral300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: BorderSide(color: neutral300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: const BorderSide(color: primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: BorderSide(color: error),
    ),
    contentPadding: const EdgeInsets.all(Spacing.md),
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onPrimary: neutral100,
        onSecondary: neutral100,
        onSurface: neutral900,
        onError: neutral100,
      ),
      textTheme: textTheme,
      cardTheme: cardTheme,
      appBarTheme: appBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      textButtonTheme: textButtonTheme,
      inputDecorationTheme: inputDecorationTheme,
      scaffoldBackgroundColor: background,
      dividerTheme: DividerThemeData(
        color: neutral300,
        space: Spacing.md,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: neutral900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: neutral100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Corners.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: neutral900,
        background: neutral900,
        error: error,
        onPrimary: neutral100,
        onSecondary: neutral100,
        onSurface: neutral100,
        onBackground: neutral100,
        onError: neutral100,
      ),
      textTheme: textTheme.apply(
        bodyColor: neutral100,
        displayColor: neutral100,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Corners.lg),
        ),
        clipBehavior: Clip.antiAlias,
        color: neutral800,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: neutral900,
        foregroundColor: neutral100,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: neutral100,
        ),
        iconTheme: IconThemeData(color: neutral100),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: neutral900,
        selectedItemColor: primary,
        unselectedItemColor: neutral500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: neutral800,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Corners.md),
          borderSide: BorderSide(color: neutral700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Corners.md),
          borderSide: BorderSide(color: neutral700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Corners.md),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: TextStyle(color: neutral600),
      ),
      dividerColor: neutral800,
      dialogBackgroundColor: neutral800,
      popupMenuTheme: PopupMenuThemeData(
        color: neutral800,
        elevation: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: neutral800,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: neutral100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Corners.md),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Spacing constants
class Spacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class Corners {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;
}