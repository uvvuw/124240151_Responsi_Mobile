import 'package:get/get.dart';

import '../bindings/app_bindings.dart';
import '../pages/cart_page.dart';
import '../pages/detail_page.dart';
import '../pages/login_page.dart';
import '../pages/main_page.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: Routes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    // arguments = id produk (int)
    GetPage(
      name: Routes.detail,
      page: () => DetailPage(productId: Get.arguments as int),
    ),
    GetPage(name: Routes.cart, page: () => const CartPage()),
  ];
}
