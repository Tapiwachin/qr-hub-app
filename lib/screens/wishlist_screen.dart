// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';
import 'package:toyota_accessory_app/widgets/custom_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: Column(
        children: [
          // Custom Header
          Column(
            children: [
              const CustomHeader(),
              const Text(
                'Wishlist',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
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

              return Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio:
                    0.7, // Adjust aspect ratio for card layout
                  ),
                  itemCount: controller.wishlistItems.length,
                  itemBuilder: (context, index) {
                    final accessory = controller.wishlistItems[index];
                    return _buildWishlistCard(context, accessory);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildWishlistCard(BuildContext context, dynamic accessory) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Bookmark Icon
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  border: Border.all(color: AppTheme.neutral200),
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
                    size: 40,
                  ),
                )
                    : const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    controller.isInWishlist(accessory)
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: AppTheme.primary,
                  ),
                  onPressed: () =>
                      controller.removeFromWishlist(context, accessory),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              accessory.name,
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),

          // Part Number
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Part: ${accessory.partNumber ?? "N/A"}',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.neutral700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              accessory.description ?? 'No description available.',
              style: AppTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.neutral500,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Add to Basket Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        controller.addToBasket(context, accessory),
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 16,
                    ),
                    label: const Text('Basket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: AppTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () =>
                      controller.removeFromWishlist(context, accessory),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
