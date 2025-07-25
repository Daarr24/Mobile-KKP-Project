import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/asset.dart';
import '../models/project.dart';
import '../models/pengiriman_detail.dart';
import '../models/tagihan_list.dart';
import '../models/tagihan_detail.dart';
import '../models/rental.dart';
import '../models/tagihan.dart';

class MockApiService {
  static const String baseUrl = 'http://localhost:8000/api/vcom';

  Future<String?> login(String email, String password) async {
    try {
      print('Mock login with email: $email');

      // Simulasi delay network
      await Future.delayed(const Duration(seconds: 1));

      // Mock credentials
      if (email == 'admin@admin.com' && password == 'password') {
        final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', mockToken);
        print('Mock login successful, token saved');
        return mockToken;
      } else if (email == 'test@test.com' && password == 'password123') {
        final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', mockToken);
        print('Mock login successful, token saved');
        return mockToken;
      }

      print('Mock login failed: Invalid credentials');
      return null;
    } catch (e) {
      print('Mock login error: $e');
      return null;
    }
  }

  Future<List<Asset>> getAssets() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Asset(
        id: 1,
        merk: 'Dell',
        type: 'Latitude 5520',
        spesifikasi: 'Intel i7, 16GB RAM, 512GB SSD',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      Asset(
        id: 2,
        merk: 'HP',
        type: 'EliteBook 840',
        spesifikasi: 'Intel i5, 8GB RAM, 256GB SSD',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  Future<List<Project>> getProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Project(
        id: 1,
        nama: 'Project A',
        durasiKontrak: 12,
        hargaSewa: 5000000.0,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      Project(
        id: 2,
        nama: 'Project B',
        durasiKontrak: 6,
        hargaSewa: 3000000.0,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  Future<User?> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return User(
      id: 1,
      name: 'Admin User',
      email: 'admin@admin.com',
      emailVerifiedAt: DateTime.now().toIso8601String(),
      password: 'hashed_password',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  Future<Map<String, dynamic>?> getDashboard() async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'total_assets': 10,
      'total_projects': 5,
      'total_rentals': 8,
      'total_revenue': 50000000,
    };
  }

  Future<bool> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    return true;
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'statusCode': 201,
      'body': '{"message": "User registered successfully"}',
    };
  }
}
