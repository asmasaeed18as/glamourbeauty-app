import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../cart/viewmodel/cart_view_model.dart';
import '../viewmodel/products_view_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.heroTag,
  });

  final String productId;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProductsViewModel>();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: viewModel.loadProduct(productId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final product = snapshot.data;
            if (product == null) {
              return const Center(child: Text('Product not found'));
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 320,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: heroTag,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _ProductImageFallback(),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.brand, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber.shade700),
                            const SizedBox(width: 6),
                            Text('${product.rating}'),
                            const SizedBox(width: 8),
                            Text('(${product.reviewCount} reviews)'),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 18),
                        Text('Available shades', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.shades.map((shade) => Chip(label: Text(shade))).toList(),
                        ),
                        const SizedBox(height: 26),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price', style: Theme.of(context).textTheme.bodyMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatPrice(product.price),
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ],
                                ),
                                FilledButton.icon(
                                  onPressed: () async {
                                    final added = await context.read<CartViewModel>().addToCart(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          added
                                              ? '${product.name} added to cart'
                                              : 'Sign in first to save items in your cart',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.shopping_bag_outlined),
                                  label: const Text('Add to Cart'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductImageFallback extends StatelessWidget {
  const _ProductImageFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.45),
            Theme.of(context).colorScheme.primary.withOpacity(0.75),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 52,
          color: Colors.white,
        ),
      ),
    );
  }
}
