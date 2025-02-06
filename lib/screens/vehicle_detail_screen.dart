// lib/screens/vehicle_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
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
    final basketController = Get.find<BasketController>();

    return Scaffold(
      body: Obx(() {
        final vehicle = controller.vehicle.value;

        return Stack(
          children: [
            // Main Content
            NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                _buildSliverAppBar(vehicle),
                _buildTabBarWithSearch(),
              ],
              body: Container(
                color: const Color(0xFFEEEEEE),
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    _buildAccessoryList(controller.exteriorAccessories),
                    _buildAccessoryList(controller.interiorAccessories),
                  ],
                ),
              ),
            ),

            // Floating View Basket Button
            Obx(() {
              if (basketController.basketItems.isEmpty) {
                return const SizedBox.shrink(); // Hide button when basket is empty
              }
              return Positioned(
                bottom: 16, // Position the button at the bottom of the screen
                left: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: () => Get.toNamed('/basket'), // Navigate to Basket Tab
                  backgroundColor: AppTheme.neutral900,
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  label: Text(
                    'View Basket | ${basketController.basketCount()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildSliverAppBar(Vehicle vehicle) {
    return SliverAppBar(
      expandedHeight: 280, // Adjusted height for more space at the top
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(10.0), // Proper alignment for the icon
        child: GestureDetector(
          onTap: () => Get.back(), // Back action
          child: CircleAvatar(
            backgroundColor: AppTheme.primary, // Red background for the icon
            child: const Icon(
              Icons.close, // "X" icon
              color: Colors.white, // White color for the icon
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            // Add space above the image
            const SizedBox(height: 70), // Space at the top of the image
            // Cover Image Section
            Expanded(
              child: Container(
                color: AppTheme.neutral900,
                child: Center(
                  child: vehicle.image != null && vehicle.image!.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl:
                    'http://192.168.1.208:8055/assets/${vehicle.image}',
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
              color: AppTheme.neutral900,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    vehicle.name,
                    style: AppTheme.textTheme.headlineLarge?.copyWith(
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
          color: AppTheme.neutral900,
          height: 60.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRect(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 0,
                        ),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        controller: controller.tabController,
                        indicator: const BoxDecoration(
                          color: Color(0xFFD1031F),
                          borderRadius: BorderRadius.all(Radius.circular(25)),

                        ),
                        indicatorPadding: const EdgeInsets.all(5),
                        labelPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        tabs: const [
                          Tab(text: 'Exterior'),
                          Tab(text: 'Interior'),
                        ],
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        indicatorColor: Colors.transparent,
                        indicatorWeight: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [],
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search accessories',
                        filled: true,
                        fillColor: const Color(0xFF1A1A1A),
                        prefixIcon:
                        const Icon(Icons.search, color: Color(0xFFD1031F)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(31),
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
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
          return AccessoryCard(
            accessory: accessory,
            onWishlistTap: () => controller.addToWishlist(context, accessory),
            isInWishlist: controller.isInWishlist(accessory),
          );
        },
      );
    });
  }
}


class _CustomSliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomSliverTabBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 60.0; // Fixed height to match the container
  @override
  double get minExtent => 60.0; // Fixed height to match the container
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
