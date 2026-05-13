import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/product.dart';
import '../../../data/repositories/shop_repository.dart';

class ProductsViewModel extends ChangeNotifier {
  ProductsViewModel(this._repository) {
    _subscription = _repository.watchProducts().listen((data) {
      _allProducts = data;
      _applyFilters();
      isLoading = false;
      notifyListeners();
    });
  }

  final ShopRepository _repository;
  late final StreamSubscription<List<Product>> _subscription;

  bool isLoading = true;
  String selectedCategory = 'All';
  List<Product> visibleProducts = const [];
  List<Product> _allProducts = const [];

  List<String> get categories {
    final categorySet = {'All', ..._allProducts.map((product) => product.category)};
    return categorySet.toList();
  }

  void selectCategory(String category) {
    selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (selectedCategory == 'All') {
      visibleProducts = _allProducts;
      return;
    }

    visibleProducts = _allProducts
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  Future<Product?> loadProduct(String id) {
    return _repository.getProductById(id);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
