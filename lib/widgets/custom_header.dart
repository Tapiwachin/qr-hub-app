import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/utils/extensions.dart'; // Add this import

// lib/widgets/custom_header.dart
class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: context.padding.top + Spacing.sm,
        bottom: Spacing.sm,
        left: Spacing.md,
        right: Spacing.md,
      ),
      decoration: BoxDecoration(
        color: AppTheme.neutral900,
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          // Logo
          Image.asset(
            'assets/images/toyota_logo.png',
            height: 32,
          ),

          SizedBox(width: Spacing.md),

          // Title
          Text(
            'Toyota Accessories',
            style: AppTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.neutral100,
              fontWeight: FontWeight.w600,
            ),
          ),

          Spacer(),

          // Search Icon
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppTheme.neutral100,
            ),
            onPressed: () =>Get.toNamed('/search'),
          ),
        ],
      ),
    );
  }
}
