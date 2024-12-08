import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  _AdminProfileScreenState createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final _storage = const FlutterSecureStorage();
  String _userName = '';
  String _userRole = '';

  Map<String, dynamic> _userData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAdminProfile();
  }

  Future<void> _fetchAdminProfile() async {
    final token = await _storage.read(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/user-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          final userData = jsonDecode(response.body)['user'];
          _userName = userData['name'] ?? 'Admin';
          _userRole = userData['role'] ?? 'Admin';
          _userData = jsonDecode(response.body)['user'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat profil')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  Future<void> _logout() async {
    final token = await _storage.read(key: 'token');

    try {
      await http.post(
        Uri.parse('http://localhost:8000/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      print('Error during logout: $e');
    }

    // Hapus token dan arahkan ke halaman login
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'role');

    Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              accountName: Text(
                _userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text('Role: $_userRole'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _userName.isNotEmpty ? _userName[0] : 'U',
                  style: const TextStyle(fontSize: 40.0, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                // Sudah di halaman beranda, tutup drawer
                Navigator.pushNamed(context, '/adminHome');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil Saya'),
              onTap: () {
                // Navigasi ke halaman profil
                Navigator.pushNamed(context, '/AdminProfile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blue,
                          child:
                              Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildProfileRow('Nama', _userData['name'] ?? '-'),
                      const Divider(),
                      _buildProfileRow('Email', _userData['email'] ?? '-'),
                      const Divider(),
                      _buildProfileRow('Role', _userData['role'] ?? '-'),
                      const Divider(),
                      _buildProfileRow(
                          'Dibuat Pada', _formatDate(_userData['created_at'])),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      // Parse the date from the API (assumed to be in ISO 8601 format)
      DateTime dateTime = DateTime.parse(dateString);

      // Format the date in a more readable format
      return DateFormat('dd MMMM yyyy HH:mm').format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return dateString;
    }
  }
}
