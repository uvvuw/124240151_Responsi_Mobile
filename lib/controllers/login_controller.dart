import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final obscure = true.obs;
  final loading = false.obs;

  String? validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Format email tidak valid';
  }

  String? validatePass(String? v) =>
      (v == null || v.isEmpty) ? 'Password wajib diisi' : null;

  Future<void> login() async {
    if (loading.value) return;
    if (!formKey.currentState!.validate()) return;

    loading.value = true;
    await Get.find<AuthController>().login(emailCtrl.text.trim());
    Get.offAllNamed(Routes.main);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }
}
