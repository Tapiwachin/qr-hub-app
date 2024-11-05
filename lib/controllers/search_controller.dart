// lib/controllers/search_controller.dart
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/api_service.dart';

class AppSearchController extends GetxController {
  final ApiService _apiService = Get.find();
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final vehicles = <Vehicle>[].obs;
  final accessories = <Accessory>[].obs;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      vehicles.clear();
      accessories.clear();
      return;
    }

    try {
      isLoading.value = true;
      searchQuery.value = query;

      // Search vehicles
      final vehicleResults = await _apiService.searchVehicles(query);
      vehicles.value = vehicleResults;

      // Search accessories
      final accessoryResults = await _apiService.searchAccessories(query);
      accessories.value = accessoryResults;
    } catch (e) {
      print('Search error: $e');
      Get.snackbar(
        'Error',
        'Failed to perform search',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    vehicles.clear();
    accessories.clear();
  }
}
