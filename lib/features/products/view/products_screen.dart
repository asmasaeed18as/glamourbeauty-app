import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/product_card.dart';
import '../viewmodel/products_view_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsViewModel>(
      builder: (context, viewModel, _) {
        final width = MediaQuery.sizeOf(context).width;
        final columns = width >= 1000 ? 4 : width >= 700 ? 3 : 2;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Explore Makeup', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Responsive catalog layout with category filtering and product detail routing.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                if (viewModel.isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else ...[
                  Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.categories.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final category = viewModel.categories[index];
                          return ChoiceChip(
                            label: Text(category),
                            selected: viewModel.selectedCategory == category,
                            onSelected: (_) => viewModel.selectCategory(category),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: viewModel.visibleProducts.length,
                      itemBuilder: (context, index) {
                        final product = viewModel.visibleProducts[index];
                        return ProductCard(
                          product: product,
                          heroTag: 'products-${product.id}-$index',
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
