// lib/bindings/vehicle_detail_binding.dart
import 'package:get/get.dart';
import 'package:toyota_accessory_app/controllers/vehicle_detail_controller.dart';

class VehicleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VehicleDetailController>(() => VehicleDetailController());
  }
}
