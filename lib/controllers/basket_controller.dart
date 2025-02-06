import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';

class BasketController extends GetxController {
  final StorageService _storageService = Get.find();
  final basketItems = <Accessory>[].obs;
  static const String storageKey = 'basket_items';

  @override
  void onInit() {
    super.onInit();
    loadBasketFromStorage();
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
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void addItem(BuildContext context, Accessory accessory) {
    if (!isInBasket(accessory)) {
      basketItems.add(accessory);
      saveBasketToStorage();
      showCustomSnackBar(context, 'Added to Basket',
          '${accessory.name} has been added to your basket');
    } else {
      showCustomSnackBar(context, 'Already in Basket',
          '${accessory.name} is already in your basket');
    }
  }

  void removeItem(BuildContext context, Accessory accessory) {
    basketItems.removeWhere((item) => item.id == accessory.id);
    saveBasketToStorage();
    showCustomSnackBar(context, 'Removed from Basket',
        '${accessory.name} has been removed from your basket');
  }

  Map<String, List<Accessory>> groupByVehicle() {
    final grouped = <String, List<Accessory>>{};
    for (var accessory in basketItems) {
      final vehicle = accessory.categoryName ?? 'Unknown Vehicle';
      grouped[vehicle] = [...(grouped[vehicle] ?? []), accessory];
    }
    return grouped;
  }

  int get itemCount => basketItems.length;
  int basketCount() {
    return basketItems.length;
  }
  int itemCountForAccessory(Accessory accessory) {
    return basketItems.where((item) => item.id == accessory.id).length;
  }

  bool isInBasket(Accessory accessory) {
    return basketItems.any((item) => item.id == accessory.id);
  }

}