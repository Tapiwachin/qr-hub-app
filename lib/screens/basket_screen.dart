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
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Column(
        children: [
          // Custom Header
          const CustomHeader(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Inquiry Basket',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: controller.basketItems.length,
                  itemBuilder: (context, index) {
                    final accessory = controller.basketItems[index];
                    return _buildBasketCard(context, accessory);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return FloatingActionButton.extended(
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Section
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.neutral200),
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

          // Content Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accessory.name,
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Part: ${accessory.partNumber ?? "N/A"}',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  accessory.description ?? 'No description available.',
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutral500,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Quantity and Remove Section
          Column(
            children: [
              // Quantity
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
              const SizedBox(height: 8),

              // Remove Icon
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => controller.removeItem(context, accessory),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
