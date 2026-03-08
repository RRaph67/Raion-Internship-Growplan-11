import 'package:flutter/material.dart';

class UserTanamCard extends StatelessWidget {
  final String namaTanam;
  final String tanggalTanam;
  final String? imageUrl;
  final VoidCallback onTap;

  const UserTanamCard({
    super.key,
    required this.namaTanam,
    required this.tanggalTanam,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Icon(Icons.local_florist, size: 80, color: Colors.green),

            const SizedBox(height: 12),
            Text(
              namaTanam,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "Ditambahkan: $tanggalTanam",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
