import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_lapmas/screens/admin/admin_home_screen.dart';
import 'package:frontend_lapmas/screens/admin/kebersihan/admin_detail_kebersihan_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminKebersihanScreen extends StatefulWidget {
  const AdminKebersihanScreen({super.key});

  @override
  _AdminKebersihanScreenState createState() => _AdminKebersihanScreenState();
}

class _AdminKebersihanScreenState extends State<AdminKebersihanScreen> {
  final _storage = const FlutterSecureStorage();
  List<dynamic> _kebersihans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBencanas();
  }

  String formatTimestamp(String tanggalString) {
    final List<String> namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    DateTime tanggal = DateTime.parse(tanggalString).toLocal();

    String jam =
        '${tanggal.hour.toString().padLeft(2, '0')}:${tanggal.minute.toString().padLeft(2, '0')}';

    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}, $jam WIB';
  }

  Future<void> _fetchBencanas() async {
    final token = await _storage.read(key: 'token');

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/kebersihans'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Urutkan data dari yang terbaru
          _kebersihans = data.isEmpty ? [] : List.from(data)
            ..sort((a, b) {
              DateTime dateA = DateTime.parse(a['created_at']);
              DateTime dateB = DateTime.parse(b['created_at']);
              return dateB.compareTo(dateA);
            });
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat data kebersihan')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching kebersihan data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Kebersihan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _kebersihans.isEmpty
              ? const Center(child: Text('Belum ada laporan'))
              : ListView.builder(
                  itemCount: _kebersihans.length,
                  itemBuilder: (context, index) {
                    final kebersihan = _kebersihans[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white70,
                        border: Border.all(width: 1, color: Colors.black54),
                      ),
                      child: ListTile(
                        title: Text(
                          kebersihan['judul_laporan'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text(formatTimestamp(kebersihan['created_at'])),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDetailKebersihanScreen(
                                kebersihan: kebersihan,
                                onSubmit: _fetchBencanas,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
