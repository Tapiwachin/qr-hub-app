import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';

class WishlistController extends GetxController {
  final StorageService _storageService = Get.find();
  final BasketController _basketController = Get.find(); // Add BasketController
  final wishlistItems = <Accessory>[].obs;
  static const String storageKey = 'wishlist_items';

  @override
  void onInit() {
    super.onInit();
    loadWishlistFromStorage();
  }

  Future<void> loadWishlistFromStorage() async {
    try {
      final items = await _storageService.getList(storageKey);
      if (items != null) {
        wishlistItems.value =
            items.map((item) => Accessory.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading wishlist: $e');
    }
  }

  Future<void> saveWishlistToStorage() async {
    try {
      final items = wishlistItems.map((item) => item.toJson()).toList();
      await _storageService.saveList(storageKey, items);
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }

  void showCustomSnackBar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title: $message',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void addToWishlist(BuildContext context, Accessory accessory) {
    if (!isInWishlist(accessory)) {
      wishlistItems.add(accessory);
      saveWishlistToStorage();
      showCustomSnackBar(context, 'Added to Wishlist',
          '${accessory.name} has been added to your wishlist');
    }
  }

  void removeFromWishlist(BuildContext context, Accessory accessory) {
    wishlistItems.removeWhere((item) => item.id == accessory.id);
    saveWishlistToStorage();
    showCustomSnackBar(context, 'Removed from Wishlist',
        '${accessory.name} has been removed from your wishlist');
  }

  bool isInWishlist(Accessory accessory) {
    return wishlistItems.any((item) => item.id == accessory.id);
  }

  void clearWishlist(BuildContext context) {
    wishlistItems.clear();
    saveWishlistToStorage();
    showCustomSnackBar(context, 'Wishlist Cleared',
        'All items have been removed from your wishlist');
  }

  void addToBasket(BuildContext context, Accessory accessory) {
    if (!_basketController.isInBasket(accessory)) {
      _basketController.addItem(context, accessory);
      showCustomSnackBar(context, 'Added to Basket',
          '${accessory.name} has been added to your basket');
    } else {
      showCustomSnackBar(context, 'Already in Basket',
          '${accessory.name} is already in your basket');
    }
  }
  int get itemCount => wishlistItems.length; // For WishlistController
}