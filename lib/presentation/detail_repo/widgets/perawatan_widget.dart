// File: lib/presentation/detail_repo/widgets/perawatan_widget.dart
import 'package:flutter/material.dart';

class PerawatanWidget extends StatelessWidget {
  final List<String> perawatan;

  const PerawatanWidget({super.key, required this.perawatan});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ✅ Responsif: Gunakan lebar parent, max 500px
        final maxWidth = constraints.maxWidth;
        final cardWidth = maxWidth > 500 ? 500.0 : maxWidth;

        return Container(
          width: cardWidth,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: const Color(0xFFE2E2E2)),
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
            children: [
              // Header
              Row(
                children: [
                  Image.asset(
                    'assets/icons/detail_plant/persiapan.png', // Pastikan path icon benar
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Perawatan',
                    style: TextStyle(
                      color: const Color(0xFF508C1D),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List Items
              _buildItemList(),
            ],
          ),
        );
      },
    );
  }

  // File: lib/presentation/detail_repo/widgets/perawatan_widget.dart

  Widget _buildItemList() {
    // Judul statis sesuai urutan data di database
    final titles = ['Air', 'Pupuk'];

    // ✅ Tampilkan pesan jika data kosong
    if (perawatan.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Belum ada data perawatan',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: titles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        // ✅ Keamanan: Cek index sebelum akses data
        final value = index < perawatan.length ? perawatan[index] : '-';

        return _buildItem(titles[index], value);
      },
    );
  }

  Widget _buildItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFF0F8E9),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFD1EABC)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF508C1D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.water_drop, // Icon berbeda untuk perawatan
              color: const Color(0xFF508C1D),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF508C1D),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: const Color(0xFF383838),
                    fontSize: 12,
                    height: 1.4,
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
