import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';
import 'package:flutter_application_1/presentation/profile/pages/edit_profil.dart';
import 'package:flutter_application_1/presentation/profile/pages/setting.dart';
import 'package:flutter_application_1/presentation/profile/widgets/profile_header.dart';
import 'package:flutter_application_1/presentation/profile/widgets/profile_stat_row.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/presentation/profile/cubit/profile_cubit.dart';

class ProfileEmptyPage extends StatefulWidget {
  const ProfileEmptyPage({super.key});

  @override
  State<ProfileEmptyPage> createState() => _ProfileEmptyPageState();
}

class _ProfileEmptyPageState extends State<ProfileEmptyPage> {
  String _name = 'John Doe';
  String _username = '@johndoe123';
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final data = context.read<ProfileCubit>().getCurrentProfile();
    setState(() {
      _name = data.name;
      _username = data.username;
      _photoUrl = data.photoUrl;
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
                ProfileHeader(
                  name: _name,
                  username: _username,
                  photoUrl: _photoUrl,
                  profileScale: profileScale,
                  onEditTap: _goToEdit,
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
            child: const ProfileStatRow(label: '0 Postingan'),
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
