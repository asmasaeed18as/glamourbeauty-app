import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.heroTag,
  });

  final Product product;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: ProductDetailArgs(
              productId: product.id,
              heroTag: heroTag,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _CardImageFallback(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.brand.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    formatPrice(product.price),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(product.rating.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailArgs {
  const ProductDetailArgs({
    required this.productId,
    required this.heroTag,
  });

  final String productId;
  final String heroTag;
}

class _CardImageFallback extends StatelessWidget {
  const _CardImageFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.25),
            Theme.of(context).colorScheme.secondary.withOpacity(0.55),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.spa_outlined,
          size: 42,
          color: Colors.white,
        ),
      ),
    );
  }
}
