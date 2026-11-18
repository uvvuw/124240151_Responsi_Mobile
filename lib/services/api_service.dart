import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const _base = 'https://fakestoreapi.com/products';
  static const _headers = {
    'Accept': 'application/json',
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
  };

  // Daftar semua produk
  static Future<List<Product>> fetchProducts() async {
    final res = await http
        .get(Uri.parse(_base), headers: _headers)
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat produk (${res.statusCode})');
    }
    final data = jsonDecode(res.body) as List;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Detail satu produk berdasarkan id
  static Future<Product> fetchProduct(int id) async {
    final res = await http
        .get(Uri.parse('$_base/$id'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw Exception('Gagal memuat detail (${res.statusCode})');
    }
    final body = res.body.trim();
    if (body.isEmpty || body == 'null') {
      throw Exception('Produk tidak ditemukan');
    }
    return Product.fromJson(jsonDecode(body) as Map<String, dynamic>);
  }
}
