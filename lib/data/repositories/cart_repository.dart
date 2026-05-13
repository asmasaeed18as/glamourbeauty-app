import '../models/cart_item.dart';
import '../models/product.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watchCartItems(String userId);
  Future<void> addToCart(String userId, Product product);
  Future<void> increaseQuantity(String userId, String productId);
  Future<void> decreaseQuantity(String userId, String productId);
}
