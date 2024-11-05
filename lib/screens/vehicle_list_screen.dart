// lib/screens/vehicle_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/home_controller.dart';
import 'package:toyota_accessory_app/widgets/vehicle_card.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';

class VehicleListScreen extends GetView<HomeController> {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vehicles'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.vehicles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.vehicles.isEmpty) {
            return const Center(
              child: Text('No vehicles found'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 4, // Adjust as needed for your design
            ),
            itemCount: controller.vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = controller.vehicles[index];
              return VehicleCard(
                vehicle: vehicle,
                onTap: () => Get.toNamed(
                  AppRoutes.VEHICLE_DETAIL,
                  arguments: vehicle,
                ),
                isGridView: true,
              );
            },
          );
        }),
      ),
    );
  }
}
