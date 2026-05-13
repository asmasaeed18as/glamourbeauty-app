import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/cart/view/cart_screen.dart';
import '../../features/cart/viewmodel/cart_view_model.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/products/view/products_screen.dart';
import '../../features/profile/view/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductsScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Consumer<CartViewModel>(
        builder: (context, cartViewModel, _) {
          return NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              const NavigationDestination(icon: Icon(Icons.grid_view_rounded), selectedIcon: Icon(Icons.grid_view), label: 'Shop'),
              NavigationDestination(
                icon: Badge.count(
                  count: cartViewModel.totalItems,
                  isLabelVisible: cartViewModel.totalItems > 0,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                selectedIcon: Badge.count(
                  count: cartViewModel.totalItems,
                  isLabelVisible: cartViewModel.totalItems > 0,
                  child: const Icon(Icons.shopping_bag),
                ),
                label: 'Cart',
              ),
              const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            ],
          );
        },
      ),
    );
  }
}
