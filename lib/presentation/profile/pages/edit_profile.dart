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
  final _emailController = TextEditingController();

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

    // Mengambil email dari objek user dan memasukkannya ke controller
    _emailController.text = user.email ?? '';

    _photoUrl = data['avatar_url']?.toString();

    setState(() {});
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return;

    setState(() {
      _localPhoto = File(picked.path);
    });

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final ext = picked.path.split('.').last;
    final filePath = '${user.id}/avatar.$ext';

    try {
      await _supabase.storage
          .from('avatar')
          .upload(
            filePath,
            _localPhoto!,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _supabase.storage.from('avatar').getPublicUrl(filePath);

      await _supabase.auth.updateUser(
        UserAttributes(data: {'avatar_url': publicUrl}),
      );

      setState(() {
        _photoUrl = publicUrl;
      });
    } catch (e) {
      debugPrint("Error uploading photo: $e");
    }
  }

  Future<void> _saveProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() => _saving = true);

    try {
      await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            'name': _nameController.text.trim(),
            // Email tidak ikut disimpan karena bersifat read-only / tidak bisa diubah di sini
            if (_photoUrl != null) 'avatar_url': _photoUrl,
          },
        ),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Error saving profile: $e");
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
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
              'Edit Profil',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xff305412),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _saving ? null : _saveProfile,
                icon: const Icon(
                  Icons.check,
                  color: Color(0xff305412),
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar + Edit Foto
              Column(
                children: [
                  InkWell(
                    onTap: _pickPhoto,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFE8F1E1),
                      backgroundImage: _localPhoto != null
                          ? FileImage(_localPhoto!)
                          : (_photoUrl != null
                                ? NetworkImage(_photoUrl!)
                                : null),
                      child: (_localPhoto == null && _photoUrl == null)
                          ? Image.asset('assets/edit_camera.png', width: 60)
                          : null,
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
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Field Nama (Bisa diedit)
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

              // Field Email (Read-only)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xFF25410E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Menambahkan parameter readOnly: true agar tidak bisa diedit
              _RoundedField(controller: _emailController, readOnly: true),

              const SizedBox(height: 30),
              if (_saving)
                const CircularProgressIndicator(color: Color(0xFF6ABA27)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const _RoundedField({required this.controller, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        // Memberikan warna background sedikit abu-abu jika read-only
        color: readOnly ? Colors.grey[100] : Colors.white,
        border: Border.all(
          color: readOnly ? const Color(0xFFBCCBB0) : const Color(0xFF25410E),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
        style: TextStyle(
          // Memberikan warna teks yang lebih pudar jika read-only
          color: readOnly
              ? const Color(0xFF25410E).withOpacity(0.5)
              : const Color(0xFF6ABA27),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
