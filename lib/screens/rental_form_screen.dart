import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/rental.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RentalFormScreen extends StatefulWidget {
  final Rental? rental;
  const RentalFormScreen({super.key, this.rental});

  @override
  State<RentalFormScreen> createState() => _RentalFormScreenState();
}

class _RentalFormScreenState extends State<RentalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _pengirimanId;
  late int _projectId;
  late String _periodeMulai;
  late String _periodeAkhir;
  late int _totalTagihan;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pengirimanId = widget.rental?.pengirimanId ?? 0;
    _projectId = widget.rental?.projectId ?? 0;
    _periodeMulai = widget.rental?.periodeMulai ?? '';
    _periodeAkhir = widget.rental?.periodeAkhir ?? '';
    _totalTagihan = widget.rental?.totalTagihan ?? 0;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    bool success = false;
    try {
      if (widget.rental == null) {
        success = await ApiService().addRental(
          pengirimanId: _pengirimanId,
          projectId: _projectId,
          periodeMulai: _periodeMulai,
          periodeAkhir: _periodeAkhir,
          totalTagihan: _totalTagihan,
        );
      } else {
        success = await ApiService().editRental(
          id: widget.rental!.id,
          pengirimanId: _pengirimanId,
          projectId: _projectId,
          periodeMulai: _periodeMulai,
          periodeAkhir: _periodeAkhir,
          totalTagihan: _totalTagihan,
        );
      }
    } catch (error) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.handleApiError(error, context);
    }
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan rental')));
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
          widget.rental == null ? 'Tambah Rental' : 'Edit Rental',
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
                        widget.rental == null ? 'Tambah Rental' : 'Edit Rental',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        initialValue: _pengirimanId == 0
                            ? ''
                            : _pengirimanId.toString(),
                        decoration: InputDecoration(
                          labelText: 'Pengiriman ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            _pengirimanId = int.tryParse(val) ?? 0,
                        validator: (val) =>
                            val == null || int.tryParse(val) == null
                            ? 'Pengiriman ID wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _projectId == 0
                            ? ''
                            : _projectId.toString(),
                        decoration: InputDecoration(
                          labelText: 'Project ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => _projectId = int.tryParse(val) ?? 0,
                        validator: (val) =>
                            val == null || int.tryParse(val) == null
                            ? 'Project ID wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _periodeMulai,
                        decoration: InputDecoration(
                          labelText: 'Periode Mulai (YYYY-MM-DD)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _periodeMulai = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Periode mulai wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _periodeAkhir,
                        decoration: InputDecoration(
                          labelText: 'Periode Akhir (YYYY-MM-DD)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _periodeAkhir = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Periode akhir wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _totalTagihan == 0
                            ? ''
                            : _totalTagihan.toString(),
                        decoration: InputDecoration(
                          labelText: 'Total Tagihan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            _totalTagihan = int.tryParse(val) ?? 0,
                        validator: (val) =>
                            val == null || int.tryParse(val) == null
                            ? 'Total tagihan wajib diisi'
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
                                  widget.rental == null ? 'Tambah' : 'Simpan',
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
