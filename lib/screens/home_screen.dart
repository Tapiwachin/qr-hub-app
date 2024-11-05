import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/home_controller.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';
import 'package:toyota_accessory_app/widgets/custom_header.dart';
import 'package:toyota_accessory_app/widgets/featured_video_section.dart';
import 'package:toyota_accessory_app/widgets/vehicle_card.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';
import 'package:toyota_accessory_app/widgets/accessory_type_tabs.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Fixed CustomHeader at the top
            const CustomHeader(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Featured Video Section
                    const FeaturedVideoSection(),

                    // AccessoryTypeTabs moved below video
                    const AccessoryTypeTabs(),

                    // Horizontal Carousel for Featured Vehicles
                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.vehicles.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.vehicles.isEmpty) {
                        return const Center(
                          child: Text('No vehicles found'),
                        );
                      }

                      final featuredVehicles =
                          controller.vehicles.take(5).toList();

                      return SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: featuredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = featuredVehicles[index];
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: VehicleCard(
                                vehicle: vehicle,
                                onTap: () => Get.toNamed(
                                  AppRoutes.VEHICLE_DETAIL,
                                  arguments: vehicle,
                                ),
                                isGridView: false,
                              ),
                            );
                          },
                        ),
                      );
                    }),

                    // View More Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.VEHICLE_LIST),
                          child: Text(
                            'View More Vehicles',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Grid View for Vehicles
                    // Obx(() {
                    //   if (controller.isLoading.value &&
                    //       controller.vehicles.isEmpty) {
                    //     return const Center(child: CircularProgressIndicator());
                    //   }

                    //   if (controller.vehicles.isEmpty) {
                    //     return const Center(
                    //       child: Text('No vehicles found'),
                    //     );
                    //   }

                    //   return GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     padding: const EdgeInsets.all(16),
                    //     gridDelegate:
                    //         const SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       crossAxisSpacing: 16,
                    //       mainAxisSpacing: 16,
                    //       childAspectRatio: 3 / 4,
                    //     ),
                    //     itemCount: controller.vehicles.length,
                    //     itemBuilder: (context, index) {
                    //       final vehicle = controller.vehicles[index];
                    //       return VehicleCard(
                    //         vehicle: vehicle,
                    //         onTap: () => Get.toNamed(
                    //           AppRoutes.VEHICLE_DETAIL,
                    //           arguments: vehicle,
                    //         ),
                    //         isGridView: true,
                    //       );
                    //     },
                    //   );
                    // }),
                  ],
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
