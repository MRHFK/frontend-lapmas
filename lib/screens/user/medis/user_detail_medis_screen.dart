import 'package:flutter/material.dart';
import 'package:frontend_lapmas/screens/user/medis/user_edit_medis_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserDetailMedisScreen extends StatelessWidget {
  final dynamic medis;
  final Function onSubmit;

  const UserDetailMedisScreen(
      {super.key, required this.medis, required this.onSubmit});

  Future<void> _deleteMedis(BuildContext context) async {
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
          Uri.parse('http://localhost:8000/api/medis/${medis['id']}'),
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
          Navigator.pushNamed(context, '/userMedis');
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
          // Tombol Edit
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserEditMedisScreen(
                    medis: medis,
                    onSubmit: onSubmit,
                  ),
                ),
              );
            },
          ),
          // Tombol Delete
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteMedis(context),
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
              subtitle: Text(medis['judul_laporan']),
            ),
            ListTile(
              title: const Text('Nama Pelapor',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(medis['nama_pelapor']),
            ),
            ListTile(
              title: const Text('No. Telepon',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(medis['no_telepon']),
            ),
            ListTile(
              title: const Text('Lokasi Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(medis['lokasi_kejadian']),
            ),
            ListTile(
              title: const Text('Tanggal Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(medis['tanggal_kejadian']),
            ),
            ListTile(
              title: const Text('Deskripsi Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(medis['deskripsi_kejadian']),
            ),
          ],
        ),
      ),
    );
  }
}
