/// Model for cart items
class CartItem {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'brand': brand,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      CartItem(
        id: json['id'] as String,
        name: json['name'] as String,
        brand: json['brand'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        quantity: json['quantity'] as int? ?? 1,
      );

}