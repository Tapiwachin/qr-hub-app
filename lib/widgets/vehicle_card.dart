// lib/widgets/vehicle_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';

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
    return Container(
      height: 220,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(Spacing.xs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Corners.lg),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: _buildImageSection(context),
              ),
              Expanded(
                flex: 2,
                child: _buildContentSection(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: 'vehicle_${vehicle.id}',
          child: CachedNetworkImage(
            imageUrl: 'http://localhost:8055/assets/${vehicle.image}',
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
        Container(decoration: AppStyles.gradientOverlay),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            vehicle.name,
            style: AppTheme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: Spacing.xs),
          Text(
            vehicle.accessoryType,
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}