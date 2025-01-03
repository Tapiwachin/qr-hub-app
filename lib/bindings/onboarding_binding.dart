// lib/bindings/onboarding_binding.dart
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OnboardingController());
  }
}