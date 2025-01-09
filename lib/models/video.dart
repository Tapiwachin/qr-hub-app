class Video {
  final String id;
  final String title;
  final String? videoUrl;
  final String? thumbnailImage; // Changed from thumbnailUrl to match API
  final String? description;
  final String? duration;

  Video({
    required this.id,
    required this.title,
    this.videoUrl,
    this.thumbnailImage,
    this.description,
    this.duration,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      videoUrl: json['video_url'],
      thumbnailImage: json['thumbnail_image'],
      description: json['description'],
      duration: json['duration']?.toString(),
    );
  }

  /// Converts the Video object to a JSON-like Map for debugging or serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'video_url': videoUrl,
      'thumbnail_image': thumbnailImage,
      'description': description,
      'duration': duration,
    };
  }

  String? get thumbnailUrl => thumbnailImage != null
      ? 'http://localhost:8055/assets/$thumbnailImage'
      : null;
}
