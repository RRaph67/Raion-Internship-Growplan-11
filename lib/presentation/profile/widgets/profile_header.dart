import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String username;
  final String? photoUrl;
  final double profileScale;
  final VoidCallback onEditTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.username,
    required this.photoUrl,
    required this.profileScale,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28 * profileScale,
          backgroundColor: const Color(0xFF4E8C2B),
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        SizedBox(width: 12 * profileScale),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppText.semiBold14.copyWith(
                fontSize: 15 * profileScale,
              ),
            ),
            SizedBox(height: 2 * profileScale),
            Text(
              username,
              style: AppText.medium12.copyWith(
                color: Colors.black54,
                fontSize: 12 * profileScale,
              ),
            ),
            SizedBox(height: 6 * profileScale),
            SizedBox(
              height: 25 * profileScale,
              child: ElevatedButton.icon(
                onPressed: onEditTap,
                icon: Icon(Icons.edit, size: 18 * profileScale),
                label: Text(
                  'Edit Profil',
                  style: AppText.medium12.copyWith(
                    fontSize: 13 * profileScale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    80,
                    140,
                    29,
                  ),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15 * profileScale,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
