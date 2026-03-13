import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final bool showBackButton;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // ✅ Matikan default leading otomatis dari Flutter agar tidak konflik
        automaticallyImplyLeading: false,
        leading: showBackButton
            ? IconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F8E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xff305412), size: 24,),
                ),

                onPressed: () {
                  if (onBackTap != null) {
                    // Jika ada fungsi khusus (seperti pindah tab di HomePage), jalankan itu
                    onBackTap!();
                  } else {
                    // Default fallback: kembali ke halaman sebelumnya di stack Navigator
                    Navigator.pop(context);
                  }
                },
              )
            : null,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xff305412),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
