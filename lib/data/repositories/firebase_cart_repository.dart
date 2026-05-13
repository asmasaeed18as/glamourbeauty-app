import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import 'cart_repository.dart';

class FirebaseCartRepository implements CartRepository {
  FirebaseCartRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _cartItems(String userId) {
    return _firestore.collection('carts').doc(userId).collection('items');
  }

  @override
  Future<void> addToCart(String userId, Product product) async {
    final ref = _cartItems(userId).doc(product.id);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      final currentQuantity = (snapshot.data()?['quantity'] as num?)?.toInt() ?? 0;
      final cartItem = CartItem(
        product: product,
        quantity: currentQuantity + 1,
      );
      transaction.set(
        ref,
        {
          ...cartItem.toMap(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    });
  }

  @override
  Future<void> decreaseQuantity(String userId, String productId) async {
    final ref = _cartItems(userId).doc(productId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        return;
      }

      final data = snapshot.data()!;
      final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
      if (quantity <= 1) {
        transaction.delete(ref);
      } else {
        transaction.update(ref, {
          'quantity': quantity - 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Future<void> increaseQuantity(String userId, String productId) async {
    final ref = _cartItems(userId).doc(productId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) {
        return;
      }

      final data = snapshot.data()!;
      final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
      transaction.update(ref, {
        'quantity': quantity + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Stream<List<CartItem>> watchCartItems(String userId) {
    return _cartItems(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CartItem.fromMap(doc.data()))
          .toList();
    });
  }
}
