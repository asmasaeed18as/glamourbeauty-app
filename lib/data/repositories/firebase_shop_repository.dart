import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/beauty_banner.dart';
import '../models/beauty_category.dart';
import '../models/product.dart';
import 'shop_repository.dart';

class FirebaseShopRepository implements ShopRepository {
  FirebaseShopRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<Product?> getProductById(String id) async {
    final snapshot = await _firestore.collection('products').doc(id).get();
    final data = snapshot.data();
    if (!snapshot.exists || data == null) {
      return null;
    }

    return Product.fromMap(snapshot.id, data);
  }

  @override
  Stream<List<BeautyBanner>> watchBanners() {
    return _firestore.collection('banners').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BeautyBanner.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Stream<List<BeautyCategory>> watchCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BeautyCategory.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Stream<List<Product>> watchProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
