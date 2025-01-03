// lib/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_storageService.isFirstTime()) {
      Get.offNamed(AppRoutes.ONBOARDING);
    } else {
      Get.offNamed(AppRoutes.HOME);
    }
  }
}