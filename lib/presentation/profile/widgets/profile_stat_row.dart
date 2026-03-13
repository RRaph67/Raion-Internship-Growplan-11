import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';

class ProfileStatRow extends StatelessWidget {
  final String label;

  const ProfileStatRow({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.menu_book_outlined,
          size: 18,
          color: Color(0xFF4E8C2B),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppText.medium12.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
