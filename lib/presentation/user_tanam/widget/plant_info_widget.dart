// File: lib/presentation/user_tanam/widget/plant_info_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/data/models/user_tanam_model.dart';

class PlantInfoWidget extends StatelessWidget {
  final UserTanamModel detail;
  final int daysSincePlanted;

  const PlantInfoWidget({
    super.key,
    required this.detail,
    required this.daysSincePlanted,
  });

  @override
  Widget build(BuildContext context) {
    final namaStatis = detail.repoTanaman?.namaStatis ?? 'Tanaman';
    final hariKe = daysSincePlanted;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            height: 164,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(detail.imageUrl),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.namaTanam ?? namaStatis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Hari ke-$hariKe",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
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
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image, color: Colors.grey),
      );
    }

    // ✅ Validasi URL
    final isValidUrl =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

    if (!isValidUrl) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image, color: Colors.grey),
      ),
    );
  }

  Widget _buildWateringCard({required String time}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 230, 253, 227),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: const Color.fromARGB(255, 47, 200, 0)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/detail_plant/siram.png',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
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
        Text(time, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    ),
  );

  Widget _buildPupukCard({required String time}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 230, 253, 227),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: const Color.fromARGB(255, 47, 200, 0)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/detail_plant/pupuk.png',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
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
        Text(time, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    ),
  );
}
