import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DetailAssetFormScreen extends StatefulWidget {
  final int assetId;
  const DetailAssetFormScreen({super.key, required this.assetId});

  @override
  State<DetailAssetFormScreen> createState() => _DetailAssetFormScreenState();
}

class _DetailAssetFormScreenState extends State<DetailAssetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _serialNumber = '';
  String _kondisi = 'normal';
  String _status = 'stok';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final success = await ApiService().addDetailAsset(
      assetId: widget.assetId,
      serialNumber: _serialNumber,
      kondisi: _kondisi,
      status: _status,
    );
    setState(() => _isLoading = false);
    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambah detail asset')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Detail Asset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Serial Number'),
                onChanged: (val) => _serialNumber = val,
                validator: (val) => val == null || val.isEmpty
                    ? 'Serial number wajib diisi'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _kondisi,
                decoration: const InputDecoration(labelText: 'Kondisi'),
                items: const [
                  DropdownMenuItem(value: 'normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'rusak', child: Text('Rusak')),
                ],
                onChanged: (val) => setState(() => _kondisi = val ?? 'normal'),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'stok', child: Text('Stok')),
                  DropdownMenuItem(value: 'rental', child: Text('Rental')),
                ],
                onChanged: (val) => setState(() => _status = val ?? 'stok'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Tambah'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
