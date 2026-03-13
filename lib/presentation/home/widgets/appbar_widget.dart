import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final String? photoUrl;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onRightIconTap;
  final String rightIconPath;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.username,
    this.photoUrl,
    this.onAvatarTap,
    this.onRightIconTap,
    required this.rightIconPath,
    this.showBackButton = false,
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        titleSpacing: showBackButton ? 0 : 16,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                // Validasi URL sebelum load NetworkImage
                backgroundImage: _isValidUrl(photoUrl)
                    ? NetworkImage(photoUrl!)
                    : null,
                child: _isValidUrl(photoUrl)
                    ? null
                    : const Icon(Icons.person, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                      username ?? "User",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: onRightIconTap,
              child: Image.asset(rightIconPath, width: 28, height: 28),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Method Validasi URL
  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
