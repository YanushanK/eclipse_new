// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:eclipse/data/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                ? Image.network(
              p.images.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.watch),
            )
                : (p.thumbnail.isNotEmpty
                ? Image.network(
              p.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.watch),
            )
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
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart (hook up later)')),
            ),
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