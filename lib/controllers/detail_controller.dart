import 'package:get/get.dart';

import '../models/product.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../utils/app_toast.dart';
import 'cart_controller.dart';

class DetailController extends GetxController {
  final int productId;
  DetailController(this.productId);

  final product = Rxn<Product>();
  final loading = true.obs;
  final error = RxnString();
  final adding = false.obs;

  final _cart = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  /// Ambil detail dari https://fakestoreapi.com/products/{id}
  Future<void> fetch() async {
    loading.value = true;
    error.value = null;
    try {
      product.value = await ApiService.fetchProduct(productId);
    } catch (_) {
      error.value =
          'Detail produk belum bisa dimuat. Periksa koneksi internetmu.';
    } finally {
      loading.value = false;
    }
  }

  Future<void> addToCart() async {
    final p = product.value;
    if (p == null || adding.value || _cart.contains(p.id)) return;

    adding.value = true;
    await _cart.add(p);

    try {
      await NotificationService().show(
        title: 'Masuk keranjang',
        body: '${p.title} berhasil ditambahkan ke keranjang',
      );
    } catch (_) {
      // Notifikasi gagal tidak boleh menggagalkan proses tambah ke keranjang
    }
    adding.value = false;

    AppToast.show(
      '${p.title} masuk keranjang',
      actionLabel: 'Lihat keranjang',
      onAction: () => Get.toNamed(Routes.cart),
    );
  }
}
