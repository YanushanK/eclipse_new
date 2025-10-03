import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eclipse/models/watch_product.dart';

final watchApiServiceProvider = Provider<WatchApiService>((ref) {
  return WatchApiService();
});

class WatchApiService {
  static const String baseUrl = 'https://api.thewatchapi.com/v1';
  static const String apiToken = 'YStVvV524ZZbhvOmvgbcc7X7Bp6b69HC9fsllTsr'; // Replace with your token

  /// Search for watch models
  Future<List<WatchProduct>> searchModels({
    String? search,
    String? brand,
    String? caseMaterial,
    String? movement,
    int limit = 20,
  }) async {
    try {
      final params = {
        'api_token': apiToken,
        if (search != null) 'search': search,
        if (brand != null) 'brand': brand,
        if (caseMaterial != null) 'case_material': caseMaterial,
        if (movement != null) 'movement': movement,
      };

      final uri = Uri.parse('$baseUrl/model/search').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = (data['data'] as List)
            .take(limit)
            .map((item) => WatchProduct.fromJson(item))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load watches: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching watches: $e');
      return _getFallbackWatches();
    }
  }

  /// Get list of brands
  Future<List<String>> getBrands() async {
    try {
      final uri = Uri.parse('$baseUrl/brand/list').replace(queryParameters: {
        'api_token': apiToken,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['data']);
      }
    } catch (e) {
      print('Error fetching brands: $e');
    }
    return ['Rolex', 'Patek Philippe', 'Audemars Piguet', 'Omega', 'TAG Heuer'];
  }

  /// Fallback watches for offline/error scenarios
  List<WatchProduct> _getFallbackWatches() {
    return [
      WatchProduct(
        brand: 'Rolex',
        referenceNumber: '126500LN',
        model: 'Rolex Daytona',
        movement: 'Automatic',
        yearOfProduction: '2016 - Present',
        caseMaterial: 'Steel',
        caseDiameter: '40 mm',
        description: 'The iconic Daytona chronograph in stainless steel.',
        currentPrice: 45000,
      ),
      WatchProduct(
        brand: 'Patek Philippe',
        referenceNumber: '5711/1A',
        model: 'Nautilus',
        movement: 'Automatic',
        yearOfProduction: '2006 - 2021',
        caseMaterial: 'Steel',
        caseDiameter: '40 mm',
        description: 'The legendary Nautilus sports watch.',
        currentPrice: 95000,
      ),
      WatchProduct(
        brand: 'Audemars Piguet',
        referenceNumber: '15500ST',
        model: 'Royal Oak',
        movement: 'Automatic',
        yearOfProduction: '2019 - Present',
        caseMaterial: 'Steel',
        caseDiameter: '41 mm',
        description: 'The Royal Oak, a masterpiece of watchmaking.',
        currentPrice: 32000,
      ),
    ];
  }
}

// Provider for watch products
final watchProductsProvider = FutureProvider<List<WatchProduct>>((ref) async {
  final service = ref.watch(watchApiServiceProvider);
  return await service.searchModels(
    brand: 'Rolex',
    limit: 20,
  );
});