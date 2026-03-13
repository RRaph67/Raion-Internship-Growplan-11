import 'package:flutter/material.dart';

class RingkasanWidget extends StatelessWidget {
  final String ringkasan;

  const RingkasanWidget({super.key, required this.ringkasan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 388,
          // Menghapus 'height: 120' agar container menyesuaikan tinggi konten secara otomatis
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize
                .min, // Memastikan column hanya memakan ruang sekecil mungkin
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/detail_plant/ringkas.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ringkasan',
                    style: TextStyle(
                      color: Color(0xFF508C1D),
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ), // Jarak rapat sesuai preferensi desain sebelumnya
              Text(
                ringkasan,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Color(0xFF383838),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.4, // Menambah line height agar lebih nyaman dibaca
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
