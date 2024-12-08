import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_lapmas/screens/admin/admin_profile_screen.dart';
import 'package:frontend_lapmas/screens/admin/bencana/admin_bencana_screen.dart';
import 'package:frontend_lapmas/screens/admin/kebersihan/admin_kebersihan_screen.dart';
import 'package:frontend_lapmas/screens/admin/medis/admin_medis_screen.dart';
import 'package:frontend_lapmas/screens/user/bencana/user_bencana_screen.dart';
import 'package:frontend_lapmas/screens/user/kebersihan/user_kebersihan_screen.dart';
import 'package:frontend_lapmas/screens/user/medis/user_medis_screen.dart';
import 'package:frontend_lapmas/screens/user/user_profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String?> _getInitialRoute() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    final role = await storage.read(key: 'role');
    if (token != null) {
      return role == 'admin' ? '/adminHome' : '/userHome';
    }
    return '/welcome';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final initialRoute = snapshot.data ?? '/welcome';
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Laporan Masyarakat',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: initialRoute,
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/userHome': (context) => const UserHomeScreen(),
            '/userProfile': (context) => const UserProfileScreen(),
            '/userBencana': (context) => const UserBencanaScreen(),
            '/userKebersihan': (context) => const UserKebersihanScreen(),
            '/userMedis': (context) => const UserMedisScreen(),
            '/adminHome': (context) => const AdminHomeScreen(),
            '/adminProfile': (context) => const AdminProfileScreen(),
            '/adminBencana': (context) => const AdminBencanaScreen(),
            '/adminKebersihan': (context) => const AdminKebersihanScreen(),
            '/adminMedis': (context) => const AdminMedisScreen(),
            '/welcome': (context) => const WelcomeScreen(),
          },
        );
      },
    );
  }
}
