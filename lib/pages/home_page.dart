import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../models/product.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/product_image.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Row(
          children: [
            Icon(Icons.shopping_bag_rounded, color: AppTheme.seed),
            SizedBox(width: 8),
            Text(
              'Shopedia',
              style: TextStyle(
                color: AppTheme.seed,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: controller.searchCtrl,
              onChanged: controller.setQuery,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Cari produk',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      // Loading indicator saat data daftar produk dimuat
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final err = controller.error.value;
      if (err != null) {
        return _MessageState(
          icon: Icons.wifi_off_rounded,
          title: 'Gagal memuat produk',
          message: err,
          actionLabel: 'Coba lagi',
          onAction: () => controller.fetch(),
        );
      }

      final list = controller.filtered;

      return RefreshIndicator(
        onRefresh: () => controller.fetch(showSpinner: false),
        child: list.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 60),
                  _MessageState(
                    icon: Icons.search_off_rounded,
                    title: 'Produk tidak ditemukan',
                    message: 'Coba kata kunci lain.',
                    actionLabel: 'Reset pencarian',
                    onAction: controller.resetSearch,
                  ),
                ],
              )
            : GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 270,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) => _ProductCard(product: list[i]),
              ),
      );
    });
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product});

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
        onTap: () => Get.toNamed(Routes.detail, arguments: p.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: ProductImage(url: p.image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    money(p.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
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
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppTheme.mutedLight),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.muted),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 20),
              FilledButton.tonal(
                style: FilledButton.styleFrom(minimumSize: const Size(140, 46)),
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
