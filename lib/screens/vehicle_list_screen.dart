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
                  hintText: 'Search vehicle model...',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB0B0B0), // Light grey for placeholder text
                    fontSize: 16, // Adjust font size as needed
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFB0B0B0), // Light grey for the icon
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A), // Dark background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(41.0), // Large rounded corners
                    borderSide: BorderSide.none, // Remove border
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0, // Adjust padding inside the field
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white, // White text for user input
                  fontSize: 16, // Adjust font size as needed
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
                    childAspectRatio: 4 / 4, // Adjust as needed for your design
                  ),
                  itemCount: filteredVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = filteredVehicles[index];
                    return VehicleCard(
                      vehicle: vehicle,
                      onTap: () {
                        // Directly navigate without recreating or serializing the object
                        Get.toNamed(
                          AppRoutes.VEHICLE_DETAIL,
                          arguments: vehicle,
                        );
                      },
                      cardType: CardType.listing,
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
