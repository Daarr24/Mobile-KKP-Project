import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/asset.dart';
import '../models/project.dart';
import '../models/pengiriman_detail.dart';
import '../models/tagihan_list.dart';
import '../models/tagihan_detail.dart';
import '../models/rental.dart';
import '../models/tagihan.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;

  Future<String?> login(String email, String password) async {
    try {
      print('Attempting login with email: $email');
      print('Login URL: $baseUrl/login');

      // Coba dengan form data dulu (seperti Laravel biasanya)
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/x-www-form-urlencoded',
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            },
            body: {'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 15));

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          print('Login successful, token saved');
          return data['token'];
        }
      } else if (response.statusCode == 401) {
        print('Login failed: Unauthorized');
        return null;
      } else if (response.statusCode == 422) {
        print('Login failed: Validation error');
        final data = json.decode(response.body);
        print('Validation errors: ${data['errors']}');
        return null;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<List<Asset>> getAssets() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/asset'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Asset.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }

  Future<List<Project>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/project'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['user'];
      return User.fromJson(data);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      return null;
    }
  }

  Future<PengirimanDetail?> getPengirimanDetail(int projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/pengiriman/$projectId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return PengirimanDetail.fromJson(data);
    } else {
      return null;
    }
  }

  Future<TagihanList?> getTagihanList(int projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/project/$projectId/tagihan'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TagihanList.fromJson(data);
    } else {
      return null;
    }
  }

  Future<TagihanDetail?> getTagihanDetail(int tagihanId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/tagihan/$tagihanId/detail'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TagihanDetail.fromJson(data);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> addAsset({
    required String merk,
    required String type,
    required String spesifikasi,
    required String serialnumber,
    required String kondisi,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/asset'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'merk': merk,
        'type': type,
        'spesifikasi': spesifikasi,
        'serialnumber': serialnumber,
        'kondisi': kondisi,
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {'success': true};
    } else {
      String message = 'Gagal menyimpan asset';
      try {
        final data = json.decode(response.body);
        message = data['message'] ?? message;
      } catch (_) {}
      return {'success': false, 'message': message};
    }
  }

  Future<Map<String, dynamic>> editAsset({
    required int id,
    required String merk,
    required String type,
    required String spesifikasi,
    required String serialnumber,
    required String kondisi,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/asset/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'merk': merk,
        'type': type,
        'spesifikasi': spesifikasi,
        'serialnumber': serialnumber,
        'kondisi': kondisi,
      },
    );
    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      String message = 'Gagal mengedit asset';
      try {
        final data = json.decode(response.body);
        message = data['message'] ?? message;
      } catch (_) {}
      return {'success': false, 'message': message};
    }
  }

  Future<bool> addDetailAsset({
    required int assetId,
    required String serialNumber,
    required String kondisi,
    required String status,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/detailasset'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'asset_id': assetId.toString(),
        'serialnumber': serialNumber,
        'kondisi': kondisi,
        'status': status,
      },
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> deleteAsset(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/asset/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<Map<String, dynamic>> addProject({
    required String nama,
    required int durasiKontrak,
    required double hargaSewa,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/project'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'nama': nama,
        'durasi_kontrak': durasiKontrak.toString(),
        'harga_sewa': hargaSewa.toString(),
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return {'success': true};
    } else {
      String message = 'Gagal menyimpan project';
      try {
        final data = json.decode(response.body);
        message = data['message'] ?? message;
      } catch (_) {}
      return {'success': false, 'message': message};
    }
  }

  Future<Map<String, dynamic>> editProject({
    required int id,
    required String nama,
    required int durasiKontrak,
    required double hargaSewa,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/project/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'nama': nama,
        'durasi_kontrak': durasiKontrak.toString(),
        'harga_sewa': hargaSewa.toString(),
      },
    );
    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      String message = 'Gagal mengedit project';
      try {
        final data = json.decode(response.body);
        message = data['message'] ?? message;
      } catch (_) {}
      return {'success': false, 'message': message};
    }
  }

  Future<bool> deleteProject(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/project/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> addRental({
    required int pengirimanId,
    required int projectId,
    required String periodeMulai,
    required String periodeAkhir,
    required int totalTagihan,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/rental'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'pengiriman_id': pengirimanId.toString(),
        'project_id': projectId.toString(),
        'periode_mulai': periodeMulai,
        'periode_ahir': periodeAkhir,
        'total_tagihan': totalTagihan.toString(),
      },
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> editRental({
    required int id,
    required int pengirimanId,
    required int projectId,
    required String periodeMulai,
    required String periodeAkhir,
    required int totalTagihan,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/rental/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'pengiriman_id': pengirimanId.toString(),
        'project_id': projectId.toString(),
        'periode_mulai': periodeMulai,
        'periode_ahir': periodeAkhir,
        'total_tagihan': totalTagihan.toString(),
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteRental(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/rental/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> addPengiriman({
    required int projectId,
    required int detailAssetId,
    required String tanggalPengiriman,
    required String picPengirim,
    required String picPenerima,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('$baseUrl/pengiriman'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'project_id': projectId.toString(),
        'detailasset_id': detailAssetId.toString(),
        'tanggal_pengiriman': tanggalPengiriman,
        'pic_pengirim': picPengirim,
        'pic_penerima': picPenerima,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editPengiriman({
    required int id,
    required int detailAssetId,
    required String tanggalPengiriman,
    required String picPengirim,
    required String picPenerima,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/pengiriman/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'detailasset_id': detailAssetId.toString(),
        'tanggal_pengiriman': tanggalPengiriman,
        'pic_pengirim': picPengirim,
        'pic_penerima': picPenerima,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> deletePengiriman(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/pengiriman/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> addTagihan({
    required int projectId,
    required String durasiTagih,
    String? keterangan,
    required String tanggalTagihan,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tagihan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'project_id': projectId,
          'durasi_tagih': durasiTagih,
          'keterangan': keterangan ?? '',
          'tanggal_tagihan': tanggalTagihan,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Tagihan API Error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Tagihan API Exception: $e');
      return false;
    }
  }

  Future<bool> editTagihan({
    required int id,
    required int rentalId,
    required int nomorInvoice,
    required String keterangan,
    required String tanggalTagihan,
    required int jumlahUnit,
    required String durasiTagih,
    required int grandTotal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/tagihan/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'rental_id': rentalId.toString(),
        'nomor_invoice': nomorInvoice.toString(),
        'keterangan': keterangan,
        'tanggal_tagihan': tanggalTagihan,
        'jumlah_unit': jumlahUnit.toString(),
        'durasi_tagih': durasiTagih,
        'grand_total': grandTotal.toString(),
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteTagihan(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/tagihan/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Accept': 'application/json'},
            body: {'name': name, 'email': email, 'password': password},
          )
          .timeout(const Duration(seconds: 15));
      return {'statusCode': response.statusCode, 'body': response.body};
    } catch (e) {
      return {'statusCode': 0, 'body': e.toString()};
    }
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      await prefs.remove('token');
      return response.statusCode == 200;
    } catch (e) {
      await prefs.remove('token');
      return false;
    }
  }

  Future<List<Rental>> getRentals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/rental'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Rental.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rentals');
    }
  }

  Future<List<Tagihan>> getTagihanListAll() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/tagihan'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Tagihan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tagihan');
    }
  }

  Future<List<PengirimanDetail>> getPengirimanListAll() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/pengiriman'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => PengirimanDetail.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pengiriman');
    }
  }

  Future<List<dynamic>> getAvailableUnitsByProject(int projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('$baseUrl/pengiriman/$projectId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data['available_units'] ?? [];
    } else {
      throw Exception('Failed to load available units');
    }
  }
}
