import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'utils/app_toast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cart');
  try {
    await NotificationService().init();
  } catch (_) {
    // Kalau notifikasi gagal init, app tetap jalan
  }

  // Dua controller ini hidup selama app berjalan (permanent)
  final auth = Get.put(AuthController(), permanent: true);
  await auth.loadSession();
  Get.put(CartController(), permanent: true);

  runApp(MyApp(initialRoute: auth.isLoggedIn ? Routes.main : Routes.login));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shopedia',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      scaffoldMessengerKey: AppToast.messengerKey,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
