import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  void add(Map<String, dynamic> p) {
    final idx = _items.indexWhere((e) => e['id'] == p['id']);
    if (idx >= 0) {
      _items[idx]['quantity'] = (_items[idx]['quantity'] ?? 1) + 1;
    } else {
      _items.add({...p, 'quantity': 1});
    }
    notifyListeners();
    saveToPrefs();
  }

  void remove(int id) {
    _items.removeWhere((e) => e['id'] == id);
    notifyListeners();
    saveToPrefs();
  }

  double get total => _items.fold(0.0, (sum, e) => sum + (e['price'] as num) * (e['quantity'] ?? 1));

  Future<void> loadFromPrefs() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString('cart');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _items
        ..clear()
        ..addAll(list.map((e) => Map<String, dynamic>.from(e)));
      notifyListeners();
    }
  }

  Future<void> saveToPrefs() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('cart', jsonEncode(_items));
  }
}
