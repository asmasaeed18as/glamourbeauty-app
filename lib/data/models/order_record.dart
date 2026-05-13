import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item.dart';

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.notes,
    required this.paymentMethod,
    required this.status,
    required this.totalAmount,
    required this.items,
    required this.createdAt,
  });

  final String id;
  final String customerName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String notes;
  final String paymentMethod;
  final String status;
  final double totalAmount;
  final List<CartItem> items;
  final DateTime? createdAt;

  factory OrderRecord.fromMap(String id, Map<String, dynamic> map) {
    final items = (map['items'] as List<dynamic>? ?? const [])
        .map((item) => CartItem.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();

    return OrderRecord(
      id: id,
      customerName: map['customerName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      city: map['city'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      paymentMethod: map['paymentMethod'] as String? ?? 'Cash on Delivery',
      status: map['status'] as String? ?? 'Pending',
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0,
      items: items,
      createdAt: _parseDate(map['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
