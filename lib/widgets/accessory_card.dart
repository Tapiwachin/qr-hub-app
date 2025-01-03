// lib/widgets/accessory_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
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
      decoration: AppStyles.elevatedCardDecoration,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(Spacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(),
              _buildContentSection(context),
              _buildFooterSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: accessory.image != null && accessory.image!.isNotEmpty
              ? CachedNetworkImage(
            imageUrl: accessory.image!,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildPlaceholder(),
            errorWidget: (context, url, error) => _buildErrorWidget(),
          )
              : _buildErrorWidget(),
        ),
        if (accessory.isNew)
          Positioned(
            top: Spacing.sm,
            left: Spacing.sm,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: AppStyles.badgeDecoration(color: AppTheme.success),
              child: Text(
                'NEW',
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (onWishlistTap != null)
          Positioned(
            top: Spacing.sm,
            right: Spacing.sm,
            child: _buildWishlistButton(),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppTheme.neutral200,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppTheme.neutral200,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppTheme.neutral500,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildWishlistButton() {
    return Material(
      color: AppTheme.neutral100.withOpacity(0.9),
      shape: CircleBorder(),
      child: InkWell(
        onTap: onWishlistTap,
        customBorder: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(Spacing.xs),
          child: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_border,
            color: isInWishlist ? AppTheme.primary : AppTheme.neutral700,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            accessory.name,
            style: AppTheme.textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          ...[
          SizedBox(height: Spacing.xs),
          Text(
            'Part: ${accessory.partNumber}',
            style: AppTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.neutral600,
            ),
          ),
        ],
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Spacing.md,
        0,
        Spacing.md,
        Spacing.md,
      ),
      child: Row(
        children: [
          if (accessory.price != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: AppStyles.priceTagDecoration(),
              child: Text(
                '\$${accessory.price!.toStringAsFixed(2)}',
                style: AppTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          Spacer(),
          TextButton.icon(
            onPressed: onTap,
            icon: Icon(Icons.shopping_cart_outlined),
            label: Text('Add to Cart'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primary,
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.xs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}