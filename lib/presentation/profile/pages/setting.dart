import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingProfileKosong extends StatelessWidget {
  const SettingProfileKosong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: _RoundBackButton(onTap: () => Navigator.pop(context)),
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

          const _SectionTitle('Bantuan'),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          _MenuItem(iconWidget: _FaqIcon(), title: 'FAQ', onTap: () {}),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          _MenuItem(
            iconWidget: const Icon(
              Icons.star,
              color: Color(0xFF4E4E4E),
              size: 22,
            ),
            title: 'Beri Rating',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          const _SectionTitle('Legal'),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          _MenuItem(
            iconWidget: const Icon(
              Icons.article,
              color: Color(0xFF4E4E4E),
              size: 22,
            ),
            title: 'Syarat Penggunaan',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          _MenuItem(
            iconWidget: _ShieldInfoIcon(),
            title: 'Kebijakan Privasi',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          const _SectionTitle('Logout'),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE6E6E6)),

          _MenuItem(
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

// ===== Widgets =====

class _RoundBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RoundBackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 0, 0, 0)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF4E4E4E),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? trailingColor;

  const _MenuItem({
    required this.iconWidget,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: iconWidget,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? const Color(0xFF4E4E4E),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: trailingColor ?? const Color(0xFF4E4E4E),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}

// FAQ icon: dark circle + white "?"
class _FaqIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF4E4E4E),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

// Shield icon: dark shield + white "i"
class _ShieldInfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: const [
        Icon(Icons.shield, color: Color(0xFF4E4E4E), size: 22),
        Text(
          'i',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}
