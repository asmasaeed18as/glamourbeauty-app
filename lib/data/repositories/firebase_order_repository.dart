import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_item.dart';
import '../models/order_record.dart';
import 'order_repository.dart';

class FirebaseOrderRepository implements OrderRepository {
  FirebaseOrderRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<void> placeCashOnDeliveryOrder({
    required String userId,
    required CheckoutInput input,
    required List<CartItem> items,
  }) async {
    final orderRef = _firestore.collection('orders').doc();
    final cartItemsRef = _firestore.collection('carts').doc(userId).collection('items');
    final cartSnapshot = await cartItemsRef.get();
    final totalAmount = items.fold<double>(0, (sum, item) => sum + item.subtotal);

    final batch = _firestore.batch();
    batch.set(orderRef, {
      'userId': userId,
      'customerName': input.customerName,
      'email': input.email,
      'phone': input.phone,
      'address': input.address,
      'city': input.city,
      'notes': input.notes,
      'paymentMethod': 'Cash on Delivery',
      'status': 'Pending',
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toMap()).toList(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    for (final doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Stream<List<OrderRecord>> watchOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs
          .map((doc) => OrderRecord.fromMap(doc.id, doc.data()))
          .toList();
      orders.sort((a, b) {
        final left = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final right = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return right.compareTo(left);
      });
      return orders;
    });
  }
}
