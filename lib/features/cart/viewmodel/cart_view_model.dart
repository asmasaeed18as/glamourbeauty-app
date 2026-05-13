import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/cart_item.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../auth/viewmodel/auth_view_model.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel(this._repository);

  final CartRepository _repository;
  StreamSubscription<List<CartItem>>? _cartSubscription;
  List<CartItem> _items = [];
  String? _userId;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isAuthenticated => _userId != null;
  bool get isLoading => isAuthenticated && _cartSubscription == null;

  int get totalItems => _items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => _items.fold(0, (total, item) => total + item.subtotal);

  void bindAuth(AuthViewModel authViewModel) {
    final nextUserId = authViewModel.currentUser?.uid;
    if (_userId == nextUserId) {
      return;
    }

    _userId = nextUserId;
    _cartSubscription?.cancel();
    _cartSubscription = null;

    if (_userId == null) {
      _items = [];
      notifyListeners();
      return;
    }

    _cartSubscription = _repository.watchCartItems(_userId!).listen((items) {
      _items = items;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<bool> addToCart(Product product) async {
    if (_userId == null) {
      return false;
    }

    await _repository.addToCart(_userId!, product);
    return true;
  }

  Future<void> increaseQuantity(String productId) async {
    if (_userId == null) {
      return;
    }

    await _repository.increaseQuantity(_userId!, productId);
  }

  Future<void> decreaseQuantity(String productId) async {
    if (_userId == null) {
      return;
    }

    await _repository.decreaseQuantity(_userId!, productId);
  }

  @override
  void dispose() {
    _cartSubscription?.cancel();
    super.dispose();
  }
}
