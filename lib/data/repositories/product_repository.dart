import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:eclipse/data/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductRepository {

  String? get watchApiToken => dotenv.env['WATCH_API_TOKEN'];

  Future<List<Product>> loadProducts() async {
    print('🔍 Starting product load...');

    // Try Watch API first
    if (watchApiToken != null && watchApiToken!.isNotEmpty) {
      try {
        print('🌐 Trying Watch API...');
        final uri = Uri.parse('https://api.thewatchapi.com/v1/model/search').replace(
          queryParameters: {
            'api_token': watchApiToken,
            'search': 'omega speedmaster ',
            'reference_number': '310.30.42.50.01.001',
            'limit': '3',
          },
        );

        print('📡 URL: $uri');
        final r = await http.get(uri);
        print('📊 Status: ${r.statusCode}');

        if (r.statusCode == 200) {
          final data = jsonDecode(r.body);
          final list = (data['data'] as List).cast<Map<String, dynamic>>();

          print('✅ Watch API success! Got ${list.length} watches');
          print('📦 API Response: $data');

          return list.map((item) => Product(
            id: item['reference_number'].hashCode,
            title: item['model'] ?? 'Unknown Model',
            description: (item['description'] != null && item['description'].toString().isNotEmpty)
                ? (item['description'].toString().length > 200
                ? item['description'].toString().substring(0, 200)
                : item['description'].toString())
                : 'No description available',  // ← Handle null description
            price: 25000,
            brand: item['brand'],
            thumbnail: 'https://via.placeholder.com/400x400?text=${Uri.encodeComponent(item['brand'] ?? '')}',
            images: ['https://via.placeholder.com/800x600?text=${Uri.encodeComponent(item['brand'] ?? '')}'],
            availability: 'In Stock',
            year: _extractYear(item['year_of_production']),
            caseSize: item['case_diameter'],
            movement: item['movement'],
            material: item['case_material'],
          )).toList();
        } else {
          print('❌ Watch API error: ${r.body}');
        }
      } catch (e) {
        print('❌ Watch API exception: $e');
      }
    } else {
      print('⚠️ No Watch API token - skipping');
    }

    // Fallback to DummyJSON
    print('📦 Falling back to DummyJSON...');
    try {
      final r = await http.get(Uri.parse('https://dummyjson.com/products?limit=50'));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        final list = (data['products'] as List).cast<Map<String, dynamic>>();
        print('✅ DummyJSON success! Got ${list.length} products');
        return list.map(Product.fromJson).toList();
      }
    } catch (e) {
      print('❌ DummyJSON failed: $e');
    }

    // Final fallback
    print('📁 Using offline products...');
    final raw = await rootBundle.loadString('assets/offline_products.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final list = (data['products'] as List).cast<Map<String, dynamic>>();
    return list.map(Product.fromJson).toList();
  }

  int? _extractYear(String? yearRange) {
    if (yearRange == null) return null;
    final match = RegExp(r'(\d{4})').firstMatch(yearRange);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }
}

// Map reference numbers to your asset images
String _getWatchImage(String? referenceNumber) {
  final imageMap = {
    '310.30.42.50.01.001': 'assets/images/watch1.jpg', // Your existing one
    '311.30.42.30.01.005': 'assets/images/watch2.jpg', // Add this image
    '326.30.40.50.01.001': 'assets/images/watch3.jpg', // Add this image
  };
  return imageMap[referenceNumber] ?? 'assets/images/watch1.jpg';
}

