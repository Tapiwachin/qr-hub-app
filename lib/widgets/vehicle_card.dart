import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
import 'package:toyota_accessory_app/core/utils/ui_helpers.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback? onTap;
  final bool isGridView;

  const VehicleCard({
    Key? key,
    required this.vehicle,
    this.onTap,
    this.isGridView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        color: AppTheme.neutral100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Add this
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(context),
              Flexible(
                // Wrap with Flexible
                child: _buildContentSection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      // Add ClipRRect for rounded corners at the top
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      child: AspectRatio(
        aspectRatio: isGridView ? 3 / 2 : 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'vehicle_${vehicle.id}',
              child: CachedNetworkImage(
                imageUrl: 'http://localhost:8055/assets/${vehicle.image}',
                fit: BoxFit.cover,
                placeholder: (context, url) => UIHelpers.buildShimmer(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Container(
              decoration: AppStyles.gradientOverlay,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            isGridView ? 80 : double.infinity, // Limit height in grid view
      ),
      padding: const EdgeInsets.all(12.0), // Reduced padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vehicle.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  // Changed from headlineMedium
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1, // Limit to 1 line
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4.0), // Reduced spacing
          Text(
            vehicle.accessoryType,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.neutral700,
                ),
            maxLines: 1, // Limit to 1 line
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
