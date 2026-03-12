import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';
import 'package:flutter_application_1/presentation/profile/pages/edit_profil.dart';
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

    final data = user.userMetadata ?? {};
    setState(() {
      _name = (data['name'] ?? 'John Doe').toString();
      _username = (data['username'] ?? '@johndoe123').toString();
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
    final scale = MediaQuery.of(context).size.width / 390;
    final profileScale = 1.2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F1E1),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: Color(0xFF4E8C2B),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Profile',
                    style: AppText.semiBold18.copyWith(
                      color: const Color(0xFF2F4D1C),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
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
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28 * profileScale,
                      backgroundColor: const Color(0xFF4E8C2B),
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : null,
                      child: _photoUrl == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 12 * profileScale),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: AppText.semiBold14.copyWith(
                            fontSize: 15 * profileScale,
                          ),
                        ),
                        SizedBox(height: 2 * profileScale),
                        Text(
                          _username,
                          style: AppText.medium12.copyWith(
                            color: Colors.black54,
                            fontSize: 12 * profileScale,
                          ),
                        ),
                        SizedBox(height: 6 * profileScale),
                        SizedBox(
                          height: 25 * profileScale,
                          child: ElevatedButton.icon(
                            onPressed: _goToEdit,
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
                ),
                const SizedBox(height: 18),
                Text(
                  'There is no planet B',
                  style: AppText.medium12.copyWith(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 18 * scale,
            top: 160 * scale,
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 18,
                  color: Color(0xFF4E8C2B),
                ),
                const SizedBox(width: 8),
                Text(
                  '0 Postingan',
                  style: AppText.medium12.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 18 * scale,
            right: 18 * scale,
            top: 205 * scale,
            child: const Divider(thickness: 1, color: Color(0xFFE6E6E6)),
          ),

          Positioned(
            left: 50 * scale,
            top: 255 * scale,
            width: 284 * scale,
            height: 284 * scale,
            child: Image.asset(
              'assets/icons/home/belum_punya_tanaman.png',
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            left: 80,
            right: 80,
            top: 555 * scale,
            child: Center(
              child: Text(
                'Belum ada postingan, nih!',
                style: AppText.medium12.copyWith(
                  color: const Color(0xFF2F4D1C),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
