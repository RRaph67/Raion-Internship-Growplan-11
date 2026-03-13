import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/presentation/profile/widgets/section_title.dart';
import 'package:flutter_application_1/presentation/profile/widgets/menu_item.dart';
import 'package:flutter_application_1/presentation/profile/widgets/faq_icon.dart';
import 'package:flutter_application_1/presentation/profile/widgets/shield_info_icon.dart';

class SettingProfileKosong extends StatelessWidget {
  const SettingProfileKosong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Color(0xFF25410E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.8,
      ),
      body: ListView(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          const SectionTitle('Bantuan'),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          MenuItem(iconWidget: const FaqIcon(), title: 'FAQ', onTap: () {}),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          MenuItem(
            iconWidget: const Icon(
              Icons.star,
              color: Color(0xFF4E4E4E),
              size: 22,
            ),
            title: 'Beri Rating',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          const SectionTitle('Legal'),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          MenuItem(
            iconWidget: const Icon(
              Icons.article,
              color: Color(0xFF4E4E4E),
              size: 22,
            ),
            title: 'Syarat Penggunaan',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          MenuItem(
            iconWidget: const ShieldInfoIcon(),
            title: 'Kebijakan Privasi',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          const SectionTitle('Logout'),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          MenuItem(
            iconWidget: const Icon(
              Icons.logout,
              color: Color(0xFFD60000),
              size: 22,
            ),
            title: 'Keluar',
            titleColor: const Color(0xFFD60000),
            trailingColor: const Color(0xFFD60000),
            onTap: () async {
              await context.read<AuthCubit>().logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          const SizedBox(height: 40),

          const Center(
            child: Text(
              '@ Growplant',
              style: TextStyle(
                color: Color(0xFF4E4E4E),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Version: 1.0',
              style: TextStyle(
                color: Color(0xFF4E4E4E),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

