// lib/data/models/product.dart
class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final String thumbnail;
  final List<String> images;
  final String? brand;

  // Optional fields your UI expects:
  final String? availability; // derived from 'stock' when possible
  final int? year;
  final String? caseSize;
  final String? movement;
  final String? material;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    this.brand,
    this.availability,
    this.year,
    this.caseSize,
    this.movement,
    this.material,
  });

  factory Product.fromJson(Map<String, dynamic> j) {
    final stock = (j['stock'] is num) ? (j['stock'] as num).toInt() : 0;
    return Product(
      id: (j['id'] as num).toInt(),
      title: j['title']?.toString() ?? 'Untitled',
      description: j['description']?.toString() ?? '',
      price: j['price'] ?? 0,
      thumbnail: j['thumbnail']?.toString() ?? '',
      images: (j['images'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      brand: j['brand']?.toString(),
      availability: stock > 0 ? 'In Stock' : 'Out of Stock',
      year: null,
      caseSize: null,
      movement: null,
      material: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'thumbnail': thumbnail,
    'images': images,
    'brand': brand,
    'availability': availability,
    'year': year,
    'caseSize': caseSize,
    'movement': movement,
    'material': material,
  };
}
