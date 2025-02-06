class Accessory {
  final String id;
  final String name;
  final String type;
  final String partNumber;
  final String? image;
  final String? description;
  final double? price;
  final String? category;
  final String? categoryName;
  final String? accessoryType;
  final String? availability;

  Accessory({
    required this.id,
    required this.name,
    required this.type,
    required this.partNumber,
    this.image,
    this.description,
    this.price,
    this.category,
    this.categoryName,
    this.accessoryType,
    this.availability,
  });

  factory Accessory.fromJson(Map<String, dynamic> json) {
    return Accessory(
      id: json['id'].toString(), // Convert to String if necessary
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      partNumber: json['part_number'] ?? '',
      image: json['image'],
      description: json['description'],
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      category: json['category'] ?? '',
      categoryName: json['category_name'],
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
