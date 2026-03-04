import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/core/theme/app_text.dart';
import 'package:flutter_application_1/data/models/user_model.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/auth/pages/login_page.dart';
import 'package:flutter_application_1/presentation/auth/widgets/custom_field.dart';
import 'package:flutter_application_1/presentation/profile/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameCont = TextEditingController();
  final emailCont = TextEditingController();
  late UserModel user;
  String? _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthCubit>().state;
    if (state is AuthSuccess) {
      user = state.user;
      nameCont.text = state.user.nama!;
      emailCont.text = state.user.email!;
      _currentPhotoUrl = state.user.fotoProfil!;
    }
  }

  @override
  void dispose() {
    nameCont.dispose();
    emailCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Mengupload foto...')));
          } else if (state is ProfilePhotoUpdated) {
            setState(() {
              _currentPhotoUrl = state.photoUrl;
            });
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Foto profil berhasil diubah!')),
              );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Gagal: ${state.message}')),
              );
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.heightOf(context) * 0.2),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 15,
                  children: [
                    Text(
                      'Akun dan Profil',
                      textAlign: TextAlign.center,
                      style: AppText.semiBold22,
                    ),
                    const SizedBox(),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _currentPhotoUrl != null
                                ? NetworkImage(_currentPhotoUrl!)
                                : null,
                            child: _currentPhotoUrl == null
                                ? const Icon(Icons.person, size: 90)
                                : null,
                          ),
                          GestureDetector(
                            onTap: () => _showPhotoDialog(context),
                            child: const CircleAvatar(
                              backgroundColor: AppPallete.primaryNormal,
                              child: Icon(
                                Icons.edit_square,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(),

                    Text(
                      'Nama Pengguna',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF305412),
                      ),
                    ),
                    CustomField(
                      hint: "Nama Pengguna",
                      controller: nameCont,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama tidak boleh kosong";
                        }
                        return null;
                      },
                    ),

                    Text(
                      'Email Pengguna',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF305412),
                      ),
                    ),
                    CustomField(
                      hint: "Email Pengguna",
                      controller: emailCont,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Nama tidak boleh kosong";
                        }
                        if (!value.contains('@')) {
                          return "Email tidak valid! coba lagi";
                        }
                        return null;
                      },
                    ),

                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {

                            return AlertDialog(
                              title: const Text(
                                'Yakin ingin Log out?',
                                style: AppText.semiBold18,
                                textAlign: TextAlign.center,
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              contentPadding: EdgeInsets.all(20),
                              insetPadding: EdgeInsets.all(20),
                              actions: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: const Text(
                                      'Batal',
                                      style: AppText.semiBold14,
                                    ),
                                  ),
                                ),
                                BlocListener<AuthCubit, AuthState>(
                                  listener: (context, state) {
                                    if (state is AuthInitial) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LogIn(),
                                        ),
                                      );
                                    }
                                  },
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await context.read<AuthCubit>().logout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppPallete.errorNormal,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        'Iya',
                                        style: AppText.semiBold14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPallete.errorNormal,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Log out', style: AppText.semiBold16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            spacing: 10,
            children: [
              Icon(Icons.add_a_photo_outlined),
              Text(
                'Ubah Foto Profil',
                style: AppText.medium16,
                textAlign: TextAlign.left,
              ),
            ],
          ),
          actions: [
            ListTile(
              title: Text('Ambil foto baru'),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              trailing: Icon(Icons.photo_camera_outlined),
              onTap: () {
                Navigator.pop(dialogContext);
                context.read<ProfileCubit>().updateProfilePhoto(
                  source: ImageSource.camera,
                );
              },
            ),
            ListTile(
              title: Text('Pilih dari galeri'),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              trailing: Icon(Icons.image_outlined),
              onTap: () {
                Navigator.pop(dialogContext);
                context.read<ProfileCubit>().updateProfilePhoto(
                  source: ImageSource.gallery,
                );
              },
            ),
          ],
          contentPadding: EdgeInsets.all(20),
          insetPadding: EdgeInsets.all(20),
        );
      },
    );
  }
}
