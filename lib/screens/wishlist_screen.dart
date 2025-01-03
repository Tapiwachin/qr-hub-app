// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (controller.wishlistItems.isNotEmpty) {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Clear Wishlist'),
                    content: const Text(
                        'Are you sure you want to clear your wishlist?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller
                              .clearWishlist(context); // Pass context here
                          Get.back();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Your wishlist is empty',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final accessory = controller.wishlistItems[index];
            return Card(
              child: ListTile(
                title: Text(accessory.name),
                subtitle: Text('${accessory.type} - ${accessory.partNumber}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (accessory.price != null)
                      Text(
                        '\$${accessory.price!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => controller.removeFromWishlist(
                          context, accessory), // Pass context here
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
