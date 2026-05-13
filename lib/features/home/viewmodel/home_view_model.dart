import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/beauty_banner.dart';
import '../../../data/models/beauty_category.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/shop_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repository) {
    _listen();
  }

  final ShopRepository _repository;
  StreamSubscription<List<BeautyBanner>>? _bannerSubscription;
  StreamSubscription<List<BeautyCategory>>? _categorySubscription;
  StreamSubscription<List<Product>>? _productSubscription;

  bool isLoading = true;
  List<BeautyBanner> banners = const [];
  List<BeautyCategory> categories = const [];
  List<Product> featuredProducts = const [];
  List<Product> newArrivals = const [];

  void _listen() {
    _bannerSubscription = _repository.watchBanners().listen((data) {
      banners = data;
      _finishLoading();
    });
    _categorySubscription = _repository.watchCategories().listen((data) {
      categories = data;
      _finishLoading();
    });
    _productSubscription = _repository.watchProducts().listen((products) {
      featuredProducts = products.where((product) => product.isFeatured).toList();
      newArrivals = products.where((product) => product.isNewArrival).toList();
      _finishLoading();
    });
  }

  void _finishLoading() {
    isLoading = banners.isEmpty || categories.isEmpty || featuredProducts.isEmpty;
    notifyListeners();
  }

  @override
  void dispose() {
    _bannerSubscription?.cancel();
    _categorySubscription?.cancel();
    _productSubscription?.cancel();
    super.dispose();
  }
}
