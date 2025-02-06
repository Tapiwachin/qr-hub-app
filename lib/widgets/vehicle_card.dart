import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';

enum CardType { featured, listing }

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final CardType cardType;
  final bool isFirstCard; // New parameter to identify the first card
  final bool isLastCard;  // New parameter to identify the last card

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.cardType = CardType.listing,
    this.isFirstCard = false,
    this.isLastCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return cardType == CardType.featured
        ? _buildFeaturedCard(context)
        : _buildListingCard(context);
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Link the entire card to the vehicle detail page
      child: Padding(
        padding: EdgeInsets.only(
          left: isFirstCard ? 16.0 : 8.0, // Less space for the first card
          right: isLastCard ? 16.0 : 8.0, // Less space for the last card
        ),
        child: SizedBox(
          height: 320, // Adjusted total block height
          width: MediaQuery.of(context).size.width * 0.8,
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
                  height: 140, // Adjusted white area height
                ),
              ),
              // Grey Card
              Positioned(
                bottom: 100, // Position the grey card as required
                left: -30.0, // Extend slightly to the left
                right: 30.0, // Extend slightly to the right
                child: Container(
                  height: 190, // Adjusted grey card height
                  decoration: BoxDecoration(
                    color: AppTheme.neutral900, // Dark grey background
                    borderRadius: BorderRadius.circular(Corners.lg),
                    boxShadow: [], // Removed shadow
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0), // Adjusted padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50, // Narrower red line
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(Corners.sm),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle.name,
                        style: AppTheme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutral100,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 0),
                      Text(
                        '${vehicle.modelYear} Model',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Car Image
              Positioned(
                bottom: 20, // Adjust to place image closer or further from the grey box
                left: MediaQuery.of(context).size.width * -0.1, // Reduce left padding for more central positioning
                right: MediaQuery.of(context).size.width * 0.05, // Reduce right padding for more central positioning
                child: Hero(
                  tag: 'vehicle_${vehicle.id}_featured',
                  child: CachedNetworkImage(
                    imageUrl: 'http://192.168.1.208:8055/assets/${vehicle.image}',
                    height: 200, // Increase height for a larger image
                    width: MediaQuery.of(context).size.width * 0.8, // Adjust width to fit 80% of the screen width
                    fit: BoxFit.contain, // Ensure the image fits without cropping
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
        ),
      ),
    );
  }




  Widget _buildListingCard(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(Corners.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Vehicle Image
            ClipRRect(
              borderRadius: BorderRadius.circular(Corners.md),
              child: CachedNetworkImage(
                imageUrl: 'http://192.168.1.208:8055/assets/${vehicle.image}',
                height: 100,
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
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Debug Red Line
        const SizedBox(height: 10.0),
        Container(
          width: 50,
          height: 6,
          decoration: BoxDecoration(
            color: AppTheme.primary, // Red line color
            borderRadius: BorderRadius.circular(3), // Radius of 3 for rounded edges
          ),
        ),
        const SizedBox(height: 4.0),
        // Vehicle Name
        Text(
          vehicle.name ?? 'Unknown Vehicle', // Fallback to avoid null issues
          style: AppTheme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 0.0),
        // Model Year
        Text(
          '${vehicle.modelYear ?? "Unknown"} Model',
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.neutral500,
            fontSize: 12.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

}
