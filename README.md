# Shopedia (124240151_Responsi_Mobile)

Login: email dan password bebas.

## Struktur folder

```
lib/
├── main.dart                     # init Hive, notifikasi, session; GetMaterialApp
├── routes/
│   ├── app_routes.dart           # nama route
│   └── app_pages.dart            # daftar halaman
├── bindings/
│   └── app_bindings.dart         # dependency injection controller
├── controllers/
│   ├── auth_controller.dart      # email yang sedang login
│   ├── cart_controller.dart      # isi keranjang (Hive)
│   ├── login_controller.dart     # form & validasi login
│   ├── main_controller.dart      # tab bottom navigation
│   ├── home_controller.dart      # daftar produk, pencarian
│   └── detail_controller.dart    # detail produk, tambah ke keranjang
├── models/
│   └── product.dart              # model Product & Rating
├── services/
│   ├── api_service.dart          # fetch & parse API
│   ├── session_service.dart      # SharedPreferences
│   ├── cart_service.dart         # Hive
│   └── notification_service.dart # notifikasi lokal
├── pages/
│   ├── login_page.dart
│   ├── main_page.dart            # BottomNavigationBar (Beranda, Profil)
│   ├── home_page.dart            # GridView produk
│   ├── detail_page.dart
│   ├── cart_page.dart
│   └── profile_page.dart
├── widgets/
│   └── product_image.dart
├── theme/
│   └── app_theme.dart
└── utils/
    ├── format.dart
    └── app_toast.dart
```
