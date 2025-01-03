// lib/controllers/onboarding_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';

import 'package:toyota_accessory_app/models/onboarding_page.dart';

class OnboardingController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final pageController = PageController();
  final RxBool isLastPage = false.obs;

  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'Welcome to Toyota',
      description: 'Discover our range of accessories for your vehicle',
      image: 'assets/images/onboarding1.png',
    ),
    OnboardingPageData(
      title: 'Find Perfect Accessories',
      description: 'Browse through our carefully curated collection',
      image: 'assets/images/onboarding2.png',
    ),
    OnboardingPageData(
      title: 'Easy Installation',
      description: 'Get professional installation at your nearest dealer',
      image: 'assets/images/onboarding3.png',
    ),
  ];

  void onPageChanged(int index) {
    isLastPage.value = index == pages.length - 1;
  }

  void next() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void skip() => finish();

  void finish() async {
    await _storageService.setFirstTime(false);
    Get.offAllNamed(AppRoutes.HOME);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}