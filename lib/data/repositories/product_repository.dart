import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:eclipse/data/models/product.dart';



class ProductRepository {
  /// Loads from DummyJSON, falls back to assets/offline_products.json
  Future<List<Product>> loadProducts() async {
    try {
      final r = await http.get(Uri.parse('https://dummyjson.com/products?limit=50'));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        final list = (data['products'] as List).cast<Map<String, dynamic>>();
        return list.map(Product.fromJson).toList();
      }
    } catch (_) {
      // fall through to offline
    }
    final raw = await rootBundle.loadString('assets/offline_products.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final list = (data['products'] as List).cast<Map<String, dynamic>>();
    return list.map(Product.fromJson).toList();
  }
}
