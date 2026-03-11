import 'package:flutter/material.dart';

class PenyakitWidget extends StatelessWidget {
  final List<String> namaPenyakit;
  final List<String> deskripsiPenyakit;

  const PenyakitWidget({
    super.key,
    required this.namaPenyakit,
    required this.deskripsiPenyakit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 387,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 387,
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [const Color(0xFFD60000), const Color(0xFF810000)],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            child: Text(
              'Waspada Penyakit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Looping isi array penyakit
          for (int i = 0; i < namaPenyakit.length; i++)
            _buildItem(
              namaPenyakit[i],
              i < deskripsiPenyakit.length ? deskripsiPenyakit[i] : '',
            ),
        ],
      ),
    );
  }

  Widget _buildItem(String nama, String deskripsi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey[300], // placeholder
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    color: const Color(0xFFA10000),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  deskripsi,
                  style: TextStyle(
                    color: const Color(0xFF383838),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
