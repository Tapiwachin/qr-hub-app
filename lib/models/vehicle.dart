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
  final String? modelYear;

  Vehicle({
    required this.id,
    required this.accessoryType,
    required this.name,
    required this.description,
    this.image,
    this.accessories,
    this.videos,
    this.modelYear,
  });

  factory Vehicle.empty() {
    return Vehicle(
      id: '',
      name: '',
      description: '',
      image: '',
      accessoryType: '',
      modelYear: null,
    );
  }

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
      modelYear: json['model_year']?.toString(),
    );
  }

  /// Converts the Vehicle object to a JSON-like Map for debugging.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accessory_type': accessoryType,
      'name': name,
      'description': description,
      'image': image,
      'model_year': modelYear,
      'accessories': accessories?.map((a) => a.toJson()).toList(),
      'videos': videos?.map((v) => v.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'accessories_id': accessoriesId?.toJson(),
    };
  }
}
