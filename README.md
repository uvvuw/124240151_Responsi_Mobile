# Cheatsheet Setup Project Flutter (GetX + Hive + Shared Preferences + Http)

## 1. Buat project

Nama package Dart tidak boleh diawali angka, jadi pakai `--project-name`.
Nama folder/repo tetap `124240151_latres_D`.

```bash
flutter create --project-name toko_online 124240151_latres_D
cd 124240151_latres_D
```

## 2. Tambah library

```bash
flutter pub add get http shared_preferences hive hive_flutter
```

Kalau pakai notifikasi lokal (opsional, bisa keluar di responsi):

```bash
flutter pub add flutter_local_notifications timezone
```

Cek hasilnya di `pubspec.yaml` bagian `dependencies`, lalu:

```bash
flutter pub get
```

## 3. Permission Android

Buka `android/app/src/main/AndroidManifest.xml`.
Tambahkan **di atas** tag `<application ...>` (di dalam `<manifest>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

- `INTERNET` wajib, tanpa ini request API gagal di emulator/HP.
- `POST_NOTIFICATIONS` hanya dibutuhkan kalau pakai notifikasi (Android 13+).

Contoh posisinya:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:label="toko_online"
        ...>
```

## 4. Setting Gradle (hanya kalau pakai flutter_local_notifications)

Buka `android/app/build.gradle.kts`.

Di dalam blok `android { ... }`, bagian `compileOptions`, tambahkan satu baris:

```kotlin
compileOptions {
    isCoreLibraryDesugaringEnabled = true
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
```

Di paling bawah file (blok `dependencies`, kalau belum ada buat baru):

```kotlin
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

Kalau gagal build dengan error `desugar`, berarti dua langkah ini belum ada.

## 5. Buat struktur folder

Jalankan dari folder project:

```bash
mkdir -p lib/{routes,bindings,controllers,models,services,pages,widgets,theme,utils}
```

Isi tiap folder:

| Folder             | Isi                                                         |
| ------------------ | ----------------------------------------------------------- |
| `controllers/`     | state (GetX): auth, cart, login, main, home, detail         |
| `bindings/`        | daftar `Bindings` per route                                 |
| `routes/`          | `app_routes.dart` + `app_pages.dart`                        |
| `models/`          | model Product                                               |
| `services/`        | api, session (SharedPreferences), cart (Hive), notification |
| `pages/`           | login, main, home, detail, cart, profile                    |
| `widgets/`         | widget yang dipakai ulang                                   |
| `theme/`, `utils/` | tema warna, helper format                                   |

## 6. Cek dan jalankan

```bash
flutter clean
flutter pub get
flutter analyze
flutter devices
flutter run
```

Kalau emulator lebih dari satu: `flutter run -d <id_device>`.

## 7. Urutan ngerjain (biar tidak bingung)

1. `main.dart`: `Hive.initFlutter()`, `Hive.openBox('cart')`, cek session, `GetMaterialApp`
2. `session_service`: simpan, baca, dan hapus username (SharedPreferences)
3. Login: username bebas, password = NIM, simpan session
4. `main_page`: bottom navigation (Home, Profile)
5. `api_service` + model: ambil produk dari `https://dummyjson.com/products`
6. Home: username, tombol cart, list produk, tap ke Detail
7. Detail: info produk, qty `0 < qty <= stok`, Add to Cart ke Hive (produk, username, qty)
8. Cart: filter berdasarkan username (key Hive `username_productId`), tombol hapus
9. Profile: username, deskripsi, logout (hapus session, kembali ke Login)

## 8. Upload ke GitHub

```bash
git init
git add .
git commit -m "Latihan responsi toko online (GetX)"
git branch -M main
git remote add origin https://github.com/USERNAME/124240151_latres_D.git
git push -u origin main
```

Kalau ada perubahan setelah itu:

```bash
git add .
git commit -m "Update"
git push
```
