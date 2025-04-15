class CatModel {
  final String url;
  final String breed;
  final String description;
  final String temperament;
  final String origin;

  CatModel({
    required this.url,
    required this.breed,
    required this.description,
    required this.temperament,
    required this.origin,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breedInfo = json['breeds'].isNotEmpty ? json['breeds'][0] : {};
    return CatModel(
      url: json['url'],
      breed: breedInfo['name'] ?? 'Unknown',
      description: breedInfo['description'] ?? 'Similar cat',
      temperament: breedInfo['temperament'] ?? 'Calm',
      origin: breedInfo['origin'] ?? 'Unknown',
    );
  }
}
