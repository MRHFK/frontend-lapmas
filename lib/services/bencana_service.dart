import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bencana_model.dart';

class BencanaService {
  static const String baseUrl = 'http://localhost:8000/api';

  // Get all Bencana
  static Future<List<Bencana>> getAllBencana() async {
    final response = await http.get(Uri.parse('$baseUrl/bencana'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Bencana.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Bencana');
    }
  }

  // Add Bencana
  static Future<Bencana> addBencana(Bencana bencana) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bencanas'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'judul_laporan': bencana.judulLaporan,
        'nama_pelapor': bencana.namaPelapor,
        'no_telepon': bencana.noTelepon,
        'lokasi_kejadian': bencana.lokasiKejadian,
        'tanggal_kejadian': bencana.tanggalKejadian,
        'deskripsi_kejadian': bencana.deskripsiKejadian,
      }),
    );

    if (response.statusCode == 201) {
      return Bencana.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add Bencana');
    }
  }

  // Update Bencana
  static Future<Bencana> updateBencana(Bencana bencana) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bencanas/${bencana.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'judul_laporan': bencana.judulLaporan,
        'nama_pelapor': bencana.namaPelapor,
        'no_telepon': bencana.noTelepon,
        'lokasi_kejadian': bencana.lokasiKejadian,
        'tanggal_kejadian': bencana.tanggalKejadian,
        'deskripsi_kejadian': bencana.deskripsiKejadian,
      }),
    );

    if (response.statusCode == 200) {
      return Bencana.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update Bencana');
    }
  }

  // Delete Bencana
  static Future<void> deleteBencana(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/bencanas/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete Bencana');
    }
  }
}
