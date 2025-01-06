import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';


class VehicleDetailController extends GetxController with GetSingleTickerProviderStateMixin {
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
    vehicle.value = Get.arguments as Vehicle;
    fetchAccessories();
  }

  Future<void> fetchAccessories() async {
    isLoading.value = true;
    try {
      final accessories = await _apiService.getAccessoriesForVehicle(vehicle.value.id);
      exteriorAccessories.value = accessories.where((a) => a.type == 'exterior').toList();
      interiorAccessories.value = accessories.where((a) => a.type == 'interior').toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load accessories');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      fetchAccessories();
      return;
    }

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
          color: AppTheme.cardBackground,
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
                      _wishlistController.addToWishlist(context, accessory);
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
                      _basketController.addItem(context, accessory);
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