// lib/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/vehicle.dart';
import 'package:toyota_accessory_app/models/video.dart';
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/models/notification.dart';

class ApiService extends GetxService {
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:8055/api-adaptor',
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
      final Map<String, dynamic> queryParams = {};
      if (accessoryType != null) {
        queryParams['accessory_type'] = accessoryType;
      }

      final response =
          await _dio.get('/vehicles', queryParameters: queryParams);

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

  // Add getVehicleById method
  Future<Vehicle> getVehicleById(String id, {String? accessoryType}) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (accessoryType != null) {
        queryParams['accessory_type'] = accessoryType;
      }

      final response = await _dio.get(
        '/vehicles/$id',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        throw Exception('Vehicle not found');
      }

      // Handle both direct data and data wrapped in a data field
      final vehicleData = response.data is Map<String, dynamic> &&
              response.data.containsKey('data')
          ? response.data['data']
          : response.data;

      return Vehicle.fromJson(vehicleData);
    } on DioException catch (e) {
      print('DioError fetching vehicle: $e');
      if (e.response?.statusCode == 404) {
        throw Exception('Vehicle not found');
      }
      throw Exception('Failed to fetch vehicle details');
    } catch (e) {
      print('Error fetching vehicle: $e');
      throw Exception('Failed to fetch vehicle details');
    }
  }

  Future<List<Video>> getVideos({int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/videos',
        queryParameters: {
          'limit': limit,
        },
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
        queryParameters: {
          'search': query,
        },
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
        queryParameters: {
          'search': query,
        },
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
}
