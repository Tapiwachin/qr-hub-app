import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final basketController = Get.find<BasketController>();
    final wishlistController = Get.find<WishlistController>();

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.neutral900,
        boxShadow: [
          BoxShadow(
            color: AppTheme.neutral100,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                iconPath: 'assets/icons/home.svg',
                solidIconPath: 'assets/icons/home-active.svg',
                label: 'Home',
                isSelected: false, // Update this logic to determine active tab
                onTap: () => Get.offAllNamed('/'),
              ),
              _buildNavItem(
                iconPath: 'assets/icons/vehicles.svg',
                solidIconPath: 'assets/icons/vehicles-active.svg',
                label: 'Vehicles',
                isSelected: false, // Update this logic to determine active tab
                onTap: () => Get.toNamed('/vehicle_list'),
              ),
              Obx(() => _buildNavItem(
                iconPath: 'assets/icons/wishlist-outline.svg',
                solidIconPath: 'assets/icons/wishlist-active.svg',
                label: 'Wishlist',
                badge: wishlistController.itemCount.toString(),
                isSelected: false, // Update this logic to determine active tab
                onTap: () => Get.toNamed('/wishlist'),
              )),
              Obx(() => _buildNavItem(
                iconPath: 'assets/icons/basket-outline.svg',
                solidIconPath: 'assets/icons/basket-active.svg',
                label: 'Basket',
                badge: basketController.itemCount.toString(),
                isSelected: false, // Update this logic to determine active tab
                onTap: () => Get.toNamed('/basket'),
              )),
              _buildNavItem(
                iconPath: 'assets/icons/alerts.svg',
                solidIconPath: 'assets/icons/alerts-active.svg',
                label: 'Alerts',
                badge: '2',
                isSelected: false, // Update this logic to determine active tab
                onTap: () => Get.toNamed('/notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String solidIconPath,
    required String label,
    String? badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                isSelected ? solidIconPath : iconPath,
                color: Colors.white,
                height: 24,
                width: 24,
              ),
              if (badge != null && badge != '0')
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
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 4), // Space between text and line
            Container(
              height: 4,
              width: 24, // Width of the active line
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
