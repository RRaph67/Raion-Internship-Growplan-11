// File: lib/data/models/repo_tanaman_model.dart
class RepoTanamanModel {
  final int id;
  final String namaStatis;
  final String? namaIlmiah;
  final String jenisTanaman;
  final List<String>? persiapan;
  final List<String>? perawatan;
  final String? ringkasan;
  final List<String>? penyakit;
  final List<String>? panduan; 
  final List<String>? namaPenyakit;
  final String? imageUrl;
  final DateTime? createdAt; 

  RepoTanamanModel({
    required this.id,
    required this.namaStatis,
    this.namaIlmiah,
    required this.jenisTanaman,
    this.persiapan,
    this.perawatan,
    this.ringkasan,
    this.penyakit,
    this.panduan,
    this.namaPenyakit,
    this.imageUrl,
    this.createdAt,
  });

  factory RepoTanamanModel.fromMap(Map<String, dynamic> map) {

    List<String>? convertList(dynamic data) {
      if (data == null) return null;
      if (data is List) return data.cast<String>();
      if (data is String) return [data];
      return [data.toString()];
    }


    String convertString(dynamic data) {
      if (data == null) return '';
      if (data is String) return data.trim();
      if (data is List && data.isNotEmpty) {
        return (data[0] is String) ? data[0].trim() : data[0].toString();
      }
      return data.toString();
    }

    return RepoTanamanModel(
      id: map['id'] ?? 0,
      namaStatis: map['nama_statis'] ?? '',
      namaIlmiah: map['nama_ilmiah'],
      jenisTanaman: convertString(map['jenis_tanaman']),
      persiapan: convertList(map['persiapan']),
      perawatan: convertList(map['perawatan']),
      ringkasan: map['ringkasan'],
      penyakit: convertList(map['penyakit']),
      panduan: convertList(map['panduan']),
      namaPenyakit: convertList(map['nama_penyakit']),
      imageUrl: map['image_url'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_statis': namaStatis,
      'nama_ilmiah': namaIlmiah,
      'jenis_tanaman': jenisTanaman,
      'persiapan': persiapan,
      'perawatan': perawatan,
      'ringkasan': ringkasan,
      'penyakit': penyakit,
      'panduan': panduan,
      'nama_penyakit': namaPenyakit,
      'image_url': imageUrl,
    };
  }
}
