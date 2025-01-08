import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class VehicleDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiService _apiService = Get.find();
  final WishlistController _wishlistController = Get.find();
  final BasketController _basketController = Get.find();
  final vehicle = Vehicle.empty().obs;
  final exteriorAccessories = <Accessory>[].obs;
  final interiorAccessories = <Accessory>[].obs;

  late TabController tabController;
  final searchController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // Ensure vehicle is properly passed
    final Vehicle? vehicleData = Get.arguments as Vehicle?;
    if (vehicleData != null) {
      vehicle.value = vehicleData;
      fetchAccessories();
    } else {
      Get.snackbar('Error', 'Failed to load vehicle data');
    }
  }

  Future<void> fetchAccessories() async {
    isLoading.value = true;
    try {
      final accessories = await _apiService.getAccessoriesForVehicle(vehicle.value.id);

      // Clear lists to avoid duplication
      exteriorAccessories.clear();
      interiorAccessories.clear();

      // Filter accessories based on type
      for (final accessory in accessories) {
        if (accessory.type == 'exterior') {
          exteriorAccessories.add(accessory);
        } else if (accessory.type == 'interior') {
          interiorAccessories.add(accessory);
        }
      }

      print('Exterior Accessories: ${exteriorAccessories.length}');
      print('Interior Accessories: ${interiorAccessories.length}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to load accessories');
    } finally {
      isLoading.value = false;
    }
  }


  void onSearchChanged(String query) {
    if (query.isEmpty) {
      fetchAccessories(); // Reset lists if search query is empty
      return;
    }

    // Filter based on the active tab
    if (tabController.index == 0) {
      exteriorAccessories.value = exteriorAccessories
          .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      interiorAccessories.value = interiorAccessories
          .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void onAccessoryTap(Accessory accessory, BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: AppTheme.neutral900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(Corners.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      addToWishlist(context, accessory);
                      Get.back();
                    },
                    icon: Icon(
                      isInWishlist(accessory)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    label: Text('Add to Wishlist'),
                  ),
                ),
                SizedBox(width: Spacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      addToBasket(context, accessory);
                      Get.back();
                    },
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
