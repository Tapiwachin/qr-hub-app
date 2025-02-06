// lib/screens/basket_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/screens/dealer_selection_screen.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';
import 'package:toyota_accessory_app/widgets/custom_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class BasketScreen extends GetView<BasketController> {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE), // Light grey background
      body: Column(
        children: [
          // Custom Header
          const CustomHeader(),

          // Title with Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0), // Reduced vertical padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart, color: Color(0xFFE50000)), // Dark Grey Icon
                const SizedBox(width: 8),
                Text(
                  'Basket',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333), // Dark Grey Text
                  ),
                ),
              ],
            ),
          ),

          // Accessories List
          Expanded(
            child: Obx(() {
              if (controller.basketItems.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Your basket is empty',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return Stack(
                children: [
                  // Positioned ListView
                  Positioned(
                    top: -60.0, // Simulate negative padding by adjusting the top position
                    left: 16.0,
                    right: 16.0,
                    bottom: 0.0, // Ensure the listview takes up remaining space
                    child: ListView.builder(
                      itemCount: controller.basketItems.length,
                      itemBuilder: (context, index) {
                        final accessory = controller.basketItems[index];
                        return _buildBasketCard(context, accessory);
                      },
                    ),
                  ),
                ],
              );

            }),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(bottom: 80.0), // Adjust position above the bottom nav
          child: FloatingActionButton.extended(
            onPressed: controller.basketItems.isEmpty
                ? null
                : () {
              Get.to(() => DealerSelectionScreen());
            },
            backgroundColor:
            controller.basketItems.isEmpty ? Colors.grey : AppTheme.primary,
            label: Text(
              'Enquire Now (${controller.basketItems.length})',
              style: const TextStyle(color: Colors.white),
            ),
            icon: const Icon(Icons.send, color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Increased radius
            ),
          ),
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildBasketCard(BuildContext context, dynamic accessory) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppTheme.neutral200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: accessory.image != null && accessory.image.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: accessory.image!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
              ),
            )
                : const Icon(
              Icons.image_not_supported,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),

          // Content and Actions Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  accessory.name,
                  style: const TextStyle(
                    color: Color(0xFFD1031F), // Toyota Red
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Large font
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Part Number
                Text(
                  'Part: ${accessory.partNumber ?? "N/A"}',
                  style: const TextStyle(
                    color: Color(0xFF333333), // Dark Grey
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Small font
                  ),
                ),
                const SizedBox(height: 4),
                // Description
                Text(
                  accessory.description ?? 'No description available.',
                  style: const TextStyle(
                    color: Color(0xFF666666), // Light Grey
                    fontSize: 12, // Small font
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Counter and Remove Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Counter
                    ElevatedButton.icon(
                      onPressed: () {}, // Implement quantity increment logic
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('1'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(60, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),

                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => controller.removeItem(context, accessory),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
