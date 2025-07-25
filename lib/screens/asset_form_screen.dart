import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/asset.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AssetFormScreen extends StatefulWidget {
  final Asset? asset;
  const AssetFormScreen({super.key, this.asset});

  @override
  State<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends State<AssetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _merk;
  late String _type;
  late String _spesifikasi;
  String _serialNumber = '';
  String _kondisi = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _merk = widget.asset?.merk ?? '';
    _type = widget.asset?.type ?? '';
    _spesifikasi = widget.asset?.spesifikasi ?? '';
    _serialNumber = '';
    _kondisi = '';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Map<String, dynamic> result = {'success': false};
    try {
      if (widget.asset == null) {
        result = await ApiService().addAsset(
          merk: _merk,
          type: _type,
          spesifikasi: _spesifikasi,
          serialnumber: _serialNumber,
          kondisi: _kondisi,
        );
      } else {
        result = await ApiService().editAsset(
          id: widget.asset!.id,
          merk: _merk,
          type: _type,
          spesifikasi: _spesifikasi,
          serialnumber: _serialNumber,
          kondisi: _kondisi,
        );
      }
    } catch (error) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.handleApiError(error, context);
    }
    setState(() => _isLoading = false);
    if (result['success'] == true && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan asset')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE63946),
        elevation: 0,
        title: Text(
          widget.asset == null ? 'Tambah Asset' : 'Edit Asset',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 28,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.asset == null ? 'Tambah Asset' : 'Edit Asset',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: _merk.isNotEmpty ? _merk : null,
                        decoration: InputDecoration(
                          labelText: 'Merk',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Asus', child: Text('Asus')),
                          DropdownMenuItem(value: 'Acer', child: Text('Acer')),
                          DropdownMenuItem(value: 'Dell', child: Text('Dell')),
                          DropdownMenuItem(value: 'Hp', child: Text('Hp')),
                          DropdownMenuItem(
                            value: 'Lenovo',
                            child: Text('Lenovo'),
                          ),
                        ],
                        onChanged: (val) => setState(() => _merk = val ?? ''),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Merk wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _type,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _type = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Type wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _spesifikasi,
                        decoration: InputDecoration(
                          labelText: 'Spesifikasi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _spesifikasi = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Spesifikasi wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Serialnumber',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _serialNumber = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Serialnumber wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _kondisi.isNotEmpty ? _kondisi : null,
                        decoration: InputDecoration(
                          labelText: 'Kondisi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Normal',
                            child: Text('Normal'),
                          ),
                          DropdownMenuItem(
                            value: 'Rusak',
                            child: Text('Rusak'),
                          ),
                        ],
                        onChanged: (val) =>
                            setState(() => _kondisi = val ?? ''),
                        validator: (val) => val == null || val.isEmpty
                            ? 'Kondisi wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 28),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFDC2626),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: _submit,
                                child: Text(
                                  widget.asset == null ? 'Tambah' : 'Simpan',
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
