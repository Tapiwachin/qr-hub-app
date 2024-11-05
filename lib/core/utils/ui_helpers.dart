// lib/core/utils/ui_helpers.dart
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class UIHelpers {
  // Shimmer Loading Effect
  static Widget buildShimmer({
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(Corners.md),
        gradient: LinearGradient(
          colors: [
            AppTheme.neutral300,
            AppTheme.neutral200,
            AppTheme.neutral300,
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  // Error State Widget
  static Widget buildErrorState({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: Spacing.md),
          Text(message),
          if (onRetry != null) ...[
            const SizedBox(height: Spacing.md),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
