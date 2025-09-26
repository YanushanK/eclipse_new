import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> get products => _products;

  Future<void> load({required bool online}) async {
    try {
      if (online) {
        // Public API (DummyJSON)
        final r = await http.get(Uri.parse('https://dummyjson.com/products?limit=50'));
        final data = jsonDecode(r.body) as Map<String, dynamic>;
        _products = (data['products'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        // Offline JSON
        final raw = await rootBundle.loadString('assets/offline_products.json');
        final data = jsonDecode(raw) as Map<String, dynamic>;
        _products = (data['products'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      }
      notifyListeners();
    } catch (_) {
      // fallback to offline on any error
      final raw = await rootBundle.loadString('assets/offline_products.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _products = (data['products'] as List).map((e) => Map<String, dynamic>.from(e)).toList();
      notifyListeners();
    }
  }
}
