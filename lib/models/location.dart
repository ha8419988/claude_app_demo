class Location {
  final int id;
  final String name;
  final String province;
  final String region;
  final String category;
  final String topic;
  final double rating;
  final bool featured;
  final String image;

  const Location({
    required this.id,
    required this.name,
    required this.province,
    required this.region,
    required this.category,
    required this.topic,
    required this.rating,
    required this.featured,
    required this.image,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'] as int,
        name: json['name'] as String,
        province: json['province'] as String,
        region: json['region'] as String,
        category: json['category'] as String,
        topic: json['topic'] as String,
        rating: (json['rating'] as num).toDouble(),
        featured: json['featured'] as bool,
        image: json['image'] as String,
      );
}
