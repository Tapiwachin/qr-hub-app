// lib/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/video.dart';
import 'package:toyota_accessory_app/widgets/featured_video_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:toyota_accessory_app/services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find();
  final vehicles = <Vehicle>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final RxList<Video> featuredVideos = <Video>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
    fetchFeaturedVideos();
  }

  Future<void> refreshVehicles() async {
    vehicles.clear();
    return fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await _apiService.getVehicles();
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

  Future<void> fetchFeaturedVideos() async {
    try {
      final videos = await _apiService.getVideos(limit: 5);
      featuredVideos.value = videos;
    } catch (e) {
      print('Error fetching featured videos: $e');
    }
  }

  void playVideo(Video video) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))
        ),
        child: Column(
          children: [
            Text(
              video.title ?? 'Featured Video',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    color: Colors.black54,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (video.thumbnailUrl != null)
                          Image.network(
                            video.thumbnailUrl!,
                            fit: BoxFit.cover,
                          ),
                        Icon(
                          Icons.play_circle_outline,
                          size: 64,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}