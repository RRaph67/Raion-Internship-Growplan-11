import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';

class PlantInfoWidget extends StatelessWidget {
  final Map<String, dynamic> detail;

  const PlantInfoWidget({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    // Extract nested data
    final repoTanaman = detail['repo_tanaman'] as Map<String, dynamic>?;
    final namaStatis = repoTanaman?['nama_statis'] ?? 'Tanaman';

    // Calculate hari ke-X
    final tanggalTanam = detail['tanggal_tanam'] as String?;
    final hariKe = tanggalTanam != null ? _calculateHariKe(tanggalTanam) : 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Utama: Image (Kiri) + Konten (Kanan)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Kiri 80x164
              SizedBox(
                width: 80,
                height: 164,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    detail['image_url'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Tanaman 24 Bold
                    Text(
                      detail['nama_tanam'] ?? namaStatis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Hari ke-X 16 Medium
                    Text(
                      "Hari ke-$hariKe",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Small Card Rekomendasi
                    Container(
                      width: 103,
                      height: 25,
                      decoration: BoxDecoration(
                        color: AppPallete.primaryDark,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Rekomendasi",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ✅ Menggunakan Row agar kartu tersusun horizontal
                    Row(
                      children: [
                        _buildWateringCard(time: '07.00 - 09.00'),
                        const SizedBox(width: 8),
                        _buildPupukCard(time: '1 Minggu, 1 Kali'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _calculateHariKe(String tanggalTanam) {
    try {
      final tanggal = DateTime.parse(tanggalTanam);
      final sekarang = DateTime.now();
      return sekarang.difference(tanggal).inDays + 1;
    } catch (e) {
      return 1;
    }
  }

  Widget _buildWateringCard({required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 253, 227),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color.fromARGB(255, 47, 200, 0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ Rata Kiri
        children: [
          // Row 1: Icon + Siram (samping)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // ✅ Rata Kiri
            children: [
              // Icon di samping (kiri)
              Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'assets/icons/detail_plant/siram.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              // Text Siram
              const Text(
                "Siram",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Row 2: Jam (di bawah Siram)
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildPupukCard({required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 253, 227),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color.fromARGB(255, 47, 200, 0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // ✅ Rata Kiri
        children: [
          // Row 1: Icon + Siram (samping)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // ✅ Rata Kiri
            children: [
              // Icon di samping (kiri)
              Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  'assets/icons/detail_plant/pupuk.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 8),
              // Text Siram
              const Text(
                "Pupuk",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Row 2: Jam (di bawah Siram)
          Text(
            time,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
