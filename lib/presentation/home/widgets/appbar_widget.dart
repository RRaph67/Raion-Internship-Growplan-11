import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final String? photoUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onRightIconTap;
  final String rightIconPath;

  const CustomAppBar({
    super.key,
    this.username,
    this.photoUrl,
    this.onAvatarTap,
    this.onRightIconTap,
    required this.rightIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : null,
                  child: photoUrl == null
                      ? const Icon(Icons.person, size: 20)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Hai,',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppPallete.primaryDarker,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        username ?? "No username",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.primaryDarker,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Selamat menanam!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.primaryDarker,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: onRightIconTap,
              child: Image.asset(rightIconPath, width: 30, height: 30),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
