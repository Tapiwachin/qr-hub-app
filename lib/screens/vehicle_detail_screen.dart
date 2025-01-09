// lib/screens/vehicle_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/vehicle_detail_controller.dart';
import 'package:toyota_accessory_app/widgets/accessory_card.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VehicleDetailScreen extends GetView<VehicleDetailController> {
  const VehicleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final vehicle = controller.vehicle.value;

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildSliverAppBar(vehicle),
            _buildTabBarWithSearch(),
          ],
          body: TabBarView(
            controller: controller.tabController,
            children: [
              _buildAccessoryList(controller.exteriorAccessories),
              _buildAccessoryList(controller.interiorAccessories),
            ],
          ),
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildSliverAppBar(Vehicle vehicle) {
    print('Title: ${vehicle.name}');
    print('Image: ${vehicle.image}');

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            // Cover Image Section
            Expanded(
              child: Container(
                color: AppTheme.neutral900, // Dark grey background
                child: Center(
                  child: vehicle.image != null && vehicle.image!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: 'http://10.0.2.2:8055/assets/${vehicle.image}',
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: AppTheme.neutral300,
                    ),
                  )
                      : Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: AppTheme.neutral300,
                  ),
                ),
              ),
            ),
            // Title and Model Year Section
            Container(
              color: AppTheme.neutral900, // Same dark background as cover
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    vehicle.name,
                    style: AppTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.neutral100,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicle.modelYear ?? 'Unknown Model Year',
                    style: AppTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.neutral500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarWithSearch() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CustomSliverTabBarDelegate(
        child: Container(
          color: AppTheme.neutral900, // Dark grey background matching the header
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Grouped Tabs Section
              Expanded(
                flex: 2,
                child: Container(
                  height: 50, // Height for the grouped tabs
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A), // Dark background color
                    borderRadius: BorderRadius.circular(31), // Rounded corners for entire group
                  ),
                  child: TabBar(
                    controller: controller.tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFFD1031F), // Active tab color (Toyota red)
                      borderRadius: BorderRadius.circular(25), // Rounded corners for active tab
                    ),
                    indicatorPadding: const EdgeInsets.all(5), // Space around the active tab
                    labelPadding: const EdgeInsets.symmetric(
                      vertical: 8, // Smaller padding top and bottom
                      horizontal: 20, // Larger padding left and right for longer buttons
                    ),
                    indicatorSize: TabBarIndicatorSize.tab, // Indicator covers the full tab
                    labelColor: Colors.white, // Text color for active tab
                    unselectedLabelColor: Colors.grey, // Text color for inactive tabs
                    labelStyle: const TextStyle(
                      fontSize: 14, // Font size for the tab text
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14, // Font size for inactive tab text
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const [
                      Tab(text: 'Exterior'),
                      Tab(text: 'Interior'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16), // Space between tabs and search bar

              // Search Field Section
              Expanded(
                flex: 1,
                child: Container(
                  height: 50, // Height for the search field
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A), // Dark background color
                    borderRadius: BorderRadius.circular(31), // Rounded corners
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: 'Search accessories',
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A), // Matches background
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFD1031F)), // Red icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(31), // Match styling
                        borderSide: BorderSide.none, // No border
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.grey, // Light grey hint text
                        fontSize: 14,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white, // Text color for input
                      fontSize: 14,
                    ),
                    onChanged: controller.onSearchChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildAccessoryList(RxList<Accessory> accessories) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (accessories.isEmpty) {
        return Center(
          child: Text(
            'No accessories found',
            style: AppTheme.textTheme.bodyLarge,
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(Spacing.md),
        itemCount: accessories.length,
        itemBuilder: (context, index) {
          final accessory = accessories[index];
          print('Tapiwa Accessory Data: ${accessory.toJson()}'); // Debug log
          return AccessoryCard(
            accessory: accessory,
            onTap: () => controller.onAccessoryTap(accessory, context),
            onWishlistTap: () => controller.addToWishlist(context, accessory),
            isInWishlist: controller.isInWishlist(accessory),
          );
        },
      );
    });
  }

  void _showSearchModal() {
    // Removed redundant search modal
  }
}

class _CustomSliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomSliverTabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60.0; // Adjust height as needed
  @override
  double get minExtent => 60.0; // Adjust height as needed
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
