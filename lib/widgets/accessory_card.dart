import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/models/accessory.dart';

class AccessoryCard extends StatelessWidget {
  final Accessory accessory;
  final VoidCallback? onWishlistTap;
  final bool isInWishlist;

  const AccessoryCard({
    super.key,
    required this.accessory,
    this.onWishlistTap,
    this.isInWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    final BasketController basketController = Get.find();

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [], // No shadow for clean design
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          _buildImageSection(),

          // Content Section
          Expanded(
            child: _buildContentSection(context, basketController),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.neutral200,
        borderRadius: BorderRadius.circular(45), // Updated border radius
        border: Border.all(
          color: const Color(0xFFEEEEEE), // Faint grey border color
          width: 1.5,
        ),
      ),
      child: accessory.image != null && accessory.image!.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: 'http://192.168.1.208:8055/assets/${accessory.image}',
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.image_not_supported,
          size: 40,
          color: AppTheme.neutral500,
        ),
      )
          : Icon(
        Icons.image_not_supported,
        size: 40,
        color: AppTheme.neutral500,
      ),
    );
  }

  Widget _buildContentSection(
      BuildContext context, BasketController basketController) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            accessory.name,
            style: const TextStyle(
              color: Color(0xFFD1031F), // Toyota Red
              fontWeight: FontWeight.bold,
              fontSize: 16, // Reduced font size
            ),
            maxLines: 2, // Allow title to span 2 lines
            overflow: TextOverflow.visible, // No truncation with ellipses
          ),
          const SizedBox(height: 6),

          // Part Number
          Text(
            'Part: ${accessory.partNumber ?? "N/A"}',
            style: const TextStyle(
              color: Color(0xFF333333), // Dark Grey
              fontWeight: FontWeight.bold,
              fontSize: 12, // Slightly smaller font
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            accessory.description ?? 'No description available.',
            style: const TextStyle(
              color: Color(0xFF666666), // Light Grey
              fontSize: 11, // Reduced font size
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures proper spacing
            children: [
              // Wishlist Button
              SizedBox(
                width: 110, // Fixed width from design
                height: 32, // Fixed height from design
                child: ElevatedButton.icon(
                  onPressed: onWishlistTap,
                  icon: Icon(
                    isInWishlist ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 14, // Icon size per design
                  ),
                  label: const Text(
                    'Bookmark',
                    style: TextStyle(fontSize: 10), // Font size from design
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333), // Dark Grey
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, // Side padding
                      vertical: 5, // Top and bottom padding
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5), // Gap between buttons

              // Add to Basket Button
              SizedBox(
                width: 120, // Fixed width from design
                height: 32, // Fixed height from design
                child: Obx(() {
                  final itemCount = basketController.itemCountForAccessory(accessory);

                  return ElevatedButton.icon(
                    onPressed: () {
                      basketController.addItem(context, accessory);
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 14, // Icon size per design
                    ),
                    label: Text(
                      itemCount > 0
                          ? 'Basket | $itemCount' // Show count for the specific accessory
                          : 'Add to Basket',
                      style: const TextStyle(fontSize: 10), // Font size from design
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1031F), // Toyota Red
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, // Side padding
                        vertical: 5, // Top and bottom padding
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
