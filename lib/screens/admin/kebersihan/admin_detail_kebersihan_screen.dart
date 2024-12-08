import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AdminDetailKebersihanScreen extends StatelessWidget {
  final dynamic kebersihan;
  final Function onSubmit;

  const AdminDetailKebersihanScreen(
      {super.key, required this.kebersihan, required this.onSubmit});

  Future<void> _deleteKebersihan(BuildContext context) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus laporan ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token');

      try {
        final response = await http.delete(
          Uri.parse(
              'http://localhost:8000/api/kebersihans/${kebersihan['id']}'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          onSubmit();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil menghapus laporan')),
          );
          Navigator.pushNamed(context, '/adminKebersihan');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus laporan')),
          );
        }
      } catch (e) {
        print('Error deleting laporan: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rincian Laporan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Tombol Delete
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteKebersihan(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Judul Laporan',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kebersihan['judul_laporan']),
            ),
            ListTile(
              title: const Text('Nama Pelapor',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kebersihan['nama_pelapor']),
            ),
            ListTile(
              title: const Text('No. Telepon',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kebersihan['no_telepon']),
            ),
            ListTile(
              title: const Text('Lokasi Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kebersihan['lokasi_kejadian']),
            ),
            ListTile(
              title: const Text('Tanggal Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kebersihan['tanggal_kejadian']),
            ),
            ListTile(
              title: const Text('Deskripsi Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kebersihan['deskripsi_kejadian']),
            ),
          ],
        ),
      ),
    );
  }
}
