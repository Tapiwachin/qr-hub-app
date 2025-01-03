import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/home_controller.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';
import 'package:toyota_accessory_app/widgets/custom_header.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:toyota_accessory_app/widgets/featured_video_card.dart';
import 'package:toyota_accessory_app/widgets/vehicle_card.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:toyota_accessory_app/core/theme/app_styles.dart';
// import 'package:toyota_accessory_app/widgets/accessory_type_tabs.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshVehicles,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVideoSection(),
                      SizedBox(height: Spacing.md),
                      _buildFeaturedVehicles(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildVideoSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Spacing.md),
      child: Obx(() {
        if (controller.featuredVideos.isEmpty) {
          return _buildPlaceholderVideo();
        }

        return CarouselSlider.builder(
          itemCount: controller.featuredVideos.length,
          itemBuilder: (context, index, _) => FeaturedVideoCard(
            video: controller.featuredVideos[index],
            onTap: () => controller.playVideo(controller.featuredVideos[index]),
          ),
          options: CarouselOptions(
            height: 220,
            viewportFraction: 0.9,
            aspectRatio: 16/9,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: controller.featuredVideos.length > 1,
            autoPlayInterval: Duration(seconds: 5),
          ),
        );
      }),
    );
  }

  Widget _buildPlaceholderVideo() {
    return Container(
      height: 220,
      margin: EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: AppTheme.neutral200,
        borderRadius: BorderRadius.circular(Corners.lg),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 48,
            color: AppTheme.neutral500,
          ),
          Container(decoration: AppStyles.gradientOverlay),
          Positioned(
            bottom: Spacing.md,
            left: Spacing.md,
            child: Text(
              'Featured Videos',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.neutral100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedVehicles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Models',
                    style: AppTheme.textTheme.titleLarge,
                  ),
                  Text(
                    'Popular Toyota vehicles',
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutral600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.VEHICLE_LIST),
                child: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: Spacing.sm),
        SizedBox(
          height: 220,
          child: Obx(() {
            if (controller.isLoading.value && controller.vehicles.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            final featuredVehicles = controller.vehicles.take(5).toList();
            if (featuredVehicles.isEmpty) {
              return Center(
                child: Text(
                  'No vehicles available',
                  style: AppTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.neutral600,
                  ),
                ),
              );
            }

            return PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              padEnds: false,
              itemCount: featuredVehicles.length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? Spacing.md : Spacing.xs,
                  right: index == featuredVehicles.length - 1 ? Spacing.md : Spacing.xs,
                ),
                child: VehicleCard(
                  vehicle: featuredVehicles[index],
                  onTap: () => Get.toNamed(
                    AppRoutes.VEHICLE_DETAIL,
                    arguments: featuredVehicles[index],
                  ),
                  isGridView: false,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}