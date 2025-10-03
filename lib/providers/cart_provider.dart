import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eclipse/models/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cart');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      state = list.map((e) => CartItem.fromJson(e)).toList();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  void addItem(CartItem item) {
    final index = state.indexWhere((e) => e.id == item.id);
    if (index >= 0) {
      state[index].quantity++;
      state = [...state]; // Trigger rebuild
    } else {
      state = [...state, item];
    }
    _saveToPrefs();
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
    _saveToPrefs();
  }

  void updateQuantity(String id, int quantity) {
    final index = state.indexWhere((e) => e.id == id);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(id);
      } else {
        state[index].quantity = quantity;
        state = [...state];
        _saveToPrefs();
      }
    }
  }

  void clear() {
    state = [];
    _saveToPrefs();
  }

  double get subtotal => state.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.1; // 10% tax
  double get shipping => 0.0; // Free shipping
  double get total => subtotal + tax + shipping;
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

// Computed providers
final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartTaxProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  return subtotal * 0.1;
});

final cartTotalProvider = Provider<double>((ref) {
  final subtotal = ref.watch(cartSubtotalProvider);
  final tax = ref.watch(cartTaxProvider);
  return subtotal + tax;
});
