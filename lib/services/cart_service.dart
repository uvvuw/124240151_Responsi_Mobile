import 'package:hive/hive.dart';

import '../models/product.dart';

// Keranjang disimpan di Hive. Key = email_idProduk, jadi cart tiap akun terpisah.
class CartService {
  static Box get _box => Hive.box('cart');

  static String _key(String email, int id) => '${email}_$id';

  static Future<void> add(String email, Product p) {
    return _box.put(_key(email, p.id), {'email': email, ...p.toMap()});
  }

  static bool contains(String email, int id) =>
      _box.containsKey(_key(email, id));

  static List<Product> getProducts(String email) {
    return _box.values
        .where((e) => e['email'] == email)
        .map((e) => Product.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static int count(String email) => getProducts(email).length;

  static Future<void> remove(String email, int id) {
    return _box.delete(_key(email, id));
  }
}
