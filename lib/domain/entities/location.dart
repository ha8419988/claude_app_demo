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

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Location && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
