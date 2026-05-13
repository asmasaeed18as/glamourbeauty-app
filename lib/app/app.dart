import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/firebase_auth_repository.dart';
import '../data/repositories/firebase_cart_repository.dart';
import '../data/repositories/firebase_order_repository.dart';
import '../data/repositories/firebase_shop_repository.dart';
import '../data/repositories/order_repository.dart';
import '../data/repositories/shop_repository.dart';
import '../features/auth/viewmodel/auth_view_model.dart';
import '../features/cart/view/cart_screen.dart';
import '../features/cart/viewmodel/cart_view_model.dart';
import '../features/home/view/home_screen.dart';
import '../features/home/viewmodel/home_view_model.dart';
import '../features/orders/view/checkout_screen.dart';
import '../features/orders/viewmodel/orders_view_model.dart';
import '../features/products/view/product_detail_screen.dart';
import '../features/products/view/products_screen.dart';
import '../features/products/viewmodel/products_view_model.dart';
import '../features/profile/view/profile_screen.dart';
import '../shared/widgets/main_shell.dart';
import '../shared/widgets/product_card.dart';
import 'routes.dart';
import 'theme.dart';

class GlamoraApp extends StatelessWidget {
  const GlamoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => FirebaseAuthRepository(),
        ),
        Provider<CartRepository>(
          create: (_) => FirebaseCartRepository(),
        ),
        Provider<OrderRepository>(
          create: (_) => FirebaseOrderRepository(),
        ),
        Provider<ShopRepository>(
          create: (_) => FirebaseShopRepository(),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),
        ChangeNotifierProxyProvider<ShopRepository, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<ShopRepository>()),
          update: (_, repository, viewModel) => viewModel ?? HomeViewModel(repository),
        ),
        ChangeNotifierProxyProvider<ShopRepository, ProductsViewModel>(
          create: (context) => ProductsViewModel(context.read<ShopRepository>()),
          update: (_, repository, viewModel) => viewModel ?? ProductsViewModel(repository),
        ),
        ChangeNotifierProxyProvider2<CartRepository, AuthViewModel, CartViewModel>(
          create: (context) => CartViewModel(context.read<CartRepository>()),
          update: (_, repository, authViewModel, viewModel) {
            final cartViewModel = viewModel ?? CartViewModel(repository);
            cartViewModel.bindAuth(authViewModel);
            return cartViewModel;
          },
        ),
        ChangeNotifierProxyProvider2<OrderRepository, AuthViewModel, OrdersViewModel>(
          create: (context) => OrdersViewModel(context.read<OrderRepository>()),
          update: (_, repository, authViewModel, viewModel) {
            final ordersViewModel = viewModel ?? OrdersViewModel(repository);
            ordersViewModel.bindAuth(authViewModel);
            return ordersViewModel;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Glamora Beauty',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        initialRoute: AppRoutes.shell,
        routes: {
          AppRoutes.shell: (_) => const MainShell(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.products: (_) => const ProductsScreen(),
          AppRoutes.cart: (_) => const CartScreen(),
          AppRoutes.profile: (_) => const ProfileScreen(),
          AppRoutes.checkout: (_) => const CheckoutScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.productDetail) {
            final args = settings.arguments as ProductDetailArgs;
            return MaterialPageRoute<void>(
              builder: (_) => ProductDetailScreen(
                productId: args.productId,
                heroTag: args.heroTag,
              ),
            );
          }

          return null;
        },
      ),
    );
  }
}
