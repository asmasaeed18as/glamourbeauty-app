import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get subtotal => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'product': {
        'id': product.id,
        'name': product.name,
        'brand': product.brand,
        'category': product.category,
        'description': product.description,
        'price': product.price,
        'rating': product.rating,
        'reviewCount': product.reviewCount,
        'imageUrl': product.imageUrl,
        'shades': product.shades,
        'isFeatured': product.isFeatured,
        'isNewArrival': product.isNewArrival,
      },
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    final productMap = (map['product'] as Map<String, dynamic>? ?? const {});
    return CartItem(
      product: Product.fromMap(
        productMap['id'] as String? ?? '',
        productMap,
      ),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
