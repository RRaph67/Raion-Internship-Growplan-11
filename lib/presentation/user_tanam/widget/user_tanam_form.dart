import 'package:flutter/material.dart';
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
    return BlocBuilder<UserTanamCubit, UserTanamState>(
      builder: (context, state) {
        if (state is RepoTanamanLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is JenisTanamanLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Carousel image selector
              ImageArrowSelector(
                imageUrls: [
                  "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icon_tnm_1.png",
                  "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icon_tnm_2.png",
                  "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icon_tnm_3.png",
                  "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icon_tnm_4.png",
                  "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icon_tnm_5.png",
                  "https://ykliuppxcrlhvjvynjzf.supabase.co/storage/v1/object/public/tanaman_img/icon_tanaman/icon_tnm_6.png",
                ],
                onChanged: (selectedUrl) {
                  _selectedImageUrl = selectedUrl;
                },
              ),

              // Dropdown kategori tanaman (jenis_tanaman unik)
              DropdownButtonFormField<String>(
                value: _selectedJenis,
                items: state.jenisList.map((jenis) {
                  return DropdownMenuItem(value: jenis, child: Text(jenis));
                }).toList(),
                onChanged: (val) => setState(() => _selectedJenis = val),
                decoration: const InputDecoration(
                  labelText: "Kategori Tanaman",
                ),
              ),

              // TextField nama tanaman
              TextField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Tanaman"),
              ),

              // DatePicker
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  setState(() => _tanggalTanam = selectedDate);
                },
                child: Text(
                  _tanggalTanam == null
                      ? "Pilih Tanggal Tanam"
                      : _tanggalTanam.toString(),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol submit
              ElevatedButton(
                onPressed: () async {
                  if (_selectedJenis != null &&
                      _tanggalTanam != null &&
                      _selectedImageUrl != null) {
                    final cubit = context.read<UserTanamCubit>();
                    await cubit.addUserTanamByJenis(
                      namaTanam: _namaController.text,
                      tanggalTanam: _tanggalTanam!,
                      jenisTanaman: _selectedJenis!,
                      imageUrl: _selectedImageUrl, // tambahkan ini
                    );

                    if (cubit.state is UserTanamSuccess) {
                      final newId =
                          (cubit.state as UserTanamSuccess).userTanamId;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              UserTanamDetailPage(userTanamId: newId),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Tambah"),
              )
            ],
          );
        } else if (state is UserTanamError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox();
      },
    );
  }
}
