// lib/core/theme/app_styles.dart
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class AppStyles {
  // Card Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: AppTheme.neutral100,
        borderRadius: BorderRadius.circular(Corners.lg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral900.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      );

  // Image Container Styles
  static BoxDecoration get imageContainerDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(Corners.lg),
        color: AppTheme.neutral300,
      );

  // Gradient Overlays
  static BoxDecoration get gradientOverlay => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppTheme.neutral900.withOpacity(0.8),
          ],
        ),
      );

  // Input Decoration
  static InputDecoration get searchInputDecoration => InputDecoration(
        filled: true,
        fillColor: AppTheme.neutral200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Corners.md),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: AppTheme.neutral600),
        prefixIcon: Icon(Icons.search, color: AppTheme.neutral600),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
      );

  // Chip Styles
  static BoxDecoration chipDecoration({required Color color}) => BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Corners.sm),
      );
}
