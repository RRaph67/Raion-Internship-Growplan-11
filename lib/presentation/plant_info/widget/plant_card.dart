import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String imageUrl;
  final String namaAsli;
  final String namaIlmiah;

  const PlantCard({
    super.key,
    required this.imageUrl,
    required this.namaAsli,
    required this.namaIlmiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 202,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BAGIAN ATAS: Gambar Tanaman
          Expanded(
            flex: 5, // Mengambil 5 bagian dari tinggi total
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // biar gambar menutup penuh
                  width: double.infinity, // isi penuh lebar card
                  height: double.infinity, // isi penuh tinggi Expanded flex
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
              ),
            ),
          ),

          // BAGIAN BAWAH: Teks dan Tombol
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris 1: Nama Asli + Panah (Sejajar)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          namaAsli,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            overflow: TextOverflow
                                .ellipsis, // Agar teks tidak keluar jika terlalu panjang
                          ),
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons
                            .arrow_forward_ios, // Panah menghadap kanan (karena di kanan)
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),

                  // Baris 2: Nama Ilmiah
                  Text(
                    namaIlmiah,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
