// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/routes/app_routes.dart';
import 'package:toyota_accessory_app/bindings/initial_binding.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';
import 'package:toyota_accessory_app/core/theme/app_theme.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MyApp());
}

Future<void> initServices() async {
  try {
    await Get.putAsync(() => StorageService().init());
    print('All services started...');
  } catch (e) {
    print('Error initializing services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Toyota Accessory App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialBinding: InitialBinding(),
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.HOME,
    );
  }
}