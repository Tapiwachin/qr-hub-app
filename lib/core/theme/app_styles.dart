import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class AppStyles {
  // Card & Container Styles
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: AppTheme.neutral100, // Reference to a defined color
    borderRadius: BorderRadius.circular(Corners.lg),
    boxShadow: [
      BoxShadow(
        color: AppTheme.neutral900.withOpacity(0.05), // Replace shadowMd
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: AppTheme.neutral100, // Reference to a defined color
    borderRadius: BorderRadius.circular(Corners.lg),
    boxShadow: [
      BoxShadow(
        color: AppTheme.neutral900.withOpacity(0.08), // Replace shadowMd
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration get containerDecoration => BoxDecoration(
    color: AppTheme.neutral200, // Replace surface
    borderRadius: BorderRadius.circular(Corners.md),
    border: Border.all(color: AppTheme.neutral300),
  );

  // Image Styles
  static BoxDecoration get imageContainerDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(Corners.lg),
    color: AppTheme.neutral200,
    boxShadow: [
      BoxShadow(
        color: AppTheme.neutral900.withOpacity(0.03), // Replace shadowSm
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get roundedImageDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(Corners.md),
    color: AppTheme.neutral200,
    border: Border.all(color: AppTheme.neutral300, width: 2),
  );

  // Gradient Overlays
  static BoxDecoration get gradientOverlay => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        AppTheme.neutral900.withOpacity(0.3),
        AppTheme.neutral900.withOpacity(0.7),
      ],
      stops: const [0.0, 0.5, 1.0],
    ),
  );

  static BoxDecoration get lightGradientOverlay => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        AppTheme.neutral900.withOpacity(0.1),
        AppTheme.neutral900.withOpacity(0.3),
      ],
      stops: const [0.0, 0.5, 1.0],
    ),
  );

  // Input Styles
  static InputDecoration get searchInputDecoration => InputDecoration(
    filled: true,
    fillColor: AppTheme.neutral200, // Replace surface
    hintText: 'Search...',
    hintStyle: AppTheme.textTheme.bodyMedium?.copyWith(
      color: AppTheme.neutral500,
    ),
    prefixIcon: Icon(Icons.search, color: AppTheme.neutral600),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: BorderSide(color: AppTheme.neutral300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      borderSide: BorderSide(color: AppTheme.primary, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: Spacing.lg,
      vertical: Spacing.md,
    ),
  );

  // Price & Badge Styles
  static BoxDecoration priceTagDecoration({Color? color}) => BoxDecoration(
    color: (color ?? AppTheme.primary).withOpacity(0.1),
    borderRadius: BorderRadius.circular(Corners.md),
    border: Border.all(
      color: (color ?? AppTheme.primary).withOpacity(0.2),
    ),
  );

  static BoxDecoration badgeDecoration({required Color color}) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(Corners.sm),
    border: Border.all(color: color.withOpacity(0.2)),
  );

  // List Item Styles
  static BoxDecoration get listItemDecoration => BoxDecoration(
    color: AppTheme.neutral100,
    borderRadius: BorderRadius.circular(Corners.md),
    border: Border.all(color: AppTheme.neutral300),
  );

  // Button Styles
  static ButtonStyle get iconButtonStyle => IconButton.styleFrom(
    backgroundColor: AppTheme.neutral100,
    foregroundColor: AppTheme.neutral900,
    padding: const EdgeInsets.all(Spacing.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      side: BorderSide(color: AppTheme.neutral300),
    ),
  );

  static ButtonStyle get outlinedIconButtonStyle => IconButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppTheme.neutral900,
    padding: const EdgeInsets.all(Spacing.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Corners.md),
      side: BorderSide(color: AppTheme.neutral300),
    ),
  );

  // Padding Presets
  static const EdgeInsets cardPadding = EdgeInsets.all(Spacing.md);
  static const EdgeInsets listPadding = EdgeInsets.symmetric(
    horizontal: Spacing.md,
    vertical: Spacing.sm,
  );
  static const EdgeInsets screenPadding = EdgeInsets.all(Spacing.md);

  // Animation Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

// Extended Corners for additional sizes
extension CornersX on Corners {
  static const double xs = 4;
  static const double full = 999;
}
