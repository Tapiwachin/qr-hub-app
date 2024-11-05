// lib/widgets/accessory_type_tabs.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/home_controller.dart';

class AccessoryTypeTabs extends GetWidget<HomeController> {
  const AccessoryTypeTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: HomeController.accessoryTypes.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected = controller.selectedType.value == type;
                return FilterChip(
                  selected: isSelected,
                  label: Text(type),
                  onSelected: (_) => controller.setAccessoryType(type),
                  selectedColor: Colors.blue.withOpacity(0.2),
                  checkmarkColor: Colors.blue,
                );
              }),
            );
          }).toList(),
        ),
      ),
    );
  }
}
