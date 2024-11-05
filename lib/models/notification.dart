class Notification {
  final String id;
  final String title;
  final String message;
  final String? image;
  final String promotionType;
  final String targetAudience;
  final DateTime scheduleTime;
  final String status;
  final String? relatedVehicle;
  final String? relatedAccessory;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    this.image,
    required this.promotionType,
    required this.targetAudience,
    required this.scheduleTime,
    required this.status,
    this.relatedVehicle,
    this.relatedAccessory,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'].toString(),
      title: json['title'],
      message: json['message'],
      image: json['image'],
      promotionType: json['promotion_type'],
      targetAudience: json['target_audience'],
      scheduleTime: DateTime.parse(json['schedule_time']),
      status: json['status'],
      relatedVehicle: json['related_vehicle'],
      relatedAccessory: json['related_accessory'],
    );
  }
}
