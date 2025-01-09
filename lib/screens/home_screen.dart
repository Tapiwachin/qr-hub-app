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

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundMain,
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
                      const SizedBox(height: 16),
                      _VideoSection(controller: controller),
                      const SizedBox(height: 16),
                      _FeaturedVehiclesSection(controller: controller),
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
}

class _VideoSection extends StatelessWidget {
  final HomeController controller;

  const _VideoSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.neutral900, // Background color for the video section
      padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      child: Obx(() {
        if (controller.featuredVideos.isEmpty) {
          return _buildPlaceholderVideo(); // Display placeholder if no videos
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Text(
                'Featured Videos',
                style: AppTheme.textTheme.headlineLarge?.copyWith(
                  color: AppTheme
                      .neutral100, // White text color for dark background
                ),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            CarouselSlider.builder(
              itemCount: controller.featuredVideos.length,
              itemBuilder: (context, index, _) => GestureDetector(
                onTap: () =>
                    controller.playVideo(controller.featuredVideos[index]),
                child: FeaturedVideoCard(
                  video: controller.featuredVideos[index],
                ),
              ),
              options: CarouselOptions(
                height: 220,
                viewportFraction: 0.9,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayInterval: const Duration(seconds: 5),
                aspectRatio: 16 / 9,
                enableInfiniteScroll: controller.featuredVideos.length > 1,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlaceholderVideo() {
    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: AppTheme.neutral800, // Darker gray placeholder background
        borderRadius: BorderRadius.circular(Corners.lg),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 48,
            color: AppTheme.neutral500, // Lighter gray for placeholder icon
          ),
          Container(decoration: AppStyles.gradientOverlay), // Gradient overlay
          Positioned(
            bottom: Spacing.md,
            left: Spacing.md,
            child: Text(
              'No Videos Available',
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutral100, // White text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedVehiclesSection extends StatefulWidget {
  final HomeController controller;

  const _FeaturedVehiclesSection({required this.controller});

  @override
  State<_FeaturedVehiclesSection> createState() =>
      _FeaturedVehiclesSectionState();
}

class _FeaturedVehiclesSectionState extends State<_FeaturedVehiclesSection> {
  late PageController _pageController;
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredVehicles = widget.controller.vehicles.take(5).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallDevice = constraints.maxHeight < 600; // Detect small screens
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Explore our diverse selection of ',
                          style: AppTheme.textTheme.headlineMedium?.copyWith(
                            fontSize: isSmallDevice ? 24 : 30, // Adjust font size
                            fontWeight: FontWeight.w600,
                            color: AppTheme.neutral900,
                          ),
                        ),
                        TextSpan(
                          text: 'Toyota Accessories.',
                          style: AppTheme.textTheme.headlineMedium?.copyWith(
                            fontSize: isSmallDevice ? 24 : 30, // Adjust font size
                            fontWeight: FontWeight.w900,
                            color: AppTheme.neutral900,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      Text(
                        'FEATURED MODELS',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.VEHICLE_LIST),
                        icon: const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppTheme.neutral900,
                        ),
                        label: Text(
                          'View All',
                          style: AppTheme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.neutral900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),

            // Carousel Section
            SizedBox(
              height: isSmallDevice ? 250 : 300, // Adjust height for small devices
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: featuredVehicles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? Spacing.md : Spacing.xs,
                      right: index == featuredVehicles.length - 1
                          ? Spacing.md
                          : Spacing.xs,
                    ),
                    child: VehicleCard(
                      vehicle: featuredVehicles[index],
                      onTap: () => Get.toNamed(
                        AppRoutes.VEHICLE_DETAIL,
                        arguments: featuredVehicles[index],
                      ),
                      cardType: CardType.featured,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: Spacing.sm),

            // Scroll Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: featuredVehicles.isNotEmpty
                      ? (_currentPage + 1) / featuredVehicles.length
                      : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

