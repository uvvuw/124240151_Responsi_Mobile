import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../utils/app_toast.dart';

class HomeController extends GetxController {
  final searchCtrl = TextEditingController();
  final products = <Product>[].obs;
  final isLoading = true.obs;
  final error = RxnString();
  final query = ''.obs;

  List<Product> get filtered {
    final q = query.value.toLowerCase();
    if (q.isEmpty) return products.toList();
    return products
        .where(
          (p) =>
              p.title.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch({bool showSpinner = true}) async {
    if (showSpinner) {
      isLoading.value = true;
      error.value = null;
    }
    try {
      final data = await ApiService.fetchProducts();
      products.assignAll(data);
      error.value = null;
    } catch (_) {
      if (products.isEmpty) {
        error.value = 'Produk belum bisa dimuat. Periksa koneksi internetmu.';
      } else {
        AppToast.show('Gagal menyegarkan produk');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setQuery(String v) => query.value = v.trim();

  void resetSearch() {
    searchCtrl.clear();
    query.value = '';
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
