class WatchProduct {
  final String brand;
  final String referenceNumber;
  final String model;
  final String? movement;
  final String? yearOfProduction;
  final String? caseMaterial;
  final String? caseDiameter;
  final String? description;
  final double? currentPrice; // We'll fetch this separately or estimate

  WatchProduct({
    required this.brand,
    required this.referenceNumber,
    required this.model,
    this.movement,
    this.yearOfProduction,
    this.caseMaterial,
    this.caseDiameter,
    this.description,
    this.currentPrice,
  });

  factory WatchProduct.fromJson(Map<String, dynamic> json) {
    return WatchProduct(
      brand: json['brand'] as String,
      referenceNumber: json['reference_number'] as String,
      model: json['model'] as String,
      movement: json['movement'] as String?,
      yearOfProduction: json['year_of_production'] as String?,
      caseMaterial: json['case_material'] as String?,
      caseDiameter: json['case_diameter'] as String?,
      description: json['description'] as String?,
      currentPrice: json['current_price'] as double?,
    );
  }

  String get id => referenceNumber;

  // Generate image URL (placeholder or real if API provides)
  String get imageUrl => 'https://via.placeholder.com/400x400?text=${brand}+${model.replaceAll(' ', '+')}';
}
