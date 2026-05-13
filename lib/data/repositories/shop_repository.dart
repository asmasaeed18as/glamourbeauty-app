import '../models/beauty_banner.dart';
import '../models/beauty_category.dart';
import '../models/product.dart';

abstract class ShopRepository {
  Stream<List<BeautyBanner>> watchBanners();
  Stream<List<BeautyCategory>> watchCategories();
  Stream<List<Product>> watchProducts();
  Future<Product?> getProductById(String id);
}
