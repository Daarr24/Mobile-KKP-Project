import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/tagihan.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class TagihanFormScreen extends StatefulWidget {
  final Tagihan? tagihan;
  const TagihanFormScreen({super.key, this.tagihan});

  @override
  State<TagihanFormScreen> createState() => _TagihanFormScreenState();
}

class _TagihanFormScreenState extends State<TagihanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _nomorInvoice;
  late String _keterangan;
  late String _tanggalTagihan;
  late String _durasiTagih;
  int _jumlahUnit = 0;
  int _grandTotal = 0;
  bool _isLoading = false;
  String? _projectName;

  @override
  void initState() {
    super.initState();
    _nomorInvoice = widget.tagihan?.nomorInvoice ?? 0;
    _keterangan = widget.tagihan?.keterangan ?? '';
    _tanggalTagihan = widget.tagihan?.tanggalTagihan ?? '';
    _durasiTagih = widget.tagihan?.durasiTagih ?? '';
    // TODO: fetch jumlahUnit & grandTotal dari API jika create baru
    // Sementara, set 0 jika create baru
    _jumlahUnit = widget.tagihan?.jumlahUnit ?? 0;
    _grandTotal = widget.tagihan?.grandTotal ?? 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final projectId = ModalRoute.of(context)?.settings.arguments as int?;
    if (projectId != null && widget.tagihan == null) {
      ApiService().getTagihanList(projectId).then((tagihanList) {
        setState(() {
          _jumlahUnit = tagihanList?.totalUnit ?? 0;
          _grandTotal = tagihanList?.grandTotal ?? 0;
        });
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi tanggal
    if (_tanggalTagihan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal tagihan wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);
    bool success = false;
    String errorMessage = 'Gagal menyimpan tagihan';

    try {
      if (widget.tagihan == null) {
        final projectId = ModalRoute.of(context)?.settings.arguments as int?;
        if (projectId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project tidak ditemukan')),
          );
          setState(() => _isLoading = false);
          return;
        }

        success = await ApiService().addTagihan(
          projectId: projectId,
          durasiTagih: _durasiTagih,
          keterangan: _keterangan,
          tanggalTagihan: _tanggalTagihan,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tagihan berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        } else {
          errorMessage = 'Gagal menambahkan tagihan. Silakan coba lagi.';
        }
      } else {
        // Edit tagihan: implementasi sesuai kebutuhan
        errorMessage = 'Fitur edit tagihan belum tersedia';
      }
    } catch (error) {
      print('Tagihan form error: $error');
      errorMessage = 'Terjadi kesalahan: $error';
    }

    setState(() => _isLoading = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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
          widget.tagihan == null ? 'Tambah Tagihan' : 'Edit Tagihan',
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
                        widget.tagihan == null
                            ? 'Tambah Tagihan'
                            : 'Edit Tagihan',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        initialValue: _nomorInvoice == 0
                            ? 'Otomatis'
                            : _nomorInvoice.toString(),
                        decoration: InputDecoration(
                          labelText: 'Nomor Invoice',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _keterangan,
                        decoration: InputDecoration(
                          labelText: 'Keterangan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _keterangan = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Keterangan wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _durasiTagih,
                        decoration: InputDecoration(
                          labelText: 'Durasi Tagih',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        onChanged: (val) => _durasiTagih = val,
                        validator: (val) => val == null || val.isEmpty
                            ? 'Durasi tagih wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: TextEditingController(
                          text: _tanggalTagihan,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Tanggal Tagihan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _tanggalTagihan = picked
                                  .toIso8601String()
                                  .substring(0, 10);
                            });
                          }
                        },
                        validator: (val) => val == null || val.isEmpty
                            ? 'Tanggal tagihan wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _jumlahUnit == 0
                            ? ''
                            : _jumlahUnit.toString(),
                        decoration: InputDecoration(
                          labelText: 'Jumlah Unit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _grandTotal == 0
                            ? ''
                            : _grandTotal.toString(),
                        decoration: InputDecoration(
                          labelText: 'Grand Total',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        enabled: false,
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
                                  widget.tagihan == null ? 'Tambah' : 'Simpan',
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
