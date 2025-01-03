import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class CustomBottomNavBar extends GetView<BasketController> {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutral100,
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral900.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: true,
                onTap: () => Get.offAllNamed('/'),
              ),
              _buildNavItem(
                icon: Icons.directions_car_rounded,
                label: 'Vehicles',
                onTap: () => Get.toNamed('/vehicle_list'),
              ),
              _buildNavItem(
                icon: Icons.bookmark_rounded,
                label: 'Wishlist',
                badge: controller.itemCount.toString(),
                onTap: () => Get.toNamed('/wishlist'),
              ),
              _buildNavItem(
                icon: Icons.shopping_basket_rounded,
                label: 'Basket',
                badge: controller.itemCount.toString(),
                onTap: () => Get.toNamed('/basket'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    String? badge,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 200),
        tween: Tween(begin: 0, end: isSelected ? 1 : 0),
        builder: (context, value, child) {
          return Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: Color.lerp(
                        AppTheme.neutral500,
                        AppTheme.primary,
                        value,
                      ),
                      size: 24,
                    ),
                    if (badge != null)
                      Positioned(
                        top: -8,
                        right: -8,
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
                const SizedBox(height: Spacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: Color.lerp(
                      AppTheme.neutral500,
                      AppTheme.primary,
                      value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
