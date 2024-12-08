import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserEditBencanaScreen extends StatefulWidget {
  final dynamic bencana;
  final Function onSubmit;

  const UserEditBencanaScreen(
      {super.key, required this.bencana, required this.onSubmit});

  @override
  _UserEditBencanaScreenState createState() => _UserEditBencanaScreenState();
}

class _UserEditBencanaScreenState extends State<UserEditBencanaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  late String _judulLaporan;
  late String _namaPelapor;
  late String _noTelepon;
  late String _lokasiKejadian;
  late DateTime _tanggalKejadian;
  late String _deskripsiKejadian;

  @override
  void initState() {
    super.initState();
    _judulLaporan = widget.bencana['judul_laporan'];
    _namaPelapor = widget.bencana['nama_pelapor'];
    _noTelepon = widget.bencana['no_telepon'];
    _lokasiKejadian = widget.bencana['lokasi_kejadian'];
    _tanggalKejadian = DateTime.parse(widget.bencana['tanggal_kejadian']);
    _deskripsiKejadian = widget.bencana['deskripsi_kejadian'];
  }

  Future<void> _submitLaporan() async {
    final token = await _storage.read(key: 'token');

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8000/api/bencanas/${widget.bencana['id']}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'judul_laporan': _judulLaporan,
          'nama_pelapor': _namaPelapor,
          'no_telepon': _noTelepon,
          'lokasi_kejadian': _lokasiKejadian,
          'tanggal_kejadian': _tanggalKejadian.toIso8601String(),
          'deskripsi_kejadian': _deskripsiKejadian,
        }),
      );

      if (response.statusCode == 200) {
        widget.onSubmit();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil ubah laporan')),
        );
        Navigator.pushNamed(context, '/userBencana');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui laporan')),
        );
      }
    } catch (e) {
      print('Error submitting laporan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Laporan',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _judulLaporan,
                decoration: const InputDecoration(labelText: 'Judul Laporan'),
                onChanged: (value) {
                  setState(() {
                    _judulLaporan = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _namaPelapor,
                decoration: const InputDecoration(labelText: 'Nama Pelapor'),
                onChanged: (value) {
                  setState(() {
                    _namaPelapor = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _noTelepon,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
                onChanged: (value) {
                  setState(() {
                    _noTelepon = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _lokasiKejadian,
                decoration: const InputDecoration(labelText: 'Lokasi Kejadian'),
                onChanged: (value) {
                  setState(() {
                    _lokasiKejadian = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue:
                    _tanggalKejadian.toLocal().toString().split(' ')[0],
                decoration:
                    const InputDecoration(labelText: 'Tanggal Kejadian'),
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _tanggalKejadian,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != _tanggalKejadian) {
                    setState(() {
                      _tanggalKejadian = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _deskripsiKejadian,
                decoration:
                    const InputDecoration(labelText: 'Deskripsi Kejadian'),
                onChanged: (value) {
                  setState(() {
                    _deskripsiKejadian = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 48,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _submitLaporan,
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
