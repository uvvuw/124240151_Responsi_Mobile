import 'package:get/get.dart';

import '../services/session_service.dart';

// Menyimpan email yang sedang login. Dipakai semua halaman.
class AuthController extends GetxController {
  final email = ''.obs;

  bool get isLoggedIn => email.value.isNotEmpty;

  Future<void> loadSession() async {
    email.value = await SessionService.getEmail() ?? '';
  }

  Future<void> login(String value) async {
    await SessionService.login(value);
    email.value = value;
  }

  Future<void> logout() async {
    await SessionService.logout();
    email.value = '';
  }
}
