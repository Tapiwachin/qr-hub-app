import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';

class VehicleDetailController extends GetxController {
  final ApiService _apiService = Get.find();
  final WishlistController _wishlistController = Get.find();
  final BasketController _basketController = Get.find();

  final vehicle = Rxn<Vehicle>();
  final accessories = <Accessory>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Vehicle) {
      vehicle.value = args;
      loadVehicleDetails();
    }
  }

  Future<void> loadVehicleDetails() async {
    try {
      isLoading.value = true;
      final vehicleDetail = await _apiService.getVehicleById(vehicle.value!.id);
      vehicle.value = vehicleDetail;

      // Extract accessories correctly from the nested JSON structure
      if (vehicleDetail.accessories != null) {
        accessories.value = vehicleDetail.accessories!
            .map((vehicleAccessory) => vehicleAccessory.accessoriesId)
            .where((accessory) => accessory != null)
            .cast<Accessory>()
            .toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load vehicle details');
    } finally {
      isLoading.value = false;
    }
  }

  List<String> get accessoryCategories {
    // Extract distinct category names instead of IDs
    final categories = accessories
        .map((acc) => acc.categoryName ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  List<Accessory> getAccessoriesByCategory(String categoryName) {
    return accessories
        .where((acc) => acc.categoryName == categoryName)
        .toList();
  }

  void addToWishlist(BuildContext context, Accessory accessory) {
    _wishlistController.addToWishlist(context, accessory);
  }

  void addToBasket(BuildContext context, Accessory accessory) {
    _basketController.addItem(context, accessory);
  }

  bool isInWishlist(Accessory accessory) {
    return _wishlistController.isInWishlist(accessory);
  }
}
