// lib/services/api_service.dart
import 'package:dio/dio.dart' hide Response;
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/video.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/models/notification.dart';
import 'package:toyota_accessory_app/models/dealer.dart';

class ApiService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: 'http://10.0.2.2:8055/api-adaptor',
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
    ));
  }

  Future<List<Vehicle>> getVehicles({String? accessoryType}) async {
    try {
      final response = await _dio.get(
        '/vehicles',
        queryParameters: accessoryType != null ? {'accessory_type': accessoryType} : null,
      );

      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response format');
      }

      return (response.data['data'] as List)
          .map((json) => Vehicle.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching vehicles: $e');
      throw Exception('Failed to fetch vehicles');
    }
  }

  Future<Vehicle> getVehicleById(String id) async {
    try {
      final response = await _dio.get('/vehicles/$id');
      print('Vehicle API Response: ${response.data}'); // Debug log
      return Vehicle.fromJson(response.data);
    } catch (e) {
      print('Error fetching vehicle: $e');
      throw Exception('Failed to fetch vehicle details');
    }
  }

  Future<List<Accessory>> getAccessoriesForVehicle(String vehicleId) async {
    try {
      final response = await _dio.get('/vehicles/$vehicleId');
      final vehicleData = response.data;

      print('Tapiwa Text: ${response.data}');

      if (vehicleData == null || vehicleData['accessories'] == null) {
        return [];
      }

      // Parse accessories
      return (vehicleData['accessories'] as List).map((accessoryWrapper) {
        final accessoryData = accessoryWrapper['accessories_id'];
        if (accessoryData == null) return null;

        // Ensure the type field is extracted and normalized
        accessoryData['type'] = accessoryData['type']?.toString().toLowerCase() ?? 'exterior';

        // Add category name if available
        if (accessoryData['category'] != null) {
          accessoryData['category_name'] = accessoryData['category']['name'];
        }

        return Accessory.fromJson(accessoryData);
      }).whereType<Accessory>().toList(); // Filter out nulls
    } catch (e) {
      print('Error fetching accessories: $e');
      throw Exception('Failed to fetch accessories');
    }
  }


  Future<List<Video>> getVideos({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/videos',
        queryParameters: {'limit': limit},
      );

      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response format');
      }

      return (response.data['data'] as List)
          .map((json) => Video.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching videos: $e');
      throw Exception('Failed to fetch videos');
    }
  }

  Future<List<Vehicle>> searchVehicles(String query) async {
    try {
      final response = await _dio.get(
        '/vehicles',
        queryParameters: {'search': query},
      );

      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response format');
      }

      return (response.data['data'] as List)
          .map((json) => Vehicle.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching vehicles: $e');
      throw Exception('Failed to search vehicles');
    }
  }

  Future<List<Accessory>> searchAccessories(String query) async {
    try {
      final response = await _dio.get(
        '/accessories',
        queryParameters: {'search': query},
      );

      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response format');
      }

      return (response.data['data'] as List)
          .map((json) => Accessory.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching accessories: $e');
      throw Exception('Failed to search accessories');
    }
  }

  Future<List<Notification>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications');

      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response format');
      }

      return (response.data['data'] as List)
          .map((json) => Notification.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Failed to fetch notifications');
    }
  }

  Future<List<Dealer>> getDealers() async {
    try {
      final response = await _dio.get('/dealers');
      if (response.data == null || response.data['data'] == null) {
        throw Exception('Invalid response format');
      }

      // Extract 'data' key
      return (response.data['data'] as List<dynamic>)
          .map((json) => Dealer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching dealers: $e');
      throw Exception('Failed to fetch dealers');
    }
  }


}