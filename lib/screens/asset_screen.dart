import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../models/detail_asset.dart';
import '../services/api_service.dart';
import '../widgets/main_drawer.dart';
import 'asset_form_screen.dart';
import 'detail_asset_form_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  late Future<List<Asset>> _assetsFuture;

  @override
  void initState() {
    super.initState();
    _assetsFuture = ApiService().getAssets().catchError((error) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.handleApiError(error, context);
      return <Asset>[];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE63946),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('lib/assets/logo.png', width: 36, height: 36),
            const SizedBox(width: 12),
            const Text('Asset', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder<List<Asset>>(
        future: _assetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada asset'));
          }
          final assets = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: assets.length,
            itemBuilder: (context, index) {
              final asset = assets[index];
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF457B9D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'lib/assets/asset.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.type,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  asset.merk,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AssetFormScreen(asset: asset),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  _assetsFuture = ApiService().getAssets();
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Hapus Asset'),
                                  content: const Text(
                                    'Yakin ingin menghapus asset ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                final success = await ApiService().deleteAsset(
                                  asset.id,
                                );
                                if (success && mounted) {
                                  setState(() {
                                    _assetsFuture = ApiService().getAssets();
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Gagal menghapus asset'),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add_box,
                              color: Color(0xFFE63946),
                            ),
                            tooltip: 'Tambah Detail Asset',
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailAssetFormScreen(assetId: asset.id),
                                ),
                              );
                              if (result == true) {
                                setState(() {
                                  _assetsFuture = ApiService().getAssets();
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tambah Detail Asset',
                            style: TextStyle(
                              color: Color(0xFFE63946),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (asset.detailAssets != null &&
                          asset.detailAssets!.isNotEmpty)
                        ...asset.detailAssets!.map(
                          (detail) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Serial: \\${detail.serialNumber}'),
                            subtitle: Text(
                              'Kondisi: \\${detail.kondisi}, Status: \\${detail.status}',
                            ),
                          ),
                        )
                      else
                        const ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Tidak ada detail asset'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE63946),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AssetFormScreen()),
          );
          if (result == true) {
            setState(() {
              _assetsFuture = ApiService().getAssets();
            });
          }
        },
        child: Image.asset('lib/assets/add.png', width: 28, height: 28),
      ),
    );
  }
}
