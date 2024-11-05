// lib/routes/app_routes.dart
import 'package:get/get.dart';
import 'package:toyota_accessory_app/screens/home_screen.dart';
import 'package:toyota_accessory_app/screens/wishlist_screen.dart';
import 'package:toyota_accessory_app/screens/basket_screen.dart';
import 'package:toyota_accessory_app/screens/search_screen.dart';
import 'package:toyota_accessory_app/screens/notifications_screen.dart';
import 'package:toyota_accessory_app/screens/vehicle_detail_screen.dart';
import 'package:toyota_accessory_app/screens/vehicle_list_screen.dart';
import 'package:toyota_accessory_app/bindings/vehicle_detail_binding.dart';
import 'package:toyota_accessory_app/controllers/search_controller.dart'; // Add this
import 'package:toyota_accessory_app/controllers/notification_controller.dart'; // Add this

class AppRoutes {
  static const String HOME = '/';
  static const String WISHLIST = '/wishlist';
  static const String BASKET = '/basket';
  static const String SEARCH = '/search';
  static const String NOTIFICATIONS = '/notifications';
  static const String VEHICLE_DETAIL = '/vehicle-detail';
  static const String VEHICLE_LIST = '/vehicle_list'; // <-- Add this route

  static final routes = [
    GetPage(
      name: HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: WISHLIST,
      page: () => const WishlistScreen(),
    ),
    GetPage(
      name: BASKET,
      page: () => const BasketScreen(),
    ),
    GetPage(
      name: SEARCH,
      page: () => const SearchScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AppSearchController>(() => AppSearchController());
      }),
    ),
    GetPage(
      name: NOTIFICATIONS,
      page: () => const NotificationsScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationController>(() => NotificationController());
      }),
    ),
    GetPage(
      name: VEHICLE_DETAIL,
      page: () => const VehicleDetailScreen(),
      binding: VehicleDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.VEHICLE_LIST,
      page: () => const VehicleListScreen(),
    ),
  ];
}
