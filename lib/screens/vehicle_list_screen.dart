// lib/screens/vehicle_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/home_controller.dart';
import 'package:toyota_accessory_app/widgets/vehicle_card.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';

class VehicleListScreen extends GetView<HomeController> {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Observable for search query
    final searchQuery = ''.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Vehicles'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  searchQuery.value = value;
                },
                decoration: InputDecoration(
                  hintText: 'Search vehicles...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            // Vehicle List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.vehicles.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filtered list based on search query
                final filteredVehicles = controller.vehicles.where((vehicle) {
                  final query = searchQuery.value.toLowerCase();
                  return vehicle.name.toLowerCase().contains(query) ||
                      vehicle.modelYear.toString().contains(query);
                }).toList();

                if (filteredVehicles.isEmpty) {
                  return const Center(
                    child: Text('No vehicles found'),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4, // Adjust as needed for your design
                  ),
                  itemCount: filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = filteredVehicles[index];
                    return VehicleCard(
                      vehicle: vehicle,
                      onTap: () => Get.toNamed(
                        AppRoutes.VEHICLE_DETAIL,
                        arguments: vehicle,
                      ),
                      cardType: CardType.listing, // Specify the card type for listing
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
