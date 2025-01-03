import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/utils/extensions.dart'; // Add this import

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
        color: AppTheme.neutral100,
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral900.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Toyota Logo with animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, (1 - value) * 10),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Image.asset(
              'assets/images/toyota_logo.png',
              height: 32,
            ),
          ),
          const Spacer(),
          // Action Buttons
          Row(
            children: [
              _buildActionButton(
                icon: Icons.search,
                onTap: () => Get.toNamed('/search'),
              ),
              const SizedBox(width: Spacing.sm),
              _buildActionButton(
                icon: Icons.notifications,
                badge: '2',
                onTap: () => Get.toNamed('/notifications'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Corners.md),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.neutral200,
            borderRadius: BorderRadius.circular(Corners.md),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                color: AppTheme.neutral700,
                size: 22,
              ),
              if (badge != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.neutral100,
                        width: 2,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: AppTheme.neutral100,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
