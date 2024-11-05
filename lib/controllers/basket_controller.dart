import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';

class BasketController extends GetxController {
  final StorageService _storageService = Get.find();
  final basketItems = <Accessory>[].obs;
  static const String storageKey = 'basket_items';

  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadBasketFromStorage();
    ever(basketItems, (_) => calculateTotal());
  }

  void calculateTotal() {
    total.value = basketItems.fold(
      0,
      (sum, item) => sum + (item.price ?? 0),
    );
  }

  Future<void> loadBasketFromStorage() async {
    try {
      final items = await _storageService.getList(storageKey);
      if (items != null) {
        basketItems.value =
            items.map((item) => Accessory.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error loading basket: $e');
    }
  }

  Future<void> saveBasketToStorage() async {
    try {
      final items = basketItems.map((item) => item.toJson()).toList();
      await _storageService.saveList(storageKey, items);
    } catch (e) {
      print('Error saving basket: $e');
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

  void addItem(BuildContext context, Accessory accessory) {
    if (!basketItems.contains(accessory)) {
      basketItems.add(accessory);
      saveBasketToStorage();
      showCustomSnackBar(context, 'Added to Basket',
          '${accessory.name} has been added to your basket');
    }
  }

  void removeItem(BuildContext context, Accessory accessory) {
    basketItems.remove(accessory);
    saveBasketToStorage();
    showCustomSnackBar(context, 'Removed from Basket',
        '${accessory.name} has been removed from your basket');
  }

  void clearBasket(BuildContext context) {
    basketItems.clear();
    saveBasketToStorage();
    showCustomSnackBar(context, 'Basket Cleared',
        'All items have been removed from your basket');
  }

  int get itemCount => basketItems.length;

  void submitInquiry(BuildContext context) {
    // TODO: Implement inquiry submission
    showCustomSnackBar(context, 'Inquiry Submitted',
        'Your inquiry has been submitted successfully');
    clearBasket(context);
  }
}
