import '../models/beauty_banner.dart';
import '../models/beauty_category.dart';
import '../models/product.dart';
import 'shop_repository.dart';

class MockShopRepository implements ShopRepository {
  final List<BeautyBanner> _banners = const [
    BeautyBanner(
      id: 'banner-1',
      title: 'Spring Glow Kit',
      subtitle: 'Fresh tints, soft shimmer, and hydration-first picks.',
      imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80',
      highlight: 'Save 25%',
    ),
    BeautyBanner(
      id: 'banner-2',
      title: 'Viral Essentials',
      subtitle: 'Top-rated formulas your routine will actually use.',
      imageUrl: 'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?auto=format&fit=crop&w=900&q=80',
      highlight: 'Hot right now',
    ),
  ];

  final List<BeautyCategory> _categories = const [
    BeautyCategory(id: 'cat-1', name: 'Lips', icon: 'LP'),
    BeautyCategory(id: 'cat-2', name: 'Skin', icon: 'SK'),
    BeautyCategory(id: 'cat-3', name: 'Eyes', icon: 'EY'),
    BeautyCategory(id: 'cat-4', name: 'Cheeks', icon: 'CH'),
    BeautyCategory(id: 'cat-5', name: 'Fragrance', icon: 'FG'),
  ];

  final List<Product> _products = const [
    Product(
      id: 'p-1',
      name: 'Cloud Matte Lip Cream',
      brand: 'Luma Beauty',
      category: 'Lips',
      description: 'A whipped matte lip cream with comfortable all-day wear and a blurring finish.',
      price: 18,
      rating: 4.8,
      reviewCount: 128,
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=800&q=80',
      shades: ['Rose Blush', 'Spiced Nude', 'Berry Silk'],
      isFeatured: true,
      isNewArrival: true,
    ),
    Product(
      id: 'p-2',
      name: 'Dew Veil Skin Tint',
      brand: 'Aurelia',
      category: 'Skin',
      description: 'A breathable skin tint that evens tone while keeping a radiant, natural finish.',
      price: 32,
      rating: 4.7,
      reviewCount: 84,
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=800&q=80',
      shades: ['Ivory', 'Sand', 'Honey', 'Walnut'],
      isFeatured: true,
      isNewArrival: false,
    ),
    Product(
      id: 'p-3',
      name: 'Silk Lash Mascara',
      brand: 'Nova Face',
      category: 'Eyes',
      description: 'Lengthening mascara with a flexible brush for lift, curl, and clean separation.',
      price: 21,
      rating: 4.6,
      reviewCount: 63,
      imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=800&q=80',
      shades: ['Midnight', 'Soft Brown'],
      isFeatured: false,
      isNewArrival: true,
    ),
    Product(
      id: 'p-4',
      name: 'Petal Flush Blush Balm',
      brand: 'Maison Bloom',
      category: 'Cheeks',
      description: 'Cream blush balm that melts into skin for a sheer, watercolor glow.',
      price: 24,
      rating: 4.9,
      reviewCount: 151,
      imageUrl: 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=800&q=80',
      shades: ['Peony', 'Coral Kiss', 'Warm Berry'],
      isFeatured: true,
      isNewArrival: true,
    ),
    Product(
      id: 'p-5',
      name: 'Velvet Oud Mist',
      brand: 'Atelier Muse',
      category: 'Fragrance',
      description: 'A warm floral body mist with soft amber, rose, and sandalwood layers.',
      price: 29,
      rating: 4.5,
      reviewCount: 44,
      imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80',
      shades: ['100 ml'],
      isFeatured: false,
      isNewArrival: false,
    ),
    Product(
      id: 'p-6',
      name: 'Gloss Ritual Lip Oil',
      brand: 'Luma Beauty',
      category: 'Lips',
      description: 'A nourishing lip oil with mirror shine and a cushiony, non-sticky feel.',
      price: 16,
      rating: 4.7,
      reviewCount: 92,
      imageUrl: 'https://images.unsplash.com/photo-1619451334792-150fd785ee74?auto=format&fit=crop&w=800&q=80',
      shades: ['Sugar Petal', 'Mocha Glaze', 'Cherry Beam'],
      isFeatured: false,
      isNewArrival: true,
    ),
  ];

  @override
  Future<Product?> getProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    for (final product in _products) {
      if (product.id == id) {
        return product;
      }
    }
    return null;
  }

  @override
  Stream<List<BeautyBanner>> watchBanners() async* {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    yield _banners;
  }

  @override
  Stream<List<BeautyCategory>> watchCategories() async* {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    yield _categories;
  }

  @override
  Stream<List<Product>> watchProducts() async* {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    yield _products;
  }
}
