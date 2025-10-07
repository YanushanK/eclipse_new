// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eclipse/data/models/product.dart';
import 'package:eclipse/providers/cart_provider.dart';
import 'package:eclipse/models/cart_item.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Product p = (args is Product)
        ? args
        : Product(
      id: 0,
      title: 'Unknown',
      description: '',
      price: 0,
      thumbnail: '',
      images: const [],
    );

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: p.images.isNotEmpty
                ? (p.images.first.startsWith('assets/')
                ? Image.asset(
              p.images.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.watch),
            )
                : Image.network(
              p.images.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.watch),
            ))
                : (p.thumbnail.isNotEmpty
                ? (p.thumbnail.startsWith('assets/')
                ? Image.asset(
              p.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.watch),
            )
                : Image.network(
              p.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.watch),
            ))
                : const Icon(Icons.watch)),
          ),
          const SizedBox(height: 16),
          Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
          if (p.brand != null)
            Text(p.brand!, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text('\$${p.price}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(p.description),
          const SizedBox(height: 24),
          _buildDetailRow('Availability', p.availability ?? 'In Stock'),
          _buildDetailRow('Year', p.year?.toString() ?? 'Unknown'),
          _buildDetailRow('Case Size', p.caseSize ?? '-'),
          _buildDetailRow('Movement', p.movement ?? '-'),
          _buildDetailRow('Material', p.material ?? '-'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              // Create cart item from product
              final cartItem = CartItem(
                id: p.id.toString(),
                name: p.title,
                brand: p.brand ?? 'Unknown',
                price: p.price.toDouble(),
                imageUrl: p.thumbnail.isNotEmpty
                    ? p.thumbnail
                    : (p.images.isNotEmpty ? p.images.first : ''),
              );

              // Add to cart
              ref.read(cartProvider.notifier).addItem(cartItem);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${p.title} added to cart'),
                  action: SnackBarAction(
                    label: 'VIEW CART',
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}