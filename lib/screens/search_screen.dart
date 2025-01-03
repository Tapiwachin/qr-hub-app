// lib/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/search_controller.dart';
import 'package:toyota_accessory_app/widgets/vehicle_card.dart';
import 'package:toyota_accessory_app/widgets/accessory_card.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';

class SearchScreen extends GetView<AppSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search vehicles and accessories...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.black87),
          onChanged: (value) => controller.search(value),
          autofocus: true,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: controller.clearSearch,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.searchQuery.isEmpty) {
          return const Center(
            child: Text('Enter a search term'),
          );
        }

        if (controller.vehicles.isEmpty && controller.accessories.isEmpty) {
          return const Center(
            child: Text('No results found'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.vehicles.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Vehicles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...controller.vehicles.map((vehicle) => VehicleCard(
                      vehicle: vehicle,
                      onTap: () => Get.toNamed(
                        AppRoutes.VEHICLE_DETAIL,
                        arguments: vehicle,
                      ),
                    )),
              ],
              if (controller.accessories.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Accessories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...controller.accessories.map((accessory) => AccessoryCard(
                      accessory: accessory,
                    )),
              ],
            ],
          ),
        );
      }),
    );
  }
}
