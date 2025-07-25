import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pengiriman_detail.dart';
import '../widgets/main_drawer.dart';

class PengirimanScreen extends StatefulWidget {
  final int projectId;
  const PengirimanScreen({super.key, required this.projectId});

  @override
  State<PengirimanScreen> createState() => _PengirimanScreenState();
}

class _PengirimanScreenState extends State<PengirimanScreen> {
  late Future<PengirimanDetail?> _pengirimanFuture;

  @override
  void initState() {
    super.initState();
    _pengirimanFuture = ApiService().getPengirimanDetail(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengiriman')),
      drawer: const MainDrawer(),
      body: FutureBuilder<PengirimanDetail?>(
        future: _pengirimanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Tidak ada data pengiriman'));
          }
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Project: \\${data.project.nama}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Daftar Pengiriman:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...data.pengiriman.map(
                (item) => ListTile(
                  title: Text('Tanggal: \\${item.tanggalPengiriman}'),
                  subtitle: Text(
                    'PIC Pengirim: \\${item.picPengirim}\nPIC Penerima: \\${item.picPenerima}',
                  ),
                  trailing: Text('Serial: \\${item.detailAsset.serialNumber}'),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Available Units:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...data.availableUnits.map(
                (unit) => ListTile(
                  title: Text('Serial: \\${unit.serialNumber}'),
                  subtitle: Text(
                    'Kondisi: \\${unit.kondisi}, Status: \\${unit.status}',
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
