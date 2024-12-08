import 'package:flutter/material.dart';
import 'package:frontend_lapmas/screens/user/bencana/user_edit_bencana_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserDetailBencanaScreen extends StatelessWidget {
  final dynamic bencana;
  final Function onSubmit;

  const UserDetailBencanaScreen(
      {super.key, required this.bencana, required this.onSubmit});

  Future<void> _deleteBencana(BuildContext context) async {
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
          Uri.parse('http://localhost:8000/api/bencanas/${bencana['id']}'),
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
          Navigator.pushNamed(context, '/userBencana');
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
                  builder: (context) => UserEditBencanaScreen(
                    bencana: bencana,
                    onSubmit: onSubmit,
                  ),
                ),
              );
            },
          ),
          // Tombol Delete
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteBencana(context),
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
              subtitle: Text(bencana['judul_laporan']),
            ),
            ListTile(
              title: const Text('Nama Pelapor',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(bencana['nama_pelapor']),
            ),
            ListTile(
              title: const Text('No. Telepon',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(bencana['no_telepon']),
            ),
            ListTile(
              title: const Text('Lokasi Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(bencana['lokasi_kejadian']),
            ),
            ListTile(
              title: const Text('Tanggal Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(bencana['tanggal_kejadian']),
            ),
            ListTile(
              title: const Text('Deskripsi Kejadian',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(bencana['deskripsi_kejadian']),
            ),
          ],
        ),
      ),
    );
  }
}
