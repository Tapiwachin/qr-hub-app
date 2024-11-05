// lib/models/vehicle.dart
import 'package:toyota_accessory_app/models/accessory.dart';
import 'package:toyota_accessory_app/models/video.dart';

class Vehicle {
  final String id;
  final String accessoryType;
  final String name;
  final String description;
  final String? image;
  final List<VehicleAccessory>? accessories;
  final List<Video>? videos;

  Vehicle({
    required this.id,
    required this.accessoryType,
    required this.name,
    required this.description,
    this.image,
    this.accessories,
    this.videos,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'].toString(),
      accessoryType: json['accessory_type'] is List
          ? (json['accessory_type'] as List).first.toString()
          : json['accessory_type'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      accessories: json['accessories'] != null
          ? (json['accessories'] as List)
              .map((a) => VehicleAccessory.fromJson(a))
              .toList()
          : null,
      videos: json['videos'] != null
          ? (json['videos'] as List).map((v) => Video.fromJson(v)).toList()
          : null,
    );
  }
}

class VehicleAccessory {
  final Accessory? accessoriesId;

  VehicleAccessory({required this.accessoriesId});

  factory VehicleAccessory.fromJson(Map<String, dynamic> json) {
    return VehicleAccessory(
      accessoriesId: json['accessories_id'] != null
          ? Accessory.fromJson(json['accessories_id'])
          : null,
    );
  }
}
