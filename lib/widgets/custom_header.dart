import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/utils/extensions.dart';

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
        color: AppTheme.neutral900, // Dark background
        boxShadow: AppTheme.shadowSm,
      ),
      child: Stack(
        alignment: Alignment.center, // Center-aligns the content of the Stack
        children: [
          // Logo on the left
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              height: 30,
            ),
          ),

          // Title in the center with the red underline
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Toyota Accessories',
                textAlign: TextAlign.center,
                style: AppTheme.textTheme.displaySmall?.copyWith(
                  color: AppTheme.neutral100,
                  fontWeight: FontWeight.w700, // Slightly bolder
                  fontSize: 20, // Slightly bigger
                ),
              ),
              const SizedBox(height: 6), // Space between text and underline
              Container(
                height: 4, // Height of the red underline
                width: MediaQuery.of(context).size.width / 4, // One-fourth of the screen width
                decoration: BoxDecoration(
                  color: const Color(0xFFE50000),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          // Search Icon on the right
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: AppTheme.neutral100,
              ),
              onPressed: () => Get.toNamed('/search'),
            ),
          ),
        ],
      ),

    );
  }
}
