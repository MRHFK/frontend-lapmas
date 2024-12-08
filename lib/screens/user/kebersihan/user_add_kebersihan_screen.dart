import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAddKebersihanScreen extends StatefulWidget {
  final Function onSubmit;

  const UserAddKebersihanScreen({super.key, required this.onSubmit});

  @override
  _UserAddKebersihanScreenState createState() =>
      _UserAddKebersihanScreenState();
}

class _UserAddKebersihanScreenState extends State<UserAddKebersihanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  String _judulLaporan = '';
  String _namaPelapor = '';
  String _noTelepon = '';
  String _lokasiKejadian = '';
  DateTime _tanggalKejadian = DateTime.now();
  String _deskripsiKejadian = '';

  Future<void> _submitLaporan() async {
    final token = await _storage.read(key: 'token');

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/kebersihans'),
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

      if (response.statusCode == 201) {
        widget.onSubmit();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan laporan')),
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
        title: const Text('Tambah Laporan',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Judul Laporan'),
                onChanged: (value) {
                  setState(() {
                    _judulLaporan = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Pelapor'),
                onChanged: (value) {
                  setState(() {
                    _namaPelapor = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'No. Telepon'),
                onChanged: (value) {
                  setState(() {
                    _noTelepon = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Lokasi Kejadian'),
                onChanged: (value) {
                  setState(() {
                    _lokasiKejadian = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                title: Text('Tanggal Kejadian: ${_tanggalKejadian.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Deskripsi Kejadian'),
                onChanged: (value) {
                  setState(() {
                    _deskripsiKejadian = value;
                  });
                },
              ),
              const SizedBox(height: 20.0),
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
                    "Tambahkan",
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

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _tanggalKejadian,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _tanggalKejadian) {
      setState(() {
        _tanggalKejadian = pickedDate;
      });
    }
  }
}
