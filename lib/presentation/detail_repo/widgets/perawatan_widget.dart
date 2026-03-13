import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF508C1D);
  static const Color lightGreenBg = Color(0xFFF0F8E9);
  static const Color lightGreenBorder = Color(0xFFD1EABC);
  static const Color borderColor = Color(0xFFE2E2E2);
  static const Color textColor = Color(0xFF383838);
}

class PerawatanWidget extends StatelessWidget {
  final List<String> perawatan;

  const PerawatanWidget({super.key, required this.perawatan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 388,
          padding: const EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.borderColor),
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
            mainAxisSize:
                MainAxisSize.min, 
            children: [
              // Header: Icon + Judul
              Row(
                children: [
                  Image.asset(
                    'assets/icons/detail_plant/persiapan.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.assignment_outlined,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Perawatan',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w800,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), 
              _buildItemList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemList() {
    final titles = ['Penyiraman', 'Pemupukan',];

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero, 
      physics: const NeverScrollableScrollPhysics(),
      itemCount: titles.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final value = index < perawatan.length
            ? perawatan[index]
            : 'Data tidak tersedia';
        return _buildItem(titles[index], value);
      },
    );
  }

  Widget _buildItem(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: AppColors.lightGreenBg,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.lightGreenBorder),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.opacity, // Icon air/perawatan
                color: AppColors.primaryGreen,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textColor,
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
