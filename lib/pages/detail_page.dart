import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/detail_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/product_image.dart';

class DetailPage extends StatefulWidget {
  final int productId;
  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final String _tag;
  late final DetailController c;

  @override
  void initState() {
    super.initState();
    // Tag unik: satu controller per halaman detail, supaya
    // Home -> Detail A -> Cart -> Detail B tidak saling menimpa.
    _tag = 'detail_${widget.productId}_${identityHashCode(this)}';
    c = Get.put(DetailController(widget.productId), tag: _tag);
  }

  @override
  void dispose() {
    Get.delete<DetailController>(tag: _tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          Obx(
            () => IconButton(
              tooltip: 'Keranjang',
              onPressed: () => Get.toNamed(Routes.cart),
              icon: Badge.count(
                count: cart.count,
                isLabelVisible: cart.count > 0,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(() {
        // Loading indicator saat data detail dimuat
        if (c.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final p = c.product.value;
        if (c.error.value != null || p == null) {
          return _ErrorView(
            message: c.error.value ?? 'Produk tidak ditemukan',
            onRetry: c.fetch,
          );
        }

        return ListView(
          children: [
            // Hero image: paling atas & besar
            Container(
              height: 340,
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: ProductImage(url: p.image, cacheWidth: 800),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    money(p.price),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 20,
                        color: AppTheme.star,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        p.rating.rate.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${p.rating.count} ulasan)',
                        style: const TextStyle(color: AppTheme.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.soft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      prettyCategory(p.category),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.muted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: const TextStyle(height: 1.5, color: AppTheme.ink),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      // Tombol berubah tergantung produk sudah ada di keranjang atau belum
      bottomNavigationBar: Obx(() {
        final p = c.product.value;
        if (p == null) return const SizedBox.shrink();

        final inCart = cart.contains(p.id);
        final adding = c.adding.value;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              child: inCart
                  ? FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                      ),
                      onPressed: () => Get.toNamed(Routes.cart),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Sudah di Keranjang'),
                    )
                  : FilledButton.icon(
                      onPressed: adding ? null : c.addToCart,
                      icon: adding
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.add_shopping_cart),
                      label: const Text('Masukkan ke Keranjang'),
                    ),
            ),
          ),
        );
      }),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 56,
              color: AppTheme.mutedLight,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              style: FilledButton.styleFrom(minimumSize: const Size(140, 46)),
              onPressed: onRetry,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
