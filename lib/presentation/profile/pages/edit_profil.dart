import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  final _supabase = Supabase.instance.client;

  String? _photoUrl;
  File? _localPhoto;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final data = user.userMetadata ?? {};
    _nameController.text = (data['name'] ?? 'John Doe').toString();
    _usernameController.text = (data['username'] ?? '@johndoe123').toString();
    _photoUrl = data['avatar_url']?.toString();

    setState(() {});
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    setState(() {
      _localPhoto = File(picked.path);
    });

    // Upload ke Supabase
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final ext = picked.path.split('.').last;
    final filePath = '${user.id}/avatar.$ext';

    await _supabase.storage
        .from('avatar')
        .upload(filePath, _localPhoto!, fileOptions: const FileOptions(upsert: true));

    final publicUrl = _supabase.storage.from('avatar').getPublicUrl(filePath);

    await _supabase.auth.updateUser(
      UserAttributes(data: {'avatar_url': publicUrl}),
    );

    setState(() {
      _photoUrl = publicUrl;
    });
  }

  Future<void> _saveProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _saving = true);

    await _supabase.auth.updateUser(
      UserAttributes(
        data: {
          'name': _nameController.text.trim(),
          'username': _usernameController.text.trim(),
          if (_photoUrl != null) 'avatar_url': _photoUrl,
        },
      ),
    );

    setState(() => _saving = false);
    if (!mounted) return;
    Navigator.pop(context, true); // balik ke profil_kosong
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              Row(
                children: [
                  _RoundIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Edit Profil',
                    style: TextStyle(
                      color: Color(0xFF25410E),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _saving ? null : _saveProfile,
                    icon: const Icon(Icons.check, color: Color(0xFF25410E)),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Avatar + Edit Foto
              Column(
                children: [
                  InkWell(
                    onTap: _pickPhoto,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFE8F1E1),
                      backgroundImage: _localPhoto != null
                          ? FileImage(_localPhoto!)
                          : (_photoUrl != null
                              ? NetworkImage(_photoUrl!)
                              : const AssetImage('assets/icons/home/Logo avatar kamera.png')
                                  as ImageProvider),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Edit foto',
                    style: TextStyle(
                      color: Color(0xFF6ABA27),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      height: 1.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Nama
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama',
                  style: TextStyle(
                    color: Color(0xFF25410E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _RoundedField(controller: _nameController),

              const SizedBox(height: 18),

              // Nama pengguna
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nama pengguna',
                  style: TextStyle(
                    color: Color(0xFF25410E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _RoundedField(controller: _usernameController),

              const SizedBox(height: 20),
              if (_saving) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  const _RoundedField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF25410E), width: 1),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Color(0xFF6ABA27),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xFFF0F8E9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Color(0xFF25410E)),
      ),
    );
  }
}
