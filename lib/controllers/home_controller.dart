// lib/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/video.dart';
import 'package:toyota_accessory_app/services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final vehicles = <Vehicle>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final selectedType = 'Toyota Genuine'.obs;
  final featuredVideo = Rxn<Video>();

  static const List<String> accessoryTypes = [
    'Toyota Genuine',
    'AAP',
    'Conversion'
  ];

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
    fetchFeaturedVideo();
  }

  void setAccessoryType(String type) {
    if (selectedType.value != type) {
      selectedType.value = type;
      fetchVehicles();
    }
  }

  Future<void> refreshVehicles() async {
    vehicles.clear();
    return fetchVehicles();
  }

  Future<void> fetchFeaturedVideo() async {
    try {
      final videos = await _apiService.getVideos(limit: 1);
      if (videos.isNotEmpty) {
        featuredVideo.value = videos.first;
      }
    } catch (e) {
      print('Error fetching featured video: $e');
    }
  }

  void playFeaturedVideo() {
    if (featuredVideo.value?.videoUrl != null) {
      Get.dialog(
        AlertDialog(
          title: Text(featuredVideo.value?.title ?? 'Featured Video'),
          content: SizedBox(
            width: double.maxFinite,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Video Player Placeholder',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> fetchVehicles() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiService.getVehicles(
        accessoryType: selectedType.value,
      );
      vehicles.value = response;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load vehicles',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
