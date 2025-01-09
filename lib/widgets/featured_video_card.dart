// lib/widgets/featured_video_card.dart
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
import 'package:toyota_accessory_app/models/video.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedVideoCard extends StatelessWidget {
  final Video video;
  final VoidCallback? onTap;

  const FeaturedVideoCard({
    super.key,
    required this.video,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Corners.lg),
          boxShadow: AppTheme.shadowSm,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: video.thumbnailUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.neutral200,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.neutral200,
                child: Icon(Icons.error),
              ),
            ),
            Container(decoration: AppStyles.gradientOverlay),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title ?? '',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.neutral100,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: AppTheme.neutral100,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}