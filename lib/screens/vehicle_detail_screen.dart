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
        if (vehicle == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildSliverAppBar(vehicle),
            _buildTabBar(),
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
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearchModal(),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          vehicle.name,
          style: AppTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.neutral100,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: 'http://localhost:8055/assets/${vehicle.image}',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppTheme.neutral200,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: AppTheme.neutral200,
                child: Icon(Icons.error, color: AppTheme.neutral500),
              ),
            ),
            Container(decoration: AppStyles.gradientOverlay),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: controller.tabController,
          indicatorColor: AppTheme.primary,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.neutral600,
          indicatorWeight: 3,
          labelStyle: AppTheme.textTheme.labelLarge,
          unselectedLabelStyle: AppTheme.textTheme.labelLarge,
          tabs: const [
            Tab(text: 'Exterior'),
            Tab(text: 'Interior'),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessoryList(RxList<Accessory> accessories) {
    return Obx(() {
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
            onTap: () => controller.onAccessoryTap(accessory, context),
            onWishlistTap: () => controller.addToWishlist(context, accessory),
            isInWishlist: controller.isInWishlist(accessory),
          );
        },
      );
    });
  }

  void _showSearchModal() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppTheme.neutral100,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Corners.lg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Search accessories...',
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.neutral600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Corners.md),
                ),
              ),
              onChanged: controller.onSearchChanged,
            ),
            SizedBox(height: Spacing.md),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.neutral100,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) => false;
}