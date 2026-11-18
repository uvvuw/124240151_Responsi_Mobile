import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../theme/app_theme.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.shopping_bag_rounded,
                            size: 40,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Shopedia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Belanja mudah, kapan saja.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Masuk',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Masukkan email dan password kamu.',
                                style: TextStyle(color: AppTheme.muted),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: controller.emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_outlined),
                                  labelText: 'Email',
                                ),
                                validator: controller.validateEmail,
                              ),
                              const SizedBox(height: 14),
                              Obx(
                                () => TextFormField(
                                  controller: controller.passCtrl,
                                  obscureText: controller.obscure.value,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => controller.login(),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
                                      tooltip: controller.obscure.value
                                          ? 'Tampilkan password'
                                          : 'Sembunyikan password',
                                      icon: Icon(
                                        controller.obscure.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () =>
                                          controller.obscure.value =
                                              !controller.obscure.value,
                                    ),
                                  ),
                                  validator: controller.validatePass,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Obx(
                                () => FilledButton(
                                  onPressed: controller.loading.value
                                      ? null
                                      : controller.login,
                                  child: controller.loading.value
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Login'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
