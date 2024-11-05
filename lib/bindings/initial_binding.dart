import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/home_controller.dart';
import 'package:toyota_accessory_app/controllers/basket_controller.dart';
import 'package:toyota_accessory_app/controllers/wishlist_controller.dart';
import 'package:toyota_accessory_app/controllers/search_controller.dart';
import 'package:toyota_accessory_app/controllers/notification_controller.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register Services
    Get.putAsync(() => StorageService().init());
    Get.put(ApiService());

    // Register Controllers
    Get.put(HomeController());
    Get.put(BasketController());
    Get.put(WishlistController());
    Get.put(AppSearchController());
    Get.put(NotificationController());
  }
}
