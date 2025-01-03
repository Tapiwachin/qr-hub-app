// lib/screens/vehicle_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/vehicle_detail_controller.dart';
import 'package:toyota_accessory_app/widgets/accessory_category_section.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VehicleDetailScreen extends GetView<VehicleDetailController> {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final vehicle = controller.vehicle.value;

        if (vehicle == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Vehicle Image and Basic Info
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(vehicle.name),
                background: vehicle.image != null
                    ? CachedNetworkImage(
                        imageUrl:
                            'http://localhost:8055/assets/${vehicle.image}',
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.directions_car, size: 64),
                      ),
              ),
            ),

            // Vehicle Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      vehicle.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Accessories',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),

            // Accessories by Category
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = controller.accessoryCategories[index];
                  final categoryAccessories =
                      controller.getAccessoriesByCategory(category);

                  return AccessoryCategorySection(
                    categoryName: category,
                    accessories: categoryAccessories,
                    onAddToWishlist: (accessory) => controller.addToWishlist(
                        context, accessory), // Pass context here
                    onAddToBasket: (accessory) => controller.addToBasket(
                        context, accessory), // Pass context here
                  );
                },
                childCount: controller.accessoryCategories.length,
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
