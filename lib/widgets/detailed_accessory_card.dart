// lib/widgets/detailed_accessory_card.dart
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/accessory.dart';

class DetailedAccessoryCard extends StatelessWidget {
  final Accessory accessory;
  final VoidCallback? onTap;
  final VoidCallback onAddToWishlist;
  final VoidCallback onAddToBasket;

  const DetailedAccessoryCard({
    super.key,
    required this.accessory,
    this.onTap,
    required this.onAddToWishlist,
    required this.onAddToBasket,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(context),
              _buildContentSection(context),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: accessory.image != null && accessory.image!.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                image: DecorationImage(
                  image: NetworkImage(accessory.image!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                color: Colors.grey[200],
              ),
              child: Icon(
                Icons.image,
                size: 48.0,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accessory Name
          Text(
            accessory.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0, // Slightly larger for emphasis
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),

          // Accessory Part Number
          if (accessory.partNumber.isNotEmpty)
            Row(
              children: [
                Icon(Icons.article_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4.0),
                Text(
                  'Part Number: ${accessory.partNumber}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            ),
          const SizedBox(height: 8.0),

          // Divider Line
          if (accessory.description != null &&
              accessory.description!.isNotEmpty)
            const Divider(),

          // Accessory Description
          if (accessory.description != null &&
              accessory.description!.isNotEmpty)
            Text(
              accessory.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4, // Increase line height for better readability
                    color: Colors.black87,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8.0),

          // Divider Line
          if (accessory.price != null) const Divider(),

          // Accessory Price
          if (accessory.price != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${accessory.price!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: onAddToWishlist,
            icon: Icon(Icons.favorite_border),
            label: Text('Bookmark'),
          ),
          ElevatedButton.icon(
            onPressed: onAddToBasket,
            icon: Icon(Icons.add_shopping_cart),
            label: Text('Add to basket'),
          ),
        ],
      ),
    );
  }
}
