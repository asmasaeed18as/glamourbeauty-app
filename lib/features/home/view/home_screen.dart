import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../viewmodel/home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        return SafeArea(
          child: viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppConstants.appName, style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 6),
                            Text(AppConstants.tagline, style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 20),
                            TextField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search lipstick, blush, skin tint...',
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.tune, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 200,
                              child: PageView.builder(
                                controller: PageController(viewportFraction: 0.92),
                                itemCount: viewModel.banners.length,
                                itemBuilder: (context, index) {
                                  final banner = viewModel.banners[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(28),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            banner.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const _BannerImageFallback(),
                                          ),
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.05),
                                                  Colors.black.withOpacity(0.52),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.22),
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: Text(
                                                    banner.highlight,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 14),
                                                Text(
                                                  banner.title,
                                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  banner.subtitle,
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Colors.white70,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SectionHeader(
                          title: 'Shop by Category',
                          actionLabel: 'See all',
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.products);
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 96,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final category = viewModel.categories[index];
                            return Container(
                              width: 90,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    category.icon,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.name,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    _productSection(
                      context: context,
                      title: 'Featured Picks',
                      products: viewModel.featuredProducts,
                    ),
                    _productSection(
                      context: context,
                      title: 'New Arrivals',
                      products: viewModel.newArrivals,
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
        );
      },
    );
  }

  Widget _productSection({
    required BuildContext context,
    required String title,
    required List<Product> products,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: title,
              actionLabel: 'Browse',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.products),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return SizedBox(
                    width: 210,
                    child: ProductCard(
                      product: product,
                      heroTag: '${title.toLowerCase().replaceAll(' ', '-')}-${product.id}-$index',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerImageFallback extends StatelessWidget {
  const _BannerImageFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD98F89),
            Color(0xFFC75C7E),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          size: 56,
          color: Colors.white,
        ),
      ),
    );
  }
}
