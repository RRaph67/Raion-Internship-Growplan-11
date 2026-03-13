import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';
import 'package:flutter_application_1/presentation/profile/pages/edit_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/presentation/profile/pages/setting.dart';

class ProfileEmptyPage extends StatefulWidget {
  const ProfileEmptyPage({super.key});

  @override
  State<ProfileEmptyPage> createState() => _ProfileEmptyPageState();
}

class _ProfileEmptyPageState extends State<ProfileEmptyPage> {
  final _supabase = Supabase.instance.client;

  String _name = 'John Doe';
  String _username = '@johndoe123';
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Mengambil data dari user metadata dan email utama dari auth
    final data = user.userMetadata ?? {};

    setState(() {
      // Nama tetap mengambil dari metadata (display name)
      _name = (data['name'] ?? 'John Doe').toString();

      // Mengubah _username agar berisi EMAIL user
      // Jika email tidak ditemukan, fallback ke metadata username atau string kosong
      _username = user.email ?? (data['username'] ?? '@johndoe123').toString();

      _photoUrl = data['avatar_url']?.toString();
    });
  }

  Future<void> _goToEdit() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfil()),
    );
    if (updated == true) {
      _loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan dimensi agar sama dengan SimpleAppBar
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          // Ukuran mengikuti SimpleAppBar (60)
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              // Mengikuti gaya leading SimpleAppBar
              leading: IconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F8E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Color(0xff305412),
                    size: 24,
                  ),
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xff305412),
                ),
              ),
              // Tombol Menu khusus Profile diletakkan di actions
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingProfileKosong(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Info
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF4E8C2B),
                  backgroundImage: _photoUrl != null
                      ? NetworkImage(_photoUrl!)
                      : null,
                  child: _photoUrl == null
                      ? const Icon(Icons.person, color: Colors.white, size: 35)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: AppText.semiBold18.copyWith(
                          color: const Color(0xFF2F4D1C),
                        ),
                      ),
                      Text(
                        _username,
                        style: AppText.medium12.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton.icon(
                          onPressed: _goToEdit,
                          icon: const Icon(Icons.edit, size: 14),
                          label: const Text('Edit Profil'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4E8C2B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'There is no planet B',
              style: AppText.medium12.copyWith(
                color: Colors.black87,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 32),
            // Post Count Section
            Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  color: Color(0xFF4E8C2B),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  '0 Postingan',
                  style: AppText.semiBold14.copyWith(fontSize: 16),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1, color: Color(0xFFEEEEEE)),

            // Empty State
            const SizedBox(height: 40),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/home/belum_punya_tanaman.png',
                   height: 284,
                   width: 284,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada postingan, nih!',
                    style: AppText.semiBold18.copyWith(
                      color: const Color(0xFF2F4D1C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mulai bagikan pengalaman tanamanmu',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
