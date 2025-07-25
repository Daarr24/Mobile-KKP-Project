import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pengiriman_detail.dart';
import '../widgets/main_drawer.dart';
import 'pengiriman_form_screen.dart';

class PengirimanListScreen extends StatefulWidget {
  const PengirimanListScreen({super.key});

  @override
  State<PengirimanListScreen> createState() => _PengirimanListScreenState();
}

class _PengirimanListScreenState extends State<PengirimanListScreen> {
  late Future<List<PengirimanDetail>> _pengirimanFuture;

  @override
  void initState() {
    super.initState();
    _pengirimanFuture = ApiService().getPengirimanListAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final projectId = ModalRoute.of(context)?.settings.arguments as int?;
    if (projectId != null) {
      _pengirimanFuture = ApiService()
          .getPengirimanDetail(projectId)
          .then((detail) => detail != null ? [detail] : []);
    }
  }

  void _refresh() {
    setState(() {
      _pengirimanFuture = ApiService().getPengirimanListAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE63946),
        elevation: 0,
        title: const Text(
          'Daftar Pengiriman',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const MainDrawer(),
      floatingActionButton: (ModalRoute.of(context)?.settings.arguments is int)
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFE63946),
              onPressed: () async {
                final projectId =
                    ModalRoute.of(context)?.settings.arguments as int?;
                if (projectId != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PengirimanFormScreen(projectId: projectId),
                    ),
                  );
                  if (result == true) _refresh();
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: FutureBuilder<List<PengirimanDetail>>(
        future: _pengirimanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data pengiriman'));
          }
          final pengirimanList = snapshot.data!;
          if (pengirimanList.isEmpty) {
            return const Center(child: Text('Tidak ada data pengiriman'));
          }
          final detail = pengirimanList.first;
          final pengiriman = detail.pengiriman;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: pengiriman.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final item = pengiriman[i];
              final asset = item.detailAsset;
              final assetInfo = asset.asset != null
                  ? '${asset.asset!.merk} / ${asset.asset!.type}'
                  : '-';
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63946).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.local_shipping,
                          color: Color(0xFFE63946),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID Pengiriman: ${item.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Merk/Type: $assetInfo',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Serial Number: ${asset.serialNumber}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              'Tanggal: ${item.tanggalPengiriman}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              'PIC Pengirim: ${item.picPengirim}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              'PIC Penerima: ${item.picPenerima}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
