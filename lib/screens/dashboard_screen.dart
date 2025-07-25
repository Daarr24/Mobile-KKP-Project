import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../widgets/main_drawer.dart';
import '../providers/auth_provider.dart'; // Added import for AuthProvider
import 'package:provider/provider.dart'; // Added import for Provider

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>?> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiService().getDashboard().catchError((error) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.handleApiError(error, context);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: const Color(0xFFE63946),
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
            child: Row(
              children: [
                Image.asset('lib/assets/logo.png', width: 48, height: 48),
                const SizedBox(width: 18),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Icon(Icons.notifications, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Tidak ada data dashboard'));
          }
          final data = snapshot.data!;
          final months = List<String>.from(data['months'] ?? []);
          final assetPerMonth = List<int>.from(data['assetPerMonth'] ?? []);
          final rentPerMonth = List<int>.from(data['rentPerMonth'] ?? []);
          final pieLabels = List<String>.from(data['pieLabels'] ?? []);
          final pieData = List<num>.from(data['pieData'] ?? []);
          final pieColors =
              (data['pieColors'] as List?)
                  ?.map((c) => Color(int.parse(c.replaceFirst('#', '0xff'))))
                  .toList() ??
              [
                Color(0xFF457B9D),
                Color(0xFFF4A261),
                Color(0xFFE63946),
                Color(0xFFBDBDBD),
              ];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _DashboardNavCard(
                        icon: 'lib/assets/dashboard.png',
                        label: 'Total Asset',
                        value: data['totalasset'].toString(),
                        color: const Color(0xFF457B9D),
                        onTap: () => Navigator.pushNamed(context, '/assets'),
                        big: true,
                      ),
                      const SizedBox(width: 24),
                      _DashboardNavCard(
                        icon: 'lib/assets/dashboard.png',
                        label: 'Total Rental',
                        value: data['totalrental'].toString(),
                        color: const Color(0xFFF4A261),
                        onTap: () => Navigator.pushNamed(context, '/rental'),
                        big: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: const Color(0xFFE63946),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Bulan sekarang: ${data['monthName']} ${data['year']}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Statistik Asset & Rental',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 240,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: const TextStyle(fontSize: 13),
                                  );
                                }
                                return const SizedBox();
                              },
                              reservedSize: 32,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barGroups: List.generate(
                          months.length,
                          (i) => BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: i < assetPerMonth.length
                                    ? assetPerMonth[i].toDouble()
                                    : 0,
                                color: const Color(0xFF457B9D),
                              ),
                              BarChartRodData(
                                toY: i < rentPerMonth.length
                                    ? rentPerMonth[i].toDouble()
                                    : 0,
                                color: const Color(0xFFF4A261),
                              ),
                            ],
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        groupsSpace: 18,
                        barTouchData: BarTouchData(enabled: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Distribusi Rental',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    height: 240,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: PieChart(
                      PieChartData(
                        sections: List.generate(
                          pieLabels.length,
                          (i) => PieChartSectionData(
                            color: i < pieColors.length
                                ? pieColors[i]
                                : Colors.grey,
                            value: i < pieData.length
                                ? pieData[i].toDouble()
                                : 0,
                            title: pieLabels[i],
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        sectionsSpace: 4,
                        centerSpaceRadius: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardNavCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;
  final bool big;

  const _DashboardNavCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
    this.big = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(icon, width: 38, height: 38),
              ),
              const SizedBox(height: 18),
              Text(
                value,
                style: TextStyle(
                  fontSize: big ? 40 : 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
