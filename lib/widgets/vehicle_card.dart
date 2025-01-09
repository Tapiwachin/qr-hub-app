import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';

enum CardType { featured, listing }

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final CardType cardType;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.cardType = CardType.listing,
  });

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
                        '${vehicle.modelYear} Model',
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
                imageUrl: 'http://10.0.2.2:8055/assets/${vehicle.image}',
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
    return GestureDetector(
      onTap: onTap, // Ensure the onTap is passed and triggered
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Spacing.sm, horizontal: Spacing.md),
        decoration: BoxDecoration(
          color: Colors.transparent, // Transparent card
          borderRadius: BorderRadius.circular(Corners.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Vehicle Image
            ClipRRect(
              borderRadius: BorderRadius.circular(Corners.md),
              child: CachedNetworkImage(
                imageUrl: 'http://10.0.2.2:8055/assets/${vehicle.image}',
                height: 150, // Adjust image height
                width: double.infinity,
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
            const SizedBox(height: 8.0),
            // Vehicle Title and Year Section
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }


  Widget _buildContentSection(BuildContext context, {bool isFeatured = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Red Line
        Container(
          width: 40,
          height: 3,
          color: AppTheme.primary, // Red line color
        ),
        const SizedBox(height: 4.0),
        // Vehicle Title
        Text(
          vehicle.name,
          style: AppTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.neutral100, // White text
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4.0),
        // Year Model
        Text(
          '${vehicle.modelYear} Model',
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.neutral500, // Lighter text for model year
            fontSize: 12.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }


}
