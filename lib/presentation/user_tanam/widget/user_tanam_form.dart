// File: user_tanam_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/widgets/custom_field.dart';
import 'package:flutter_application_1/presentation/home/widgets/button_widget.dart';
import 'package:flutter_application_1/presentation/plant_info/cubit/repo_tanam_cubit.dart';
import 'package:flutter_application_1/presentation/plant_info/cubit/repo_tanam_state.dart';
import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_cubit.dart';
import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_state.dart';
import 'package:flutter_application_1/presentation/user_tanam/pages/user_tanam_detail.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/add_image_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTanamForm extends StatefulWidget {
  const UserTanamForm({super.key});

  @override
  State<UserTanamForm> createState() => _UserTanamFormState();
}

class _UserTanamFormState extends State<UserTanamForm> {
  final _namaController = TextEditingController();
  DateTime? _tanggalTanam;
  String? _selectedJenis;
  String? _selectedImageUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepoTanamanCubit, RepoTanamanState>(
      builder: (context, state) {
        if (state is RepoTanamanLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is JenisTanamanLoaded) {
          // Tambahkan BlocListener untuk UserTanamCubit agar bisa handle Success/Error
          return BlocListener<UserTanamCubit, UserTanamState>(
            listener: (context, state) {
              if (state is UserTanamSuccess) {
                final newId = (state as UserTanamSuccess).userTanamId;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserTanamDetailPage(userTanamId: newId),
                  ),
                );
              } else if (state is UserTanamError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gagal menambah tanaman: ${state.message}"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 82),

                ImageArrowSelector(
                  imageUrls: [
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_1.png",
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_2.png",
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_3.png",
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_4.png",
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_5.png",
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_6.png",
                    "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icn_7.png",
                  ],
                  onChanged: (selectedUrl) {
                    _selectedImageUrl = selectedUrl;
                  },
                ),

                const SizedBox(height: 82),
                Text(
                  'Jenis Tanaman',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF305412),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedJenis,
                  items: state.jenisList.map((jenis) {
                    return DropdownMenuItem<String>(
                      value: jenis,
                      child: Text(
                        jenis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedJenis = val),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6ABA27),
                  ),
                  hint: const Text(
                    "Kategori Tanaman",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6ABA27),
                    ),
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: Color(0xFF6ABA27),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: Color(0xFF6ABA27),
                        width: 1,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      size: 32,
                      color: Color(0xFF6ABA27),
                    ),
                  ),
                  isExpanded: true,
                ),

                const SizedBox(height: 10),
                Text(
                  'Nama Tanaman',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF305412),
                  ),
                ),
                CustomField(controller: _namaController, hint: "Nama Tanaman"),

                const SizedBox(height: 10),
                Text(
                  'Tanggal Menanam',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF305412),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    setState(() => _tanggalTanam = selectedDate);
                  },
                  child: AbsorbPointer(
                    child: CustomField(
                      controller: TextEditingController(
                        text: _tanggalTanam == null
                            ? ""
                            : "${_tanggalTanam!.day}-${_tanggalTanam!.month}-${_tanggalTanam!.year}",
                      ),
                      hint: "Tanggal Tanam",
                      suffixIcon: const Icon(
                        Icons.calendar_month,
                        size: 20,
                        color: Color(0xFF6ABA27),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                ButtonCustom(
                  onPressed: () async {
                    // 1. Validasi Input
                    if (_selectedJenis == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pilih Jenis Tanaman")),
                      );
                      return;
                    }
                    if (_tanggalTanam == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pilih Tanggal Tanam")),
                      );
                      return;
                    }
                    if (_selectedImageUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pilih Gambar Tanaman")),
                      );
                      return;
                    }
                    if (_namaController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Nama Tanaman tidak boleh kosong"),
                        ),
                      );
                      return;
                    }

                    // 2. Panggil Cubit
                    try {
                      final cubit = context.read<UserTanamCubit>();
                      await cubit.addUserTanamByJenis(
                        namaTanam: _namaController.text,
                        tanggalTanam: _tanggalTanam!,
                        jenisTanaman: _selectedJenis!,
                        imageUrl: _selectedImageUrl!,
                      );
                      // Navigasi ditangani oleh BlocListener di atas
                    } catch (e) {
                      print("Error di Form: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Terjadi kesalahan: $e")),
                      );
                    }
                  },
                  buttonContent: const Text(
                    "Tambah",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  borderRadius: 30.0,
                  backgroundColor: const Color(0xFF508C1D),
                ),
              ],
            ),
          );
        } else if (state is RepoTanamanError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox();
      },
    );
  }
}
