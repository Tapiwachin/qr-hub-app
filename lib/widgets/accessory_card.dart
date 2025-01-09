// lib/widgets/accessory_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/models/accessory.dart';

class AccessoryCard extends StatelessWidget {
  final Accessory accessory;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;
  final bool isInWishlist;

  const AccessoryCard({
    super.key,
    required this.accessory,
    this.onTap,
    this.onWishlistTap,
    this.isInWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image on the left
          _buildImageSection(),

          // Content on the right
          Expanded(child: _buildContentSection(context)),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppTheme.neutral200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: accessory.image != null && accessory.image!.isNotEmpty
          ? CachedNetworkImage(
        imageUrl: accessory.image!,
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

  Widget _buildContentSection(BuildContext context) {
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
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Part Number
          Text(
            'Part: ${accessory.partNumber ?? "N/A"}',
            style: const TextStyle(
              color: Color(0xFF333333), // Dark Grey
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            accessory.description ?? 'No description available.',
            style: const TextStyle(
              color: Color(0xFF666666), // Light Grey
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Buttons
          Row(
            children: [
              // Bookmark/Wishlist Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onWishlistTap,
                  icon: Icon(
                    isInWishlist ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text('Bookmark'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333), // Dark Grey
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Add to Basket Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: const Text('Basket'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1031F), // Toyota Red
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
