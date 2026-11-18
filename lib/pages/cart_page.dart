import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/product_image.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: Obx(() {
        final items = controller.items.toList();
        if (items.isEmpty) return _buildEmpty(context);

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _CartTile(
                  product: items[i],
                  onDelete: () => controller.remove(items[i]),
                ),
              ),
            ),
            _TotalBar(total: controller.total, count: controller.count),
          ],
        );
      }),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Keranjang masih kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pilih produk di Beranda, lalu masukkan ke keranjang.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(180, 48)),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.storefront_outlined),
              label: const Text('Mulai belanja'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const _CartTile({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.border),
      ),
      child: InkWell(
        // Tap produk -> Detail Page produk tersebut
        onTap: () => Get.toNamed(Routes.detail, arguments: p.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                padding: const EdgeInsets.all(6),
                child: ProductImage(url: p.image, width: 60, height: 60),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      money(p.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppTheme.star,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          p.rating.rate.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.ink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Hapus dari keranjang',
                icon: const Icon(Icons.delete, color: AppTheme.danger),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalBar extends StatelessWidget {
  final double total;
  final int count;

  const _TotalBar({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.ink,
                  ),
                ),
                Text(
                  '$count produk',
                  style: const TextStyle(fontSize: 12, color: AppTheme.muted),
                ),
              ],
            ),
            Text(
              money(total),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
