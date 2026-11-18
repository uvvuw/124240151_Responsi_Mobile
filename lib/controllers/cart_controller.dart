import 'package:get/get.dart';

import '../models/product.dart';
import '../services/cart_service.dart';
import '../utils/app_toast.dart';
import 'auth_controller.dart';

/// Isi keranjang milik akun yang sedang login (data asli di Hive).
class CartController extends GetxController {
  final items = <Product>[].obs;
  late final AuthController _auth;

  String get _email => _auth.email.value;

  @override
  void onInit() {
    super.onInit();
    _auth = Get.find<AuthController>();
    // Ganti akun (login/logout) -> muat ulang cart akun tersebut
    ever(_auth.email, (_) => reload());
    reload();
  }

  void reload() {
    items.assignAll(
      _email.isEmpty ? <Product>[] : CartService.getProducts(_email),
    );
  }

  int get count => items.length;

  double get total => items.fold<double>(0, (s, p) => s + p.price);

  bool contains(int productId) => items.any((p) => p.id == productId);

  Future<void> add(Product p) async {
    await CartService.add(_email, p);
    reload();
  }

  Future<void> remove(Product p) async {
    await CartService.remove(_email, p.id);
    reload();
    AppToast.show(
      '${p.title} dihapus dari keranjang',
      actionLabel: 'Urungkan',
      onAction: () => add(p),
    );
  }
}
