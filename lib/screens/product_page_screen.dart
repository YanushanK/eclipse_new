// lib/screens/product_page_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eclipse/data/models/product.dart';
import 'package:eclipse/data/providers.dart';

class ProductPageScreen extends ConsumerWidget {
  const ProductPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWatches = ref.watch(watchesProvider);

    return asyncWatches.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: Center(child: Text('Failed to load products: $e')),
      ),
      data: (products) => Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, i) => _ProductCard(product: products[i]),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, '/product-detail', arguments: product),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: product.thumbnail.isNotEmpty
                  ? Image.network(
                product.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.watch),
              )
                  : const Icon(Icons.watch),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (product.brand != null)
                    Text(product.brand!, style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                  Text('\$${product.price}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}