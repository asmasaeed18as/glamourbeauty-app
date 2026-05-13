import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/cart_item.dart';
import '../../../data/models/order_record.dart';
import '../../../data/repositories/order_repository.dart';
import '../../auth/viewmodel/auth_view_model.dart';

class OrdersViewModel extends ChangeNotifier {
  OrdersViewModel(this._repository);

  final OrderRepository _repository;
  StreamSubscription<List<OrderRecord>>? _subscription;
  List<OrderRecord> _orders = [];
  String? _userId;
  bool isSubmitting = false;
  String? errorMessage;

  List<OrderRecord> get orders => List.unmodifiable(_orders);
  bool get isAuthenticated => _userId != null;

  void bindAuth(AuthViewModel authViewModel) {
    final nextUserId = authViewModel.currentUser?.uid;
    if (_userId == nextUserId) {
      return;
    }

    _userId = nextUserId;
    _subscription?.cancel();
    _subscription = null;

    if (_userId == null) {
      _orders = [];
      notifyListeners();
      return;
    }

    _subscription = _repository.watchOrders(_userId!).listen((orders) {
      _orders = orders;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<bool> placeCashOnDeliveryOrder({
    required CheckoutInput input,
    required List<CartItem> items,
  }) async {
    if (_userId == null) {
      errorMessage = 'Please sign in first.';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repository.placeCashOnDeliveryOrder(
        userId: _userId!,
        input: input,
        items: items,
      );
      return true;
    } catch (_) {
      errorMessage = 'Unable to place order right now.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
