// File: lib/presentation/user_tanam/widget/user_tanam_card.dart
import 'package:flutter/material.dart';

class UserTanamCard extends StatelessWidget {
  final int id;
  final String? imageUrl;
  final String namaTanam;
  final String tanggalTanam;
  final VoidCallback onTap;

  const UserTanamCard({
    super.key,
    required this.id,
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
        width: 168,
        height: 202,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: _buildImage(context),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            namaTanam,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.more_vert,
                          size: 16,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Text(
                      "$tanggalTanam",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {

    if (imageUrl == null ||
        imageUrl!.isEmpty ||
        imageUrl!.startsWith('file://') ||
        !imageUrl!.startsWith('http://') && !imageUrl!.startsWith('https://')) {
      return const Center(
        child: Icon(Icons.local_florist, size: 80, color: Colors.green),
      );
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        );
      },
    );
  }
}
