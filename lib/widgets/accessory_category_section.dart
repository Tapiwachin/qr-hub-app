// lib/widgets/accessory_category_section.dart
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/widgets/detailed_accessory_card.dart';

class AccessoryCategorySection extends StatefulWidget {
  final String categoryName; // Now this should hold the actual category name
  final List<Accessory> accessories;
  final Function(Accessory) onAddToWishlist;
  final Function(Accessory) onAddToBasket;

  const AccessoryCategorySection({
    Key? key,
    required this.categoryName,
    required this.accessories,
    required this.onAddToWishlist,
    required this.onAddToBasket,
  }) : super(key: key);

  @override
  State<AccessoryCategorySection> createState() =>
      _AccessoryCategorySectionState();
}

class _AccessoryCategorySectionState extends State<AccessoryCategorySection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        title: Text(
          widget.categoryName, // Use the actual category name here
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('${widget.accessories.length} accessories'),
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (value) => setState(() => _isExpanded = value),
        children: [
          widget.accessories.length > 3
              ? SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.accessories.length,
                    itemBuilder: (context, index) => SizedBox(
                      width: 280,
                      child: DetailedAccessoryCard(
                        accessory: widget.accessories[index],
                        onAddToWishlist: () =>
                            widget.onAddToWishlist(widget.accessories[index]),
                        onAddToBasket: () =>
                            widget.onAddToBasket(widget.accessories[index]),
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.accessories.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) => DetailedAccessoryCard(
                    accessory: widget.accessories[index],
                    onAddToWishlist: () =>
                        widget.onAddToWishlist(widget.accessories[index]),
                    onAddToBasket: () =>
                        widget.onAddToBasket(widget.accessories[index]),
                  ),
                ),
        ],
      ),
    );
  }
}
