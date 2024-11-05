// lib/screens/basket_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/widgets/custom_bottom_nav.dart';

class BasketScreen extends GetView<BasketController> {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiry Basket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (controller.basketItems.isNotEmpty) {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Clear Basket'),
                    content: const Text(
                        'Are you sure you want to clear your basket?'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.clearBasket(context); // Pass context here
                          Get.back();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.basketItems.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Your basket is empty',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.basketItems.length,
                itemBuilder: (context, index) {
                  final accessory = controller.basketItems[index];
                  return Card(
                    child: ListTile(
                      title: Text(accessory.name),
                      subtitle:
                          Text('${accessory.type} - ${accessory.partNumber}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (accessory.price != null)
                            Text(
                              '\$${accessory.price!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => controller.removeItem(
                                context, accessory), // Pass context here
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Estimate:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(() => Text(
                            '\$${controller.total.value.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        controller.submitInquiry(context), // Pass context here
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text('Submit Inquiry'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
