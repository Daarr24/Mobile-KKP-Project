import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/mock_api_service.dart';
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final dynamic _apiService = ApiConfig.useMockService
      ? MockApiService()
      : ApiService();
  String? _token;
  bool _isLoading = false;
  String? _error;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);
      if (result != null) {
        _token = result;
        _isLoading = false;
        _error = null;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _error = 'Email atau password salah. Silakan coba lagi.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = 'Terjadi kesalahan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> handleApiError(dynamic error, BuildContext context) async {
    if (error.toString().contains('401') ||
        error.toString().contains('Unauthenticated')) {
      logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  void logout() async {
    await _apiService.logout();
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();
  }
}
