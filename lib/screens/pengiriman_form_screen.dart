import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pengiriman.dart';

class PengirimanFormScreen extends StatefulWidget {
  final Pengiriman? pengiriman;
  final int? projectId;
  const PengirimanFormScreen({super.key, this.pengiriman, this.projectId});

  @override
  State<PengirimanFormScreen> createState() => _PengirimanFormScreenState();
}

class _PengirimanFormScreenState extends State<PengirimanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late int _detailAssetId;
  late String _tanggalPengiriman;
  late String _picPengirim;
  late String _picPenerima;
  bool _isLoading = false;
  List<dynamic> _availableUnits = [];

  @override
  void initState() {
    super.initState();
    _detailAssetId = widget.pengiriman?.detailAssetId ?? 0;
    _tanggalPengiriman = widget.pengiriman?.tanggalPengiriman ?? '';
    _picPengirim = widget.pengiriman?.picPengirim ?? '';
    _picPenerima = widget.pengiriman?.picPenerima ?? '';
    if (widget.projectId != null) {
      ApiService().getAvailableUnitsByProject(widget.projectId!).then((units) {
        setState(() {
          _availableUnits = units;
        });
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    bool success;
    if (widget.pengiriman == null) {
      success = await ApiService().addPengiriman(
        projectId: widget.projectId!,
        detailAssetId: _detailAssetId,
        tanggalPengiriman: _tanggalPengiriman,
        picPengirim: _picPengirim,
        picPenerima: _picPenerima,
      );
    } else {
      success = await ApiService().editPengiriman(
        id: widget.pengiriman!.id,
        detailAssetId: _detailAssetId,
        tanggalPengiriman: _tanggalPengiriman,
        picPengirim: _picPengirim,
        picPenerima: _picPenerima,
      );
    }
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan pengiriman')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pengiriman == null ? 'Tambah Pengiriman' : 'Edit Pengiriman',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (widget.projectId != null) ...[
                // Hidden input project_id (tidak perlu di Flutter, cukup simpan di variabel)
                TextFormField(
                  initialValue: widget.projectId.toString(),
                  decoration: const InputDecoration(labelText: 'Project ID'),
                  enabled: false,
                ),
                TextFormField(
                  initialValue: '',
                  decoration: const InputDecoration(labelText: 'Nama Project'),
                  enabled: false,
                ),
              ],
              const SizedBox(height: 8),
              TextFormField(
                controller: TextEditingController(text: _tanggalPengiriman),
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pengiriman',
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
                      _tanggalPengiriman = picked.toIso8601String().substring(
                        0,
                        10,
                      );
                    });
                  }
                },
                validator: (val) =>
                    val == null || val.isEmpty ? 'Tanggal wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _picPengirim,
                decoration: const InputDecoration(labelText: 'PIC Pengirim'),
                onChanged: (val) => _picPengirim = val,
                validator: (val) => val == null || val.isEmpty
                    ? 'PIC Pengirim wajib diisi'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                initialValue: _picPenerima,
                decoration: const InputDecoration(labelText: 'PIC Penerima'),
                onChanged: (val) => _picPenerima = val,
                validator: (val) => val == null || val.isEmpty
                    ? 'PIC Penerima wajib diisi'
                    : null,
              ),
              const SizedBox(height: 8),
              widget.projectId != null
                  ? DropdownButtonFormField<int>(
                      value: _detailAssetId == 0 ? null : _detailAssetId,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Unit (Detail Asset)',
                      ),
                      items: _availableUnits.map<DropdownMenuItem<int>>((unit) {
                        final asset = unit['asset'];
                        final label = asset != null
                            ? '${asset['merk'] ?? '-'} - ${asset['type'] ?? '-'} | SN: ${unit['serialnumber'] ?? 'N/A'}'
                            : 'SN: ${unit['serialnumber'] ?? 'N/A'}';
                        return DropdownMenuItem<int>(
                          value: unit['id'],
                          child: Text(label),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _detailAssetId = val ?? 0),
                      validator: (val) =>
                          val == null || val == 0 ? 'Unit wajib dipilih' : null,
                    )
                  : TextFormField(
                      initialValue: _detailAssetId == 0
                          ? ''
                          : _detailAssetId.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Detail Asset ID',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (val) =>
                          _detailAssetId = int.tryParse(val) ?? 0,
                      validator: (val) =>
                          val == null || int.tryParse(val) == null
                          ? 'Detail Asset ID wajib diisi'
                          : null,
                    ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(
                        widget.pengiriman == null ? 'Kirim' : 'Simpan',
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
