// lib/models/accessory.dart
class Accessory {
  final String id;
  final String name;
  final String type;
  final String partNumber;
  final String? image;
  final String? description;
  final double? price;
  final String category; // Keep the category ID
  final String? categoryName; // Store the category name
  final String? accessoryType;
  final bool? availability;

  Accessory({
    required this.id,
    required this.name,
    required this.type,
    required this.partNumber,
    this.image,
    this.description,
    this.price,
    required this.category,
    this.categoryName,
    this.accessoryType,
    this.availability,
  });

  factory Accessory.fromJson(Map<String, dynamic> json) {
    return Accessory(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      partNumber: json['part_number'] ?? '',
      image: json['image'],
      description: json['description'],
      price: json['price']?.toDouble(),
      category: json['category']?['id'] ?? '', // Extract category ID
      categoryName: json['category']?['name'] ?? '', // Extract category name
      accessoryType: json['accessory_type'],
      availability: json['availability'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'part_number': partNumber,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'category_name': categoryName,
      'accessory_type': accessoryType,
      'availability': availability,
    };
  }
}
