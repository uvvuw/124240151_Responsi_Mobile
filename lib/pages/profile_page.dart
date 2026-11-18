import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class ProfilePage extends GetView<AuthController> {
  const ProfilePage({super.key});

  Future<void> _logout() async {
    await controller.logout();
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.card(radius: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.seed,
                  child: Icon(Icons.person, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email dari SharedPreferences
                      Obx(
                        () => Text(
                          controller.email.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.ink,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Jumlah produk di keranjang dari Hive
                      Obx(
                        () => Text(
                          'Jumlah produk di keranjang: ${cart.count}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}