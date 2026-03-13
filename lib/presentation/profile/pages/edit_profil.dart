import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/presentation/profile/cubit/profile_cubit.dart';
import 'package:flutter_application_1/presentation/profile/widgets/round_icon_button.dart';
import 'package:flutter_application_1/presentation/profile/widgets/rounded_field.dart';

class EditProfil extends StatefulWidget {
  const EditProfil({super.key});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();

  String? _photoUrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final data = context.read<ProfileCubit>().getCurrentProfile();
    _nameController.text = data.name;
    _usernameController.text = data.username;
    _photoUrl = data.photoUrl;
    setState(() {});
  }

  Future<void> _pickPhoto() async {
    context.read<ProfileCubit>().updateProfilePhoto(
          source: ImageSource.gallery,
        );
  }

  Future<void> _saveProfile() async {
    setState(() => _saving = true);
    context.read<ProfileCubit>().updateProfile(
          name: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          photoUrl: _photoUrl,
        );
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
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePhotoUpdated) {
            setState(() => _photoUrl = state.photoUrl);
          } else if (state is ProfileSaved) {
            setState(() => _saving = false);
            Navigator.pop(context, true);
          } else if (state is ProfileError) {
            setState(() => _saving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal: ${state.message}')),
            );
          } else if (state is ProfileLoading) {
            setState(() => _saving = true);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              // Top Bar
              Row(
                children: [
                  RoundIconButton(
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
                      backgroundImage: _photoUrl != null
                          ? NetworkImage(_photoUrl!)
                          : const AssetImage('assets/icons/home/Logo avatar kamera.png'),
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
              RoundedField(controller: _nameController),

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
              RoundedField(controller: _usernameController),

              const SizedBox(height: 20),
              if (_saving) const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

