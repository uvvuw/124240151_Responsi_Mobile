import 'package:flutter/material.dart';

/// SnackBar yang bisa dipanggil dari controller tanpa BuildContext.
/// messengerKey dipasang di GetMaterialApp (lihat main.dart).
class AppToast {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        // SnackBar yang punya action tidak hilang sendiri kecuali persist: false
        persist: false,
        duration: const Duration(seconds: 4),
        content: Text(message),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      ),
    );
  }
}
