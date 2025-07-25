import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/project.dart';
import '../services/api_service.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = ApiService().getProjects();
  }

  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF457B9D), Color(0xFF1D3557)],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'lib/assets/logo.png',
                    width: 48,
                    height: 48,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Manajemen Asset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: 'lib/assets/drawer_dashboard.png',
                  label: 'Dashboard',
                  selected: currentRoute == '/dashboard',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                ),
                _DrawerItem(
                  icon: 'lib/assets/drawer_asset.png',
                  label: 'Asset',
                  selected: currentRoute == '/assets',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/assets');
                  },
                ),
                _DrawerItem(
                  icon: 'lib/assets/drawer_dashboard.png',
                  label: 'Rental',
                  selected: currentRoute == '/rental',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/rental');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.menu_book, color: Color(0xFF457B9D)),
                  title: const Text(
                    'Documentation',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/documentation');
                  },
                ),
                FutureBuilder<List<Project>>(
                  future: _projectsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: LinearProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const ListTile(
                        title: Text('Gagal memuat project'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const ListTile(title: Text('Tidak ada project'));
                    }
                    final projects = snapshot.data!;
                    return Column(
                      children: [
                        ExpansionTile(
                          leading: Image.asset(
                            'lib/assets/drawer_dashboard.png',
                            width: 28,
                            height: 28,
                          ),
                          title: const Text(
                            'Pengiriman',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: projects
                              .map(
                                (p) => ListTile(
                                  title: Text(p.nama),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/pengiriman',
                                      arguments: p.id,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                        ExpansionTile(
                          leading: Image.asset(
                            'lib/assets/drawer_dashboard.png',
                            width: 28,
                            height: 28,
                          ),
                          title: const Text(
                            'Tagihan',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: projects
                              .map(
                                (p) => ListTile(
                                  title: Text(p.nama),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/tagihan',
                                      arguments: p.id,
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: _DrawerItem(
              icon: 'lib/assets/drawer_logout.png',
              label: 'Logout',
              selected: false,
              onTap: () {
                Navigator.pop(context);
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? const Color(0xFFF4A261).withOpacity(0.2)
          : Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Image.asset(icon, width: 28, height: 28),
              const SizedBox(width: 18),
              Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: selected ? const Color(0xFFE63946) : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
