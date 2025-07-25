import 'package:flutter/material.dart';

class DocumentationScreen extends StatelessWidget {
  const DocumentationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE63946),
        title: const Text('Documentation'),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'lib/assets/logo_ubl.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Aplikasi KKP - Manajemen Aset Via Computer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF457B9D),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'PERANCANGAN DAN IMPLEMENTASI WEB SERVICE UNTUK SISTEM MANAJEMEN ASET MENGGUNAKAN RESTFUL API PADA VIA COMPUTER',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(
                  'FAKULTAS TEKNOLOGI INFORMASI\nUNIVERSITAS BUDI LUHUR',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 10),
                Text(
                  'Kelompok:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '2211510108 - Haidar Farhan Rizaldi\n2211510264 - Rizky Adhi Nugroho\n2211510413 - Danu Febri Andi Prasetyo',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 18),
                Divider(),
                SizedBox(height: 10),
                Text(
                  'Penjelasan Singkat:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFE63946),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Aplikasi ini adalah sistem manajemen aset berbasis mobile yang terintegrasi dengan backend Laravel melalui RESTful API. Pengguna dapat melakukan login, melihat dashboard, mengelola data asset, project, rental, tagihan, dan pengiriman secara real-time. Semua data tersimpan di server dan dapat diakses dari mana saja.',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 14),
                Text(
                  'Teknologi & Framework:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFE63946),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '- Flutter (Dart) untuk aplikasi mobile\n- Laravel (PHP) untuk backend RESTful API\n- MySQL untuk database\n- Provider & SharedPreferences untuk state management dan penyimpanan token',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 14),
                Text(
                  'Tingkat Keberhasilan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFE63946),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '- Semua fitur utama (login, dashboard, CRUD asset/project/rental/tagihan/pengiriman) berjalan dengan baik dan terintegrasi API.\n- UI/UX modern, responsif, dan konsisten dengan tema web.\n- Error handling dan validasi sudah diterapkan.\n- Persistent login (auto-login) sudah berjalan.\n- Tingkat keberhasilan integrasi API: 100% untuk fitur utama.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
