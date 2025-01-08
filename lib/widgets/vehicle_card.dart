import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';

enum CardType { featured, listing }

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final CardType cardType;

  const VehicleCard({
    Key? key,
    required this.vehicle,
    this.onTap,
    this.cardType = CardType.listing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return cardType == CardType.featured
        ? _buildFeaturedCard(context)
        : _buildListingCard(context);
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return SizedBox(
      height: 300, // Total block height
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // White Background for Image Area
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150, // White area height
            ),
          ),
          // Grey Card
          Positioned(
            bottom: 150, // Align with white area
            left: Spacing.md,
            right: Spacing.md,
            child: Container(
              height: 150, // Grey card height
              decoration: BoxDecoration(
                color: AppTheme.neutral900, // Dark grey background
                borderRadius: BorderRadius.circular(Corners.lg),
                boxShadow: AppTheme.shadowSm,
              ),
              padding: EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and Model
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(Corners.sm),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        vehicle.name,
                        style: AppTheme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutral100,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        '2024 Model',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutral500,
                        ),
                      ),
                    ],
                  ),
                  // Button
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppTheme.neutral100,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Car Image
          Positioned(
            bottom: 10, // Overlap grey card and white area
            child: Hero(
              tag: 'vehicle_${vehicle.id}_featured',
              child: CachedNetworkImage(
                imageUrl: 'http://localhost:8055/assets/${vehicle.image}',
                height: 150, // Car image height
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: AppTheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildListingCard(BuildContext context) {
    return Container(
      height: 120, // Explicit height for the listing card
      margin: EdgeInsets.symmetric(vertical: Spacing.sm, horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: AppTheme.neutral100,
        borderRadius: BorderRadius.circular(Corners.lg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Corners.md),
            child: CachedNetworkImage(
              imageUrl: 'http://localhost:8055/assets/${vehicle.image}',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.neutral200,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.neutral200,
                child: const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: _buildContentSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context, {bool isFeatured = false}) {
    return Column(
      crossAxisAlignment:
      isFeatured ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          vehicle.name,
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: isFeatured ? FontWeight.bold : FontWeight.w600,
            color: isFeatured ? AppTheme.neutral100 : AppTheme.neutral900,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: isFeatured ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          '2024 Model',
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: isFeatured ? AppTheme.primary : AppTheme.neutral600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: isFeatured ? TextAlign.center : TextAlign.left,
        ),
      ],
    );
  }
}
