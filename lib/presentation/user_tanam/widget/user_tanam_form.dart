import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/widgets/custom_field.dart';
import 'package:flutter_application_1/presentation/home/widgets/button_widget.dart';
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
              const SizedBox(height: 82),

              // Carousel image selector
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
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF305412),
                ),
              ),
              // Dropdown kategori tanaman
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
                        color:
                            Colors.black, // ✅ Warna teks dropdown item: hitam
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedJenis = val),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6ABA27), // ✅ Warna teks dropdown: hijau
                ),
                hint: const Text(
                  "Kategori Tanaman",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6ABA27), // ✅ Warna hint: hijau
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
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF305412),
                ),
              ),
              // TextField nama tanaman pakai CustomField
              CustomField(controller: _namaController, hint: "Nama Tanaman"),

              const SizedBox(height: 10),

              Text(
                'Tanggal Menanam',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF305412),
                ),
              ),
              // Date picker pakai CustomField dengan icon calendar
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
                      size: 20, // ✅ Ukuran sama dengan dropdown
                      color: Color(0xFF6ABA27), // ✅ Warna sama dengan dropdown
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Tombol submit pakai ButtonCustom
              ButtonCustom(
                onPressed: () async {
                  if (_selectedJenis != null &&
                      _tanggalTanam != null &&
                      _selectedImageUrl != null) {
                    final cubit = context.read<UserTanamCubit>();
                    await cubit.addUserTanamByJenis(
                      namaTanam: _namaController.text,
                      tanggalTanam: _tanggalTanam!,
                      jenisTanaman: _selectedJenis!,
                      imageUrl: _selectedImageUrl,
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
          );
        } else if (state is UserTanamError) {
          return Center(child: Text("Error: ${state.message}"));
        }
        return const SizedBox();
      },
    );
  }
}
