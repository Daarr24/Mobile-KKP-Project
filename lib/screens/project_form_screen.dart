import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/project.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProjectFormScreen extends StatefulWidget {
  final Project? project;
  const ProjectFormScreen({super.key, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nama;
  late int _durasiKontrak;
  late double _hargaSewa;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nama = widget.project?.nama ?? '';
    _durasiKontrak = widget.project?.durasiKontrak ?? 1;
    _hargaSewa = widget.project?.hargaSewa ?? 0;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    Map<String, dynamic> result = {'success': false};
    try {
      if (widget.project == null) {
        result = await ApiService().addProject(
          nama: _nama,
          durasiKontrak: _durasiKontrak,
          hargaSewa: _hargaSewa,
        );
      } else {
        result = await ApiService().editProject(
          id: widget.project!.id,
          nama: _nama,
          durasiKontrak: _durasiKontrak,
          hargaSewa: _hargaSewa,
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
        SnackBar(content: Text(result['message'] ?? 'Gagal menyimpan project')),
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
          widget.project == null ? 'Tambah Project' : 'Edit Project',
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
                        widget.project == null
                            ? 'Tambah Project'
                            : 'Edit Project',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        initialValue: _nama,
                        decoration: InputDecoration(
                          labelText: 'Nama Project',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _nama = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Nama wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _durasiKontrak.toString(),
                        decoration: InputDecoration(
                          labelText: 'Durasi Kontrak (bulan)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            _durasiKontrak = int.tryParse(val) ?? 1,
                        validator: (val) =>
                            val == null || int.tryParse(val) == null
                            ? 'Durasi wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _hargaSewa.toString(),
                        decoration: InputDecoration(
                          labelText: 'Harga Sewa',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            _hargaSewa = double.tryParse(val) ?? 0,
                        validator: (val) =>
                            val == null || double.tryParse(val) == null
                            ? 'Harga sewa wajib diisi'
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
                                  widget.project == null ? 'Tambah' : 'Simpan',
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
