import '../models/cart_item.dart';
import '../models/order_record.dart';

class CheckoutInput {
  const CheckoutInput({
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.notes,
  });

  final String customerName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String notes;
}

abstract class OrderRepository {
  Stream<List<OrderRecord>> watchOrders(String userId);
  Future<void> placeCashOnDeliveryOrder({
    required String userId,
    required CheckoutInput input,
    required List<CartItem> items,
  });
}
