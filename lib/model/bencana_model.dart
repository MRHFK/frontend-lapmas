class Bencana {
  final int id;
  final String judulLaporan;
  final String namaPelapor;
  final String noTelepon;
  final String lokasiKejadian;
  final String tanggalKejadian;
  final String deskripsiKejadian;
  final String? fotoKejadian;

  Bencana({
    required this.id,
    required this.judulLaporan,
    required this.namaPelapor,
    required this.noTelepon,
    required this.lokasiKejadian,
    required this.tanggalKejadian,
    required this.deskripsiKejadian,
    this.fotoKejadian,
  });

  factory Bencana.fromJson(Map<String, dynamic> json) {
    return Bencana(
      id: json['id'],
      judulLaporan: json['judul_laporan'],
      namaPelapor: json['nama_pelapor'],
      noTelepon: json['no_telepon'],
      lokasiKejadian: json['lokasi_kejadian'],
      tanggalKejadian: json['tanggal_kejadian'],
      deskripsiKejadian: json['deskripsi_kejadian'],
    );
  }
}
