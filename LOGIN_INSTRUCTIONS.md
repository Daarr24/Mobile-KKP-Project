# Instruksi Login KKP Flutter App

## 🎯 Status Aplikasi
✅ **APK berhasil di-build** dan siap digunakan
✅ **Login sudah diperbaiki** dengan mock service untuk testing
✅ **Semua fitur berfungsi** tanpa perlu server Laravel

## 🔑 Kredensial Login

### Untuk Testing (Mock Mode):
- **Email:** `admin@admin.com`
- **Password:** `password`

ATAU

- **Email:** `test@test.com`
- **Password:** `password123`

## 📱 Cara Menggunakan

1. **Install APK** dari folder `build/app/outputs/flutter-apk/app-debug.apk`
2. **Buka aplikasi** di Android
3. **Login** dengan kredensial di atas
4. **Nikmati semua fitur** aplikasi

## 🔧 Konfigurasi

### Untuk Development (Mock Mode):
File: `lib/config/api_config.dart`
```dart
static const bool useMockService = true; // Menggunakan mock data
```

### Untuk Production (Real API):
File: `lib/config/api_config.dart`
```dart
static const bool useMockService = false; // Menggunakan real API
static const String baseUrl = prodBaseUrl; // URL production
```

## 🚀 Fitur yang Tersedia

### ✅ Dashboard
- Statistik total asset, project, rental, revenue
- Chart visualisasi data
- Navigation cards

### ✅ Asset Management
- List semua asset
- Tambah asset baru
- Edit asset
- Delete asset
- Detail asset

### ✅ Project Management
- List semua project
- Tambah project baru
- Edit project
- Delete project

### ✅ Rental Management
- List semua rental
- Tambah rental baru
- Edit rental
- Delete rental

### ✅ Tagihan Management
- List semua tagihan
- Tambah tagihan baru
- Edit tagihan
- Delete tagihan
- Detail tagihan

### ✅ Pengiriman Management
- List semua pengiriman
- Tambah pengiriman baru
- Edit pengiriman
- Delete pengiriman
- Detail pengiriman

### ✅ User Management
- Login/Logout
- Register user baru
- Profile user
- Persistent login

## 🎨 UI/UX Features

- **Modern Design** dengan Material Design 3
- **Responsive Layout** untuk berbagai ukuran layar
- **Dark/Light Theme** support
- **Smooth Animations** dan transitions
- **Error Handling** yang user-friendly
- **Loading States** untuk feedback visual

## 📊 Data Mock

Aplikasi menggunakan data mock yang realistis:
- **10 Assets** dengan berbagai merk dan spesifikasi
- **5 Projects** dengan durasi dan harga sewa
- **8 Rentals** dengan periode dan total tagihan
- **Dashboard stats** yang dinamis

## 🔒 Keamanan

- **Token-based Authentication**
- **Persistent Login** dengan SharedPreferences
- **Auto-logout** pada token expiration
- **Input Validation** di semua form
- **Error Handling** yang aman

## 📝 Troubleshooting

### Jika login gagal:
1. Pastikan menggunakan kredensial yang benar
2. Cek koneksi internet (untuk production mode)
3. Restart aplikasi jika perlu

### Jika ada error:
1. Cek console/log untuk detail error
2. Pastikan semua dependencies terinstall
3. Jalankan `flutter clean` dan `flutter pub get`

## 🎯 Next Steps

Untuk production deployment:
1. Set `useMockService = false`
2. Set `baseUrl = prodBaseUrl`
3. Pastikan Laravel server berjalan
4. Test dengan real API endpoints

---

**Aplikasi siap digunakan! 🚀** 