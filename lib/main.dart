import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/project_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/asset_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/rental_list_screen.dart';
import 'screens/tagihan_list_screen.dart';
import 'screens/pengiriman_list_screen.dart';
import 'screens/tagihan_detail_screen.dart';
import 'screens/documentation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Via Computer',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(), // Langsung ke login screen untuk debugging
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/projects': (context) => const ProjectScreen(),
          '/profile': (context) => const UserProfileScreen(),
          '/assets': (context) => const AssetScreen(),
          '/rental': (context) => RentalListScreen(),
          '/tagihan': (context) => TagihanListScreen(),
          '/pengiriman': (context) => PengirimanListScreen(),
          '/tagihan_detail': (context) => TagihanDetailScreen(),
          '/documentation': (context) => const DocumentationScreen(),
        },
      ),
    );
  }
}
