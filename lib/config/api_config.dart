class ApiConfig {
  // Development URL (localhost)
  static const String devBaseUrl = 'http://localhost:8000/api/vcom';

  // Production URL
  static const String prodBaseUrl = 'https://viacomputertangerang.com/api/vcom';

  // Gunakan ini untuk switching antara dev dan prod
  static const String baseUrl =
      devBaseUrl; // Ubah ke prodBaseUrl untuk production

  // Gunakan mock service untuk testing tanpa server
  static const bool useMockService = true; // Ubah ke false untuk production

  // Timeout settings
  static const int connectionTimeout = 15;
  static const int receiveTimeout = 15;
}
