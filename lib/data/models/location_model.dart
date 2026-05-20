import '../../domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.id,
    required super.name,
    required super.province,
    required super.region,
    required super.category,
    required super.topic,
    required super.rating,
    required super.featured,
    required super.image,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
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
