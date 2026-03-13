// File: lib/data/models/user_tanam_model.dart
import 'package:flutter_application_1/data/models/repo_tanaman_model.dart';

class UserTanamModel {
  final int id;
  final String userId;
  final int? repoTanamanId;
  final String namaTanam;
  final DateTime tanggalTanam;
  final String? imageUrl;
  final DateTime createdAt;
  final RepoTanamanModel? repoTanaman;

  UserTanamModel({
    required this.id,
    required this.userId,
    this.repoTanamanId,
    required this.namaTanam,
    required this.tanggalTanam,
    this.imageUrl,
    required this.createdAt,
    this.repoTanaman,
  });

  factory UserTanamModel.fromMap(Map<String, dynamic> map) {
    // ✅ Validasi URL saat dari map
    String? imageUrl = map['image_url'];

    // Filter URL invalid
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        imageUrl.startsWith('file://') ||
        !imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
      imageUrl = null;
    }

    RepoTanamanModel? repoTanaman;
    if (map['repo_tanaman'] != null) {
      repoTanaman = RepoTanamanModel.fromMap(map['repo_tanaman']);
    }

    return UserTanamModel(
      id: map['id'] ?? 0,
      userId: map['user_id'] ?? '',
      repoTanamanId: map['repo_tanaman_id'] as int?,
      namaTanam: map['nama_tanam'] ?? '',
      tanggalTanam: DateTime.parse(map['tanggal_tanam']),
      imageUrl: imageUrl,
      createdAt: DateTime.parse(map['created_at']),
      repoTanaman: repoTanaman,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'repo_tanaman_id': repoTanamanId,
      'nama_tanam': namaTanam,
      'tanggal_tanam': tanggalTanam.toIso8601String(),
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
