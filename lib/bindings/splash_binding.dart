// lib/bindings/splash_binding.dart
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}