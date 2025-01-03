// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/splash_controller.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/toyota_logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: Spacing.lg),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}