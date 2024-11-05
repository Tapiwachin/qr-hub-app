class Category {
  final String id;
  final String name;
  final List<String> accessories;

  Category({
    required this.id,
    required this.name,
    required this.accessories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      accessories: json['accessories'] != null
          ? List<String>.from(json['accessories'])
          : [],
    );
  }
}
