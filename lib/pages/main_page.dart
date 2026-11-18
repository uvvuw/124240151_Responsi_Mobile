import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack: halaman tidak dibuat ulang saat pindah tab
      body: Obx(
        () => IndexedStack(
          index: controller.index.value,
          children: const [HomePage(), ProfilePage()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.index.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
