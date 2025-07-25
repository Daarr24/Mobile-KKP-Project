import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/tagihan.dart';
import '../models/tagihan_list.dart';
import 'tagihan_form_screen.dart';
import '../widgets/main_drawer.dart';

class TagihanListScreen extends StatefulWidget {
  const TagihanListScreen({super.key});

  @override
  State<TagihanListScreen> createState() => _TagihanListScreenState();
}

class _TagihanListScreenState extends State<TagihanListScreen> {
  late Future<List<Tagihan>> _tagihanFuture;

  @override
  void initState() {
    super.initState();
    _tagihanFuture = ApiService().getTagihanListAll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final projectId = ModalRoute.of(context)?.settings.arguments as int?;
    if (projectId != null) {
      _tagihanFuture = ApiService()
          .getTagihanList(projectId)
          .then((list) => list != null ? list.tagihan : []);
      _projectNameFuture = ApiService()
          .getTagihanList(projectId)
          .then((list) => list?.project.nama ?? 'Project');
    }
  }

  late Future<String>? _projectNameFuture;

  void _refresh() {
    setState(() {
      _tagihanFuture = ApiService().getTagihanListAll();
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
          'Daftar Tagihan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder<List<Tagihan>>(
        future: _tagihanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data tagihan'));
          }
          final tagihanList = snapshot.data!;
          if (tagihanList.isEmpty) {
            return const Center(child: Text('Tidak ada data tagihan'));
          }
          final projectId = ModalRoute.of(context)?.settings.arguments as int?;
          Widget projectTitle = const SizedBox();
          if (projectId != null && _projectNameFuture != null) {
            projectTitle = FutureBuilder<String>(
              future: _projectNameFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: LinearProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Project: ${snap.data ?? '-'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          }
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                projectTitle,
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Nomor Invoice')),
                        DataColumn(label: Text('Jumlah Unit')),
                        DataColumn(label: Text('Total Tagihan')),
                        DataColumn(label: Text('Aksi')),
                      ],
                      rows: tagihanList
                          .map(
                            (tagihan) => DataRow(
                              cells: [
                                DataCell(Text(tagihan.nomorInvoice.toString())),
                                DataCell(Text(tagihan.jumlahUnit.toString())),
                                DataCell(Text('Rp ${tagihan.grandTotal}')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.visibility,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/tagihan_detail',
                                            arguments: tagihan.id,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TagihanFormScreen(
                                                    tagihan: tagihan,
                                                  ),
                                            ),
                                          );
                                          if (result == true) _refresh();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Hapus Tagihan',
                                              ),
                                              content: const Text(
                                                'Yakin ingin menghapus tagihan ini?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text('Hapus'),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            final success = await ApiService()
                                                .deleteTagihan(tagihan.id);
                                            if (success && mounted) _refresh();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE63946),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TagihanFormScreen()),
          );
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
