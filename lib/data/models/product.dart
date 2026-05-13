class Product {
  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.shades,
    required this.isFeatured,
    required this.isNewArrival,
  });

  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> shades;
  final bool isFeatured;
  final bool isNewArrival;

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      category: map['category'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl'] as String? ?? '',
      shades: (map['shades'] as List<dynamic>? ?? const [])
          .map((shade) => shade.toString())
          .toList(),
      isFeatured: map['isFeatured'] as bool? ?? false,
      isNewArrival: map['isNewArrival'] as bool? ?? false,
    );
  }
}
