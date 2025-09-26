// lib/data/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eclipse/data/models/product.dart';
import 'package:eclipse/data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Main products provider your screen should watch.
final watchesProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.loadProducts();
});
