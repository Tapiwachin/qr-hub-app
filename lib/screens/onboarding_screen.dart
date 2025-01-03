// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/onboarding_controller.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:toyota_accessory_app/models/onboarding_page.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) => _OnboardingPage(
                  page: controller.pages[index],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Spacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: controller.skip,
                    child: Text(
                      'Skip',
                      style: AppTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.neutral600,
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.pages.length,
                    effect: WormEffect(
                      dotColor: AppTheme.neutral300,
                      activeDotColor: AppTheme.primary,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  Obx(() => TextButton(
                    onPressed: controller.isLastPage.value
                        ? controller.finish
                        : controller.next,
                    child: Text(
                      controller.isLastPage.value ? 'Start' : 'Next',
                      style: AppTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingPageData page;

  const _OnboardingPage({
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            page.image,
            height: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(height: Spacing.xl),
          Text(
            page.title,
            style: AppTheme.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Spacing.md),
          Text(
            page.description,
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.neutral600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}